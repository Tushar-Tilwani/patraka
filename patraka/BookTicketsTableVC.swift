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
        populateVendors()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        
        
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
        
        /*var imageStr : String? =  vendor?["image"].string
        
        if(imageStr == nil){
            imageStr = "default.jpg"
        }
        
        let urlString = Constants.imageDomain + imageStr!
        let url = NSURL(string: ("\(urlString)"))
        let data = NSData(contentsOfURL : url!)
        let image = UIImage(data: data!)*/
        cell.imageView?.image =  Constants.getImage(vendor?["image"].string)
        
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
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    func afterLoad(){
        self.tableView.reloadData()
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    func showAlert(msg: String){
        let alertController = UIAlertController(title: "Error", message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func populateVendors(){
        beforeLoad()
        let url = "\(Constants.domain)dummy_vendors"
        print(url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!, completionHandler: { (data, response, error) -> Void in
            do{
                if(data != nil){
                    self.vendors = JSON(data: data!)
                    self.afterLoad()
                } else {
                    self.showAlert("No Internet Connection!")
                    self.afterLoad()
                }
                
            }
        })
        task.resume()
        
    }
    
}
