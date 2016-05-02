//
//  BookTicketsTableVC.swift
//  patraka
//
//  Created by Tushar Tilwani on 4/28/16.
//  Copyright © 2016 Tushar Tilwani. All rights reserved.
//

import UIKit

class BookTicketsTableVC: UITableViewController {
    
    var vendors: JSON? = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        populateVendors();
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
        return vendors!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("vendorCell", forIndexPath: indexPath)
        
        let vendor = vendors?[indexPath.row]
        cell.textLabel?.text = vendor?["companyName"].string
        cell.detailTextLabel?.text = vendor?["type"].string
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vendor = vendors![indexPath.row]
        
        let detailVC =  VendorDetailTableVC(style: .Grouped)
        detailVC.title = vendor["companyName"].string
        detailVC.vendor = vendor
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func beforeLoad(){
        //        activityIndicator.hidden = false
        //        activityIndicator.startAnimating()
    }
    func afterLoad(){
        //        activityIndicator.stopAnimating()
        //        activityIndicator.hidden = true
        
    }
    func populateVendors(){
        beforeLoad()
        if let path = NSBundle.mainBundle().pathForResource("vendors", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                vendors = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                print(vendors!.count)
                tableView.reloadData()
                afterLoad()
                
            }
        }
        
    }
    
}
