//
//  UseTicketsTableVC.swift
//  patraka
//
//  Created by Tushar Tilwani on 4/28/16.
//  Copyright © 2016 Tushar Tilwani. All rights reserved.
//

import UIKit
import Alamofire

class UseTicketsTableVC: UITableViewController {
    var tickets: JSON? = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.backgroundView
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        populateTickets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tickets!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ticketCell", forIndexPath: indexPath)
        let ticket = tickets?[indexPath.row]
        cell.textLabel?.text = ticket?[Constants.vendorName].string
        
        let date = ticket?[Constants.dateAlias].string
        let quanity = ticket?[Constants.quanity].string
        
        cell.detailTextLabel?.text =  "\(date!) | \(quanity!) Tickets"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ticket = tickets![indexPath.row]
        let detailVC =  BluetoothUseTicketVC()
        detailVC.title = ticket[Constants.vendorName].string
        detailVC.ticket = ticket
        
        navigationController?.pushViewController(detailVC, animated: true)
        
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
    func beforeLoad(){
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    func afterLoad(){
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        self.tableView.reloadData()
        
    }
    func populateTickets(){
        beforeLoad()
        Alamofire.request(.GET, "\(Constants.domain)tickets")
            .responseJSON { response in
                /*print(response.request)  // original URL request
                 print(response.response) // URL response
                 print(response.data)     // server data
                 print(response.result)   // result of response serialization
                 
                 if let json = response.result.value {
                 self.tickets = JSON(json)
                 self.tableView.reloadData()
                 self.afterLoad()
                 print("JSON: \(json)")
                 }*/
                
                switch response.result {
                case .Success:
                    if let json = response.result.value {
                        self.tickets = JSON(json)
                        self.afterLoad()
                    }
                case .Failure( _):
                    self.showAlert("No Internet Connection!")
                    self.afterLoad()
                }
                
        }
        
    }
    
    func showAlert(msg: String){
        let alertController = UIAlertController(title: "Error", message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
