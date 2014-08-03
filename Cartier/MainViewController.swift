//
//  MainViewController.swift
//  Cartier
//
//  Created by Gianni Settino on 2014-07-17.
//  Copyright (c) 2014 Milton and Parc. All rights reserved.
//

import UIKit
import CoreLocation
import GPUImage
import QuartzCore

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    /* Constants */
    let circleRadius: Float = 75
    let circleAnimDuration = 0.3
    let circleAlpha: Float = 0.6
    
    var backgroundOpacity: Float = 0.6
    
    var videoCamera: GPUImageVideoCamera?
    var videoView: GPUImageView?
    var iosBlurFilter: GPUImageiOSBlurFilter?
    var coloredOverlayView: UIView?
    
    var opacitySlider: UISlider?
    
    var circle: UIView?
    var circleIsNormalSize = true
    
    var locationManager = CLLocationManager()
    let afNetworkingManager = AFHTTPRequestOperationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: .Back)
        
        //setupBackgroundView()
        setupCircle()
        
        if videoCamera {
            setupLiveBlurBackground()
            //setupSwitchAndSliders()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        
        if !circleIsNormalSize {
            UIView.animateWithDuration(1.2, animations: {
                self.setCircleAlphaTo(self.circleAlpha)
                }, completion: {
                    didFinish in
                    self.shrinkCircle()
                })
        }
    }
    
    func setupBackgroundView() {
        coloredOverlayView = UIView(frame: self.view.frame)
        coloredOverlayView!.backgroundColor = UIColor(red: 0.086, green: 0.627, blue: 0.522, alpha: 1)
        coloredOverlayView!.alpha = backgroundOpacity
        self.view.addSubview(coloredOverlayView)
    }
    
    func setupLiveBlurBackground() {
        // Setup the camera
        videoCamera!.outputImageOrientation = .Portrait
        //videoCamera!.inputCamera.focusMode = .Locked
        
        // Create the video view
        videoView = GPUImageView(frame: self.view.frame)
        self.view.addSubview(videoView)
        self.view.sendSubviewToBack(videoView)
        
        // Create the iOS blur filter
        iosBlurFilter = GPUImageiOSBlurFilter()
        iosBlurFilter!.rangeReductionFactor = 0.0
        iosBlurFilter!.blurRadiusInPixels = 6.0
        
        // Link everything together and start the camera capture!
        videoCamera?.addTarget(iosBlurFilter)
        iosBlurFilter?.addTarget(videoView)
        videoCamera?.startCameraCapture()
    }
    
    func setupSwitchAndSliders() {
        println("self.view.frame = \(self.view.frame)")
        
        var backgroundSwitch = UISwitch(frame: CGRectMake(0.0, 20.0+10.0, 0.0, 0.0)) //size components are ignored
        var modifiedFrame = backgroundSwitch.frame
        modifiedFrame.origin.x = self.view.frame.width - modifiedFrame.width - 5.0
        backgroundSwitch.frame = modifiedFrame
        backgroundSwitch.tintColor = UIColor.whiteColor()
        backgroundSwitch.onTintColor = UIColor.whiteColor()
        backgroundSwitch.on = true
        backgroundSwitch.addTarget(self, action: "switchChanged:", forControlEvents: .ValueChanged)
        self.view.addSubview(backgroundSwitch)
        println("backgroundSwitch.frame = \(backgroundSwitch.frame)")
        
        opacitySlider = UISlider(frame: CGRectMake(5.0, 30.0, 249.0, 31.0))
        opacitySlider!.tintColor = UIColor.whiteColor()
        opacitySlider!.thumbTintColor = UIColor.redColor()
        opacitySlider!.minimumValue = 0.0
        opacitySlider!.maximumValue = 1.0
        opacitySlider!.value = backgroundOpacity
        opacitySlider!.addTarget(self, action: "opacitySliderChanged", forControlEvents: .ValueChanged)
        self.view.addSubview(opacitySlider)
        println("opacitySlider.frame = \(opacitySlider!.frame)")
    }
    
    func setupCircle() {
        circle = UIView(frame: CGRectMake(CGRectGetMidX(self.view.frame)-circleRadius, CGRectGetMidY(self.view.frame)-circleRadius, 2*circleRadius, 2*circleRadius))
        setCircleAlphaTo(circleAlpha)
        circle!.layer.cornerRadius = circleRadius
        
        self.view.addSubview(circle)
        
        // Handle clicks on circleView
        var singleTap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        circle!.addGestureRecognizer(singleTap)
    }
    
    func handleSingleTap(sender: UITapGestureRecognizer) {
        if circleIsNormalSize {
            locationManager.startUpdatingLocation()
            growCircle()
        }
    }
    
    func growCircle() {
        var growAnimation = CABasicAnimation(keyPath: "transform.scale")
        growAnimation.duration = circleAnimDuration
        growAnimation.toValue = 5
        growAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        growAnimation.fillMode = kCAFillModeForwards
        growAnimation.removedOnCompletion = false
        growAnimation.delegate = self
        
        circle!.layer.addAnimation(growAnimation, forKey: "growAnimation")
        circleIsNormalSize = false
    }
    
    func shrinkCircle() {
        var shrinkAnimation = CABasicAnimation(keyPath: "transform.scale")
        shrinkAnimation.duration = circleAnimDuration
        shrinkAnimation.toValue = 1
        shrinkAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        shrinkAnimation.fillMode = kCAFillModeForwards
        shrinkAnimation.removedOnCompletion = false
        shrinkAnimation.delegate = self
        
        circle!.layer.addAnimation(shrinkAnimation, forKey: "shrinkAnimation")
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        let basicAnim = anim as CABasicAnimation
        if (basicAnim.toValue as Float == 5) {
            UIView.animateWithDuration(1.2, animations: {
                self.setCircleAlphaTo(1)
                })
        } else if (basicAnim.toValue as Float == 1) {
            circleIsNormalSize = true
        }
    }
    
    func setCircleAlphaTo(newAlpha: CGFloat) {
        self.circle!.backgroundColor = UIColor(red: 0.086, green: 0.627, blue: 0.522, alpha: newAlpha)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: AnyObject[]) {
        locationManager.stopUpdatingLocation()
        
        var userLocation: CLLocation = locations[locations.endIndex - 1] as CLLocation
        
        // Find foursquare places around here
        var urlString = "https://api.foursquare.com/v2/venues/explore?client_id=35UH1ZRV1LML4OMHUNV2CISGII0GHFILV3Z1CHDBQB5WHIO1&client_secret=5NCVL2KJG5WDNS4KX2ZR5SVP3UDMFJNZL04LSHJLLDL5ZY0G&ll=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&v=20140803"
        afNetworkingManager.GET(urlString, parameters: nil, success: {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            let responseDict = responseObject as Dictionary<String, AnyObject>
            let subDict = responseDict["response"] as Dictionary<String, AnyObject>?
            //let subDict2 : AnyObject? = subDict["groups"]
            //let subDict3 : AnyObject? =
            //println(responseDict["response"].
            
            var detailViewController = DetailViewController(style: .Grouped)
            self.navigationController.pushViewController(detailViewController, animated: false)
            }, failure: { operation, error in println(error) })
    }

    func switchChanged(backgroundSwitch: UISwitch) {
        UIView.animateWithDuration(1.0, animations: {
            self.coloredOverlayView!.alpha = backgroundSwitch.on ? self.backgroundOpacity : 0.0
        })
        UIView.animateWithDuration(0.5, animations: {
            self.opacitySlider!.alpha = backgroundSwitch.on ? 1.0 : 0.0
            })
    }
    
    func opacitySliderChanged() {
        self.backgroundOpacity = self.opacitySlider!.value
        self.coloredOverlayView!.alpha = backgroundOpacity
    }
}
