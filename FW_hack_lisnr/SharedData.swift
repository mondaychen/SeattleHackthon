//
//  SharedData.swift
//  FW_hack_lisnr
//
//  Created by Mengdi Chen on 7/15/16.
//  Copyright © 2016 Mengdi Chen. All rights reserved.
//

import Foundation
import UIKit

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
    
    var lastAdId : String!
    
    var urlToLoad : String!
    
    var imageSource : UIImage!
    let urlToGifLoad : String = "https://31.media.tumblr.com/8f648ca8b5cb7848c66706c68d7fed54/tumblr_n7f9955y7h1shpedgo1_500.gif"
    
}

var sharedData = SharedData.sharedInstance