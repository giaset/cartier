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
    
    let foursquareClientId = "35UH1ZRV1LML4OMHUNV2CISGII0GHFILV3Z1CHDBQB5WHIO1"
    let foursquareClientSecret = "5NCVL2KJG5WDNS4KX2ZR5SVP3UDMFJNZL04LSHJLLDL5ZY0G"
    let foursquareVersion = "20140803"
    
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
    
    func findFoursquarePlaces(coordinates: CLLocationCoordinate2D) {
        var urlString = "http://nonna.herokuapp.com/?lat=\(coordinates.latitude)&lng=\(coordinates.longitude)"
        
        func success(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) {
            println(responseObject)
        }
        
        afNetworkingManager.GET(urlString, parameters: nil, success: success, failure: popError)
        /*var urlString = "https://api.foursquare.com/v2/venues/explore?client_id=\(foursquareClientId)&client_secret=\(foursquareClientSecret)&ll=\(coordinates.latitude),\(coordinates.longitude)&v=\(foursquareVersion)"
        
        func success(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) {
            let responseDict = responseObject as Dictionary<String, AnyObject>
            
            let actualResponseDict: Dictionary<String, AnyObject>? = (responseDict["response"] as AnyObject?) as? Dictionary<String, AnyObject>
            
            let groupsArray: AnyObject[]? = (actualResponseDict!["groups"] as AnyObject?) as? AnyObject[]
            
            println(groupsArray![0])
            
            let groupsDict: Dictionary<String, AnyObject>? = (actualResponseDict!["groups"] as AnyObject?) as? Dictionary<String, AnyObject>
            
            println(actualResponseDict)
        }
        
        afNetworkingManager.GET(urlString, parameters: nil, success: success, failure: popError)*/
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