//
//  True_False_ViewController.swift
//  AnatomicGame
//
//  Created by Léa Kieffer on 19/01/2022.
//

import UIKit
import Firebase

class TrueFalse : UIViewController {

    // MARK: Outlet
 
    @IBOutlet weak var Question: UITextField!
    @IBOutlet weak var True: UIButton!
    @IBOutlet weak var False: UIButton!
    @IBOutlet weak var Submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
