//
//  StartPageViewController.swift
//  Logo picker
//
//  Created by Adit Gupta on 12/26/21.
//  Copyright © 2021 Adit Gupta. All rights reserved.
//

import UIKit
import SystemConfiguration


class StartPageViewController: UIViewController {

    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var fakeStart: UIButton!
    @IBOutlet weak var about: UIButton!
    @IBOutlet weak var mute: UIButton!
    
    var muteStatus: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Button font settings
        let height = start.frame.height
        start.titleLabel?.font = UIFont.boldSystemFont(ofSize: height * 0.6)
        fakeStart.titleLabel?.font = UIFont.boldSystemFont(ofSize: height * 0.6)
        about.titleLabel?.font = UIFont.boldSystemFont(ofSize: height * 0.6)
        
        muteStatus = true
        
        if (Reachability.isConnectedToNetwork()){
            start.isEnabled = true
            start.alpha = 100
            
        } else {
            
            internetAllert()
            start.isEnabled = false
            start.alpha = 0.0
        }
        
        func getMuteStatus() -> Bool{
            return (muteStatus)
        }
        
    }
    
    @IBAction func startNoInternet(_ sender: Any) {
        internetAllert()
    }
    
    @IBAction func mute(_ sender: Any) {
        
        muteStatus = !muteStatus
        print ("changed")
    }
    

    
    func internetAllert(){
        let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async{
             self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToStart(segue: UIStoryboardSegue){}

}
