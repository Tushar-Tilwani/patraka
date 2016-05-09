//
//  HomeVC.swift
//  patraka
//
//  Created by Tushar Tilwani on 4/28/16.
//  Copyright © 2016 Tushar Tilwani. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HomeVC: UIViewController {
    var player: AVPlayer?
    var playerLayer : AVPlayerLayer?
    
    @IBOutlet weak var uiview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Load the video from the app bundle.
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("video", withExtension: "mp4")!
        //let videoURL = NSURL(fileURLWithPath: "https://s3-us-west-2.amazonaws.com/coverr/mp4/Traffic-blurred2.mp4")
        
        player = AVPlayer(URL: videoURL)
        player?.actionAtItemEnd = .None
        player?.muted = true
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer!.zPosition = -1
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        playerLayer!.frame = CGRectMake(0, 20, width, height)
        view.layer.addSublayer(playerLayer!)
        player?.play()
        
        
        
        //loop video
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(HomeVC.loopVideo),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeVC.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        
       
        // Do any additional setup after loading the view.
    }
    
    func rotated(){
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        playerLayer!.frame = CGRectMake(0, 20, width, height)
    }
    
    func loopVideo() {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
