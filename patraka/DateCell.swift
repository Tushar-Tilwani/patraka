//
//  DateCell.swift
//  patraka
//
//  Created by Tushar Tilwani on 4/29/16.
//  Copyright © 2016 Tushar Tilwani. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
     var parentTableVC: BuyTicketDetailTableVC? = nil
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        datePicker.datePickerMode = .Date
        //datePicker.minimumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -3, toDate: NSDate(), options: [])
        datePicker.minimumDate = NSDate()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func dateChanged(sender: AnyObject) {
        let selectedDate = Constants.getDateFormatter().stringFromDate(datePicker.date)
        parentTableVC?.date = selectedDate
        print(selectedDate)
    }
}
