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
    var filter:GPUImagePixellateFilter?
    var videoView:GPUImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Cartier"
        
        // Initialize the camera
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset640x480, cameraPosition: .Back)
        videoCamera!.outputImageOrientation = .Portrait
        
        // Initialize the filter
        filter = GPUImagePixellateFilter()
        videoCamera?.addTarget(filter)
        
        // Create our view, add it as a target of our filter, and star the camera!
        videoView = GPUImageView(frame: self.view.frame)
        self.view.addSubview(videoView)
        filter?.addTarget(videoView)
        videoCamera?.startCameraCapture()
    }
    
}
