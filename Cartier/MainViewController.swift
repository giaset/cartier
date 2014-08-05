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
    
    var videoCamera: GPUImageVideoCamera?
    var videoView: GPUImageView?
    var iosBlurFilter: GPUImageiOSBlurFilter?
    
    var circle: UIView?
    var circleIsNormalSize = true
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: .Back)
        
        setupCircle()
        
        if videoCamera {
            setupLiveBlurBackground()
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
                    self.scaleCircleTo(1)
                })
        }
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
            scaleCircleTo(5)
            circleIsNormalSize = false
        }
    }
    
    func scaleCircleTo(desiredScale: Float) {
        var scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = circleAnimDuration
        scaleAnimation.toValue = desiredScale
        scaleAnimation.fillMode = kCAFillModeForwards
        scaleAnimation.removedOnCompletion = false
        scaleAnimation.delegate = self
        
        if (desiredScale == 1) {
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            circle!.layer.addAnimation(scaleAnimation, forKey: "shrinkAnimation")
        } else {
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            circle!.layer.addAnimation(scaleAnimation, forKey: "growAnimation")
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        let basicAnim = anim as CABasicAnimation
        if (basicAnim.toValue as Float == 5) {
            UIView.animateWithDuration(1.2, animations: {
                self.setCircleAlphaTo(1)
                }, completion: {
                    didFinish in
                    var detailViewController = DetailViewController(style: .Grouped)
                    self.navigationController.pushViewController(detailViewController, animated: false)
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
        
        NetworkingManager.sharedInstance.findFoursquarePlaces(userLocation.coordinate)
    }
}
