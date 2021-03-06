//
//  ViewController.swift
//  BluetoothIphone
//
//  Created by Tushar Tilwani on 4/9/16.
//  Copyright © 2016 Tushar Tilwani. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothUseTicketVC: UIViewController, CBPeripheralManagerDelegate{
    
    private var peripheralManager: CBPeripheralManager?
    private var transferCharacteristic: CBMutableCharacteristic?
    var vendor : JSON?
    var ticket : JSON?
    
    private var dataToSend: NSData?
    private var sendDataIndex: Int?
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    private var shouldSend: Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Start up the CBPeripheralManager
        let date = ticket![Constants.dateAlias].string!
        dateLabel.text = "Date: \(date)"
        let quantity = ticket![Constants.quanity].string!
       quantityLabel.text = "You have \(quantity) Tickets"
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        ticketWillSend()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Don't keep it going while we're not showing.
        peripheralManager?.stopAdvertising()
    }
    
    /** Required protocol method.  A full app should take care of all the possible states,
     *  but we're just waiting for  to know when the CBPeripheralManager is ready
     */
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        // Opt out from any other state
        if (peripheral.state != CBPeripheralManagerState.PoweredOn) {
            return
        }
        
        // We're in CBPeripheralManagerStatePoweredOn state...
        print("self.peripheralManager powered on.")
        
        // ... so build our service.
        
        // Start with the CBMutableCharacteristic
        transferCharacteristic = CBMutableCharacteristic(
            type: transferCharacteristicUUID,
            properties: CBCharacteristicProperties.Notify,
            value: nil,
            permissions: CBAttributePermissions.Readable
        )
        
        // Then the service
        let transferService = CBMutableService(
            type: transferServiceUUID,
            primary: true
        )
        
        // Add the characteristic to the service
        transferService.characteristics = [transferCharacteristic!]
        
        // And add it to the peripheral manager
        peripheralManager!.addService(transferService)
    }
    
    /** Catch when someone subscribes to our characteristic, then start sending them data
     */
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
        print("Central subscribed to characteristic")
        
        let key = ticket![Constants._id].string!
        // Get the data
        dataToSend = key.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Reset the index
        sendDataIndex = 0;
        
        // Start sending
        sendData()
    }
    
    /** Recognise when the central unsubscribes
     */
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic) {
        print("Central unsubscribed from characteristic")
    }
    
    // First up, check if we're meant to be sending an EOM
    private var sendingEOM = false;
    
    /** Sends the next amount of data to the connected central
     */
    private func sendData() {
        if sendingEOM {
            // send it
            let didSend = peripheralManager?.updateValue(
                "EOM".dataUsingEncoding(NSUTF8StringEncoding)!,
                forCharacteristic: transferCharacteristic!,
                onSubscribedCentrals: nil
            )
            
            // Did it send?
            if (didSend == true) {
                
                // It did, so mark it as sent
                sendingEOM = false
                
                print("Sent: EOM")
                self.ticketDidSend()
            }
            
            // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
            return
        }
        
        // We're not sending an EOM, so we're sending data
        
        // Is there any left to send?
        if (sendDataIndex >= dataToSend?.length) {
            // No data left.  Do nothing
            return
        }
        
        // There's data left, so send until the callback fails, or we're done.
        var didSend = true
        
        while didSend {
            // Make the next chunk
            
            // Work out how big it should be
            var amountToSend = dataToSend!.length - sendDataIndex!;
            
            // Can't be longer than 20 bytes
            if (amountToSend > NOTIFY_MTU) {
                amountToSend = NOTIFY_MTU;
            }
            
            // Copy out the data we want
            let chunk = NSData(
                bytes: dataToSend!.bytes + sendDataIndex!,
                length: amountToSend
            )
            
            // Send it
            didSend = peripheralManager!.updateValue(
                chunk,
                forCharacteristic: transferCharacteristic!,
                onSubscribedCentrals: nil
            )
            
            // If it didn't work, drop out and wait for the callback
            if (!didSend) {
                return
            }
            
            let stringFromData = NSString(
                data: chunk,
                encoding: NSUTF8StringEncoding
            )
            
            print("Sent: \(stringFromData)")
            
            // It did send, so update our index
            sendDataIndex! += amountToSend;
            
            // Was it the last one?
            if (sendDataIndex! >= dataToSend!.length) {
                
                // It was - send an EOM
                
                // Set this so if the send fails, we'll send it next time
                sendingEOM = true
                
                // Send it
                let eomSent = peripheralManager!.updateValue(
                    "EOM".dataUsingEncoding(NSUTF8StringEncoding)!,
                    forCharacteristic: transferCharacteristic!,
                    onSubscribedCentrals: nil
                )
                
                if (eomSent) {
                    // It sent, we're all done
                    sendingEOM = false
                    print("Sent: EOM")
                    self.ticketDidSend()
                }
                
                return
            }
        }
    }
    
    /** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
     *  This is to ensure that packets will arrive in the order they are sent
     */
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
        // Start sending again
        sendData()
    }
    /** Start advertising
     */
    @IBAction func sendBtnAction(sender: AnyObject) {
       self.ticketWillSend()
    }
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        print(error)
    }
    
    func ticketDidSend(){
        sendBtn.setTitle("Start", forState: UIControlState.Normal)
        peripheralManager?.stopAdvertising()
        sendBtn.enabled = true
        self.navigationController?.popViewControllerAnimated(true)
        //UIControl().sendAction(#selector(NSURLSessionTask.suspend), to: UIApplication.sharedApplication(), forEvent: nil)
    }
    
    func ticketWillSend(){
        sendBtn.setTitle("Sending Ticket...", forState: UIControlState.Normal)
        sendBtn.enabled = false
        peripheralManager!.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [transferServiceUUID]])
    }

    
    
}

