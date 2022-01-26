//
//  QCM_ViewController.swift
//  AnatomicGame
//
//  Created by Léa Kieffer on 19/01/2022.
//

import UIKit

class QCM : UIViewController {

    // MARK: - Variables

    @IBOutlet weak var Question: UITextField!
    @IBOutlet weak var A: UIButton!
    @IBOutlet weak var ResponseA: UITextField!
    @IBOutlet weak var B: UIButton!
    @IBOutlet weak var ResponseB: UITextField!
    @IBOutlet weak var C: UIButton!
    @IBOutlet weak var ResponseC: UITextField!
    @IBOutlet weak var D: UIButton!
    @IBOutlet weak var ResponseD: UITextField!
    @IBOutlet var Submit: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
