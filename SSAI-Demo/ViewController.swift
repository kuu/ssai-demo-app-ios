//
//  ViewController.swift
//  SSAI-Demo
//
//  Created by Kuu Miyazaki on 8/6/16.
//  Copyright © 2016 Ooyala. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var gender:NSString = "unknown"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func watchLive(sender: AnyObject) {
    }
    
    @IBAction func login(sender: AnyObject) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // Log out
            FBSDKLoginManager().logOut()
            self.loginButton.setTitle("Login", forState: .Normal)
            self.titleLabel.text = "SSAI Demo"
            self.messageLabel.text = ""
            self.profileImage.image = nil
        } else {
            // Log in
            FBSDKLoginManager().logInWithReadPermissions(["public_profile"], fromViewController:self, handler: { (result, error) -> Void in
                if (error != nil || result.isCancelled) {
                    // Handle cancellations
                    FBSDKLoginManager().logOut()
                    return
                }
                guard (result.grantedPermissions.contains("public_profile")) else {
                    return
                }
                guard let _ = error else {
                    self.loginButton.setTitle("Logout", forState: .Normal)
                    self.titleLabel.text = "SSAI Demo (Personalized)"
                    let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name,gender"])
                    graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                        if ((error) != nil) {
                            print("Error: \(error)")
                            return
                        }
                        let name = result.valueForKey("name") as! NSString
                        self.gender = result.valueForKey("gender") as! NSString
                        print("Name: \(name), Gender: \(self.gender)")
                        self.messageLabel.text = "ようこそ、\(name)さん！"
                        if let userID: NSString = result.valueForKey("id") as? NSString {
                            let facebookProfileUrl = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=large")
                            if let data = NSData(contentsOfURL: facebookProfileUrl!) {
                                self.profileImage.image = UIImage(data: data)
                            }
                        }
                    })
                    return
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        print("Segue name is " + segue.identifier!)
        if (segue.identifier == "LiveSegue") {
            //get a reference to the destination view controller
            let destinationVC:PlayerViewController = segue.destinationViewController as! PlayerViewController
            
            //set properties on the destination view controller
            destinationVC.gender = gender as String
            //etc...
            print("gender set!")
        }
    }
}