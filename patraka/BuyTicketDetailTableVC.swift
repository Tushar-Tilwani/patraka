//
//  BuyTicketDetailTableVC.swift
//  patraka
//
//  Created by Tushar Tilwani on 4/29/16.
//  Copyright © 2016 Tushar Tilwani. All rights reserved.
//

import UIKit
import Alamofire

class BuyTicketDetailTableVC: UITableViewController {
    
    var vendor: JSON?
    var date: String = Constants.getDateFormatter().stringFromDate(NSDate())
    var quantity: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "DateCell", bundle: nil), forCellReuseIdentifier: "dateCell")
        tableView.registerNib(UINib(nibName: "QuantityCell", bundle: nil), forCellReuseIdentifier: "quantityCell")
        tableView.registerNib(UINib(nibName: "BuyCell", bundle: nil), forCellReuseIdentifier: "buyCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        switch indexPath.section {
        case 0:
            let dcell = tableView.dequeueReusableCellWithIdentifier("dateCell", forIndexPath: indexPath) as! DateCell
            dcell.parentTableVC = self
            cell = dcell
        case 1:
            let qcell = tableView.dequeueReusableCellWithIdentifier("quantityCell", forIndexPath: indexPath) as! QuantityCell
            qcell.parentTableVC = self
            cell = qcell
        case 2:
            let buyCell = tableView.dequeueReusableCellWithIdentifier("buyCell", forIndexPath: indexPath) as! BuyCell
            buyCell.vendor = vendor
            buyCell.parentTableVC = self
            cell = buyCell
        default:
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuseIdentifier")
            break;
            
        }
        // Configure the cell...
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 240.0
        case 1:
            return 220.0
        case 2:
            return 80.0
        default:
            return 220.0
        }
        
    }
    
    
    func confirmAction(){
        
        let params = ["userId":"1","userName":"John Wick",Constants.vendorName:vendor![Constants.vendorName].string!,"date":date,"quantity":quantity,"vendorId":vendor!["_id"].string!]
        
        Alamofire.request(.POST, "\(Constants.domain)tickets", parameters:params)
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
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
