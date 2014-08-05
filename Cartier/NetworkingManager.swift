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
    
    class var sharedInstance: NetworkingManager {
        struct Static {
            static let instance: NetworkingManager = NetworkingManager()
        }
        return Static.instance
    }
    
    func findFoursquarePlaces(coordinates: CLLocationCoordinate2D) {
        
        var urlString = "https://api.foursquare.com/v2/venues/explore?client_id=\(foursquareClientId)&client_secret=\(foursquareClientSecret)&ll=\(coordinates.latitude),\(coordinates.longitude)&v=\(foursquareVersion)"
        
        func success(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) {
            let responseDict = responseObject as Dictionary<String, AnyObject>
            println(responseDict["response"])
        }
        
        afNetworkingManager.GET(urlString, parameters: nil, success: success, failure: nil)
    }
    
    func popError(operation: AFHTTPRequestOperation!, error: NSError!) {
        var errorAlert = UIAlertView(title: "Network Error", message: error.description, delegate: nil, cancelButtonTitle: "Ok")
        
        //errorAlert.show()
    }
    
    
/*success: {
(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in

let subDict = responseDict["response"] as Dictionary<String, AnyObject>?
//let subDict2 : AnyObject? = subDict["groups"]
//let subDict3 : AnyObject? =
//println(responseDict["response"].
*/

}