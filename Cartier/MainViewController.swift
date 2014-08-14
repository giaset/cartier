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
    let circleRadius: CGFloat = 75
    let circleAnimDuration = 0.3
    let circleAlpha: CGFloat = 0.6
    let customBackgroundAlpha: CGFloat = 0.4
    
    var videoCamera: GPUImageVideoCamera? = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: .Back)
    var videoView: GPUImageView?
    var iosBlurFilter = GPUImageiOSBlurFilter()
    var customBackgroundView: UIView?
    
    var circle: UIView?
    var circleIsNormalSize = true
    var circleStartingCenter = CGPointMake(0, 0)
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomBackgroundView()
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
    
    func setupCustomBackgroundView() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        customBackgroundView = UIView(frame: self.view.frame)
        customBackgroundView!.backgroundColor = UIColor.whiteColor()
        customBackgroundView!.alpha = customBackgroundAlpha
        self.view.addSubview(customBackgroundView)
        
        var littleStatusBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        littleStatusBar.backgroundColor = UIColor(red: 0.086, green: 0.627, blue: 0.522, alpha: circleAlpha)
        self.view.addSubview(littleStatusBar)
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
        iosBlurFilter.rangeReductionFactor = 0.0
        iosBlurFilter.blurRadiusInPixels = 6.0
        
        // Link everything together and start the camera capture!
        videoCamera?.addTarget(iosBlurFilter)
        iosBlurFilter.addTarget(videoView)
        videoCamera?.startCameraCapture()
    }
    
    func setupCircle() {
        circle = UIView(frame: CGRect(x: CGRectGetMidX(self.view.frame)-circleRadius, y: CGRectGetMidY(self.view.frame)-circleRadius, width: 2*circleRadius, height: 2*circleRadius))
        circleStartingCenter = circle!.center
        setCircleAlphaTo(circleAlpha)
        circle!.layer.cornerRadius = circleRadius
        
        self.view.addSubview(circle)
        
        // Handle clicks on circleView
        var singleTap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        circle!.addGestureRecognizer(singleTap)
        
        // Handle drags on circleView
        var drag = UIPanGestureRecognizer(target: self, action: "handleDrag:")
        circle!.addGestureRecognizer(drag)
    }
    
    func handleSingleTap(sender: UITapGestureRecognizer) {
        if circleIsNormalSize {
            locationManager.startUpdatingLocation()
            scaleCircleTo(5)
            circleIsNormalSize = false
        }
    }
    
    func handleDrag(sender: UIPanGestureRecognizer) {
        if circleIsNormalSize {
            circle!.center = circleStartingCenter.plus(sender.translationInView(self.view))
            
            if (sender.state == .Ended) {
                UIView.animateWithDuration(0.2, animations: {
                    self.circle!.center = self.circleStartingCenter
                    })
            }
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

extension CGPoint {
    
    func plus (otherPoint: CGPoint) -> CGPoint {
        return CGPointMake(self.x + otherPoint.x, self.y + otherPoint.y)
    }
    
}
