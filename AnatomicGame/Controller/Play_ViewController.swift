//
//  Play_ViewController.swift
//  AnatomicGame
//
//  Created by Léa Kieffer on 19/01/2022.
//

import UIKit
import FirebaseAuth
import GameKit


class Play : UIViewController {

    // MARK: Outlet
    
    @IBOutlet weak var TrueFalse: UIButton!
    @IBOutlet weak var QCM: UIButton!
    
    enum Mode {
        case truefase
        case qcm
    }
    
    var mode: Mode = .truefase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
          }
}

