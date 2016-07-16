//
//  SharedData.swift
//  FW_hack_lisnr
//
//  Created by Mengdi Chen on 7/15/16.
//  Copyright © 2016 Mengdi Chen. All rights reserved.
//

import Foundation


class SharedData {
    class var sharedInstance: SharedData {
        struct Static {
            static var instance: SharedData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SharedData()
        }
        
        return Static.instance!
    }
    
    
    var currentAdId : String!
    
    var urlToLoad : String!
    
}