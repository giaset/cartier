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

class MainViewController: UIViewController {
    
    var videoCamera: GPUImageVideoCamera?
    var videoView: GPUImageView?
    var iosBlurFilter: GPUImageiOSBlurFilter?
    var coloredOverlayView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cartier"
        self.view.backgroundColor = UIColor.whiteColor()
        
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: .Back)
        
        if videoCamera {
            setupLiveBlurBackground()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupLiveBlurBackground() {
        // Setup the camera
        videoCamera!.outputImageOrientation = .Portrait
        //videoCamera!.inputCamera.focusMode = AVCaptureFocusMode
        
        // Create the video view
        videoView = GPUImageView(frame: self.view.frame)
        self.view.addSubview(videoView)
        
        // Create the iOS blur filter
        iosBlurFilter = GPUImageiOSBlurFilter()
        iosBlurFilter!.rangeReductionFactor = 0.0
        iosBlurFilter!.blurRadiusInPixels = 6.0
        
        // Create the colored overlay view over top of everything
        coloredOverlayView = UIView(frame: self.view.frame)
        coloredOverlayView!.backgroundColor = UIColor.blueColor()
        coloredOverlayView!.alpha = 0.2
        self.view.addSubview(coloredOverlayView)
        
        // Link everything together and start the camera capture!
        videoCamera?.addTarget(iosBlurFilter)
        iosBlurFilter?.addTarget(videoView)
        videoCamera?.startCameraCapture()
    }
    
}
