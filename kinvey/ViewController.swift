//
//  ViewController.swift
//  kinvey
//
//  Created by Preksha Koirala on 3/9/16.
//  Copyright © 2016 Preksha Koirala. All rights reserved.
//

import UIKit
import UIKit


class Event : NSObject {    //all NSObjects in Kinvey implicitly implement KCSPersistable
    var entityId: String? //Kinvey entity _id
    var name: String?
    var date: NSDate?
    var location: String?
    var metadata: KCSMetadata? //Kinvey metadata, optional
    
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "name" : "name",
            "date" : "date",
            "location" : "location",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]
    }
}

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var LogInButton: UIButton!
    
    
  
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        KCSClient.sharedClient().initializeKinveyServiceForAppKey(
            "kid_-khB2U9O6l",
            withAppSecret: "750e6d1a3ba744f69de56cf6bd63f6ed",
            usingOptions: nil
        )
        
        if KCSUser.activeUser() != nil{
            print ("user not nil")
            self.performSegueWithIdentifier("logsegue", sender: self)
            
        }
        
        
        KCSPing.pingKinveyWithBlock { (result: KCSPingResult!) -> Void in
            if result.pingWasSuccessful {
                NSLog("Kinvey Ping Success")
                //self.save()
            } else {
                NSLog("Kinvey Ping Failed")
            }
        }
        
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if KCSUser.activeUser() != nil{
            print ("user not nil")
            self.performSegueWithIdentifier("logsegue", sender: self)
            
        }
    }
    
    @IBAction func logAction(sender: AnyObject) {
        // Create a new user with the username 'kinvey' and the password '12345'
        
        let musername = self.emailField.text;
        let mpassword = self.passwordField.text;
        if KCSUser.activeUser() == nil {
            KCSUser.userWithUsername(
                musername,
                password: mpassword ,
                fieldsAndValues: nil,
                withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                    if errorOrNil == nil {
                        NSLog("user created")
                        self.performSegueWithIdentifier("logsegue", sender: self)
                        //user is created
                    } else {
                        //there was an error with the create
                    }
                }
                
            )
            
        }
        else{
            print("already created")
            self.performSegueWithIdentifier("logsegue", sender: self)
            
        }
        
    }
    

        

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
