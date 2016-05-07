//
//  constants.swift
//  patraka
//
//  Created by Tushar Tilwani on 4/29/16.
//  Copyright © 2016 Tushar Tilwani. All rights reserved.
//

import UIKit

struct Constants {
    static let vendorName = "companyName"
    static let vendorLocation = "vendorLocation"
    static let address = "vicinity"
    static let ipv4 = "129.21.112.210"
    static let port = "3000"
    static let domain = "http://\(Constants.ipv4):\(Constants.port)/"
    static let imageDomain = "\(Constants.domain)static/images/"
    
    static func getImage(imageStr : String?) -> UIImage?  {
        var imageName = imageStr
        if(imageName == nil){
            imageName = "default.jpg"
        }
        let urlString = Constants.imageDomain + imageName!
        let url = NSURL(string: ("\(urlString)"))
        let data = NSData(contentsOfURL : url!)
        return UIImage(data: data!)
    }
    
}