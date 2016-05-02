//
//  BuyCell.swift
//  patraka
//
//  Created by Tushar Tilwani on 4/29/16.
//  Copyright © 2016 Tushar Tilwani. All rights reserved.
//

import UIKit

class BuyCell: UITableViewCell {
    
    var navigationController:UINavigationController? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func confirmAction(sender: AnyObject) {
        navigationController?.pushViewController(FinalBookTicketVC(), animated: true)
    }
}
