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
    var iosBlurFilter:GPUImageiOSBlurFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cartier"
        
        setupLiveBlurBackground()
    }
    
    func setupLiveBlurBackground() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Initialize the camera
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: .Back)
        videoCamera!.outputImageOrientation = .Portrait
        
        // Create the video view
        videoView = GPUImageView(frame: self.view.frame)
        self.view.addSubview(videoView)
        
        // Create the iOS blur filter
        iosBlurFilter = GPUImageiOSBlurFilter()
        
        // Link everything together and start the camera capture!
        videoCamera?.addTarget(iosBlurFilter)
        iosBlurFilter?.addTarget(videoView)
        videoCamera?.startCameraCapture()
    }
    
}
