//
//  QuantityCell.swift
//  patraka
//
//  Created by Tushar Tilwani on 4/29/16.
//  Copyright © 2016 Tushar Tilwani. All rights reserved.
//

import UIKit

class QuantityCell: UITableViewCell,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var quantityPicker: UIPickerView!
    
    var parentTableVC: BuyTicketDetailTableVC? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quantityPicker.dataSource = self
        quantityPicker.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        parentTableVC?.quantity = String(row+1)
    }


}
