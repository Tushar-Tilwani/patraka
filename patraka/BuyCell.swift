//
//  BuyCell.swift
//  patraka
//
//  Created by Tushar Tilwani on 4/29/16.
//  Copyright © 2016 Tushar Tilwani. All rights reserved.
//

import UIKit
import Alamofire

class BuyCell: UITableViewCell {
    
    var navigationController:UINavigationController? = nil
    var vendor: JSON?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func confirmAction(sender: AnyObject) {
        
        Alamofire.request(.POST, "\(Constants.domain)testPUT", parameters:["ticketId":"ff","vendorId":vendor!["id"].string!])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                self.navigationController?.pushViewController(FinalBookTicketVC(), animated: true)
                
        }
        
      
    }
}
