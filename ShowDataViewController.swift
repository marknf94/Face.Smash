//
//  ShowDataViewController.swift
//  Face.Smash
//
//  Created by Mark Fernandez on 1/14/17.
//  Copyright © 2017 Mark Fernandez. All rights reserved.
//

import Foundation
import UIKit

class ShowDataViewController: UIViewController {
    
    
    @IBOutlet weak var Name_Lbl: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        if ID != ""{
            Name_Lbl.text = ID
    }
    }
    
    
    
    @IBAction func done_Btn(_ sender: AnyObject) {
        
        ID = ""
        name = "No Name"
        age = "No Age"
    }

}
