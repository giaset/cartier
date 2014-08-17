//
//  NetworkingManager.swift
//  Cartier
//
//  Created by Gianni Settino on 2014-08-04.
//  Copyright (c) 2014 Milton and Parc. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkingManager: NSObject {
    
    let afNetworkingManager: AFHTTPRequestOperationManager
    
    init() {
        afNetworkingManager = AFHTTPRequestOperationManager()
        afNetworkingManager.responseSerializer = AFJSONResponseSerializer()
    }
    
    // From StackOverflow, how to create Singletons in Swift
    class var sharedInstance: NetworkingManager {
        struct Static {
            static let instance: NetworkingManager = NetworkingManager()
        }
        return Static.instance
    }
    
    func getClosestAttractionForCoordinates(coordinates: CLLocationCoordinate2D, onComplete: (AnyObject!) -> ()) {
        var urlString = "http://nonna.herokuapp.com/knows?lat=\(coordinates.latitude)&lng=\(coordinates.longitude)"
        
        func success(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) {
            onComplete(responseObject)
        }
        
        afNetworkingManager.GET(urlString, parameters: nil, success: success, failure: popError)
    }
    
    func popError(operation: AFHTTPRequestOperation!, error: NSError!) {
        // Legacy support for UIAlertViews, which are deprecated starting in iOS8
        var errorAlert = UIAlertView()
        errorAlert.title = "Network Error"
        errorAlert.message = error.description
        errorAlert.addButtonWithTitle("Ok")
        
        errorAlert.show()
    }
    
}