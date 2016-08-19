
//
//  PlayerViewController.swift
//  SSAI-Demo
//
//  Created by Kuu Miyazaki on 8/17/16.
//  Copyright © 2016 Ooyala. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, OOEmbedTokenGenerator {
    @IBOutlet weak var playerContainerView: UIView!
    
    var ooyalaPlayerViewController: OOOoyalaPlayerViewController!
    // var adsManager: OOPulseManager!
    var gender: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let player = OOOoyalaPlayer(pcode: "ZxNGgyOhy-q1LotjzCC58NUpXlWV", domain: OOPlayerDomain(string: "https://ssai.my-demo.link"), embedTokenGenerator: self)
        self.ooyalaPlayerViewController = OOOoyalaPlayerViewController(player: player)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlayerViewController.notificationHandler(_:)), name: nil, object: self.ooyalaPlayerViewController.player)
        
        self.addChildViewController(self.ooyalaPlayerViewController)
        self.playerContainerView.addSubview(self.ooyalaPlayerViewController.view)
        self.ooyalaPlayerViewController.view.frame = self.playerContainerView.bounds
        
        // self.adsManager = OOPulseManager(player: player)
        
        var embedCode = ""
        
        if (self.gender == "male") {
            embedCode = "duNmtlNTE6sKmrJchsFiub4SCfY6itSn"
        } else if (self.gender == "female") {
            embedCode = "JmaDhmNTE6DTxrYQ8XdSZ-sBaWbY2Pxs"
        } else {
            embedCode = "xnMzlmNTE6w6HB8u1CxqrmLuDwB0tAud"
        }
        print("self.gender=\"" + self.gender + "\"");
        
        self.ooyalaPlayerViewController.player.setEmbedCode(embedCode)
        self.ooyalaPlayerViewController.player.play()
    }
    
    func notificationHandler(notification: NSNotification) {
        if notification.name == OOOoyalaPlayerTimeChangedNotification {
            return
        }
        debugPrint("Notification Received: \(notification.name). state: \(OOOoyalaPlayer.playerStateToString(self.ooyalaPlayerViewController.player.state())). playhead: \(self.ooyalaPlayerViewController.player.playheadTime())")
    }
    
    /*
     * Get the Ooyala Player Token to play the embed code.
     * This should contact your servers to generate the OPT server-side.
     */
    func tokenForEmbedCodes(embedCodes: [AnyObject], callback: OOEmbedTokenCallback) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://ssai.my-demo.link/opt")!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            callback(NSString(data:data!, encoding:NSUTF8StringEncoding) as! String)
        })
        task.resume()
    }
}
