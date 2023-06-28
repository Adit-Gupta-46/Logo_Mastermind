//
//  LoseViewController.swift
//  Logo picker
//
//  Created by Adit Gupta on 12/25/21.
//  Copyright © 2021 Adit Gupta. All rights reserved.
//

import UIKit

class LoseViewController: UIViewController {
    
    var statusVar : String?
    @IBOutlet weak var loseStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loseStatus.text = statusVar

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
