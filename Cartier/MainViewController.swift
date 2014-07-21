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
    
    var videoCamera:GPUImageVideoCamera?
    var videoView:GPUImageView?
    var whiteOverlayView:UIView?
    var gaussianBlurFilter:GPUImageGaussianBlurFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Cartier"
        
        // Initialize the camera
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: .Back)
        videoCamera!.outputImageOrientation = .Portrait
        
        // Create the video view
        videoView = GPUImageView(frame: self.view.frame)
        self.view.addSubview(videoView)
        
        // Create white overlay view
        whiteOverlayView = UIView(frame: self.view.frame)
        whiteOverlayView!.backgroundColor = UIColor.whiteColor()
        whiteOverlayView!.alpha = 0.6;
        self.view.addSubview(whiteOverlayView)
        
        // Create the Gaussian blur filter
        gaussianBlurFilter = GPUImageGaussianBlurFilter()
        
        // Link everything together and start the camera capture!
        videoCamera?.addTarget(gaussianBlurFilter)
        gaussianBlurFilter?.addTarget(videoView)
        videoCamera?.startCameraCapture()
    }
    
}
