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
    var overlayView:UIView?
    var videoView:GPUImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Cartier"
        
        // Initialize the camera
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: .Back)
        videoCamera!.outputImageOrientation = .Portrait
        
        // Create our video view
        videoView = GPUImageView(frame: self.view.frame)
        self.view.addSubview(videoView)
        
        // Create white overlay view
        overlayView = UIView(frame: self.view.frame)
        overlayView!.backgroundColor = UIColor.whiteColor()
        overlayView!.alpha = 0.6;
        self.view.addSubview(overlayView)
        
        videoCamera?.addTarget(videoView)
        videoCamera?.startCameraCapture()
    }
    
}
