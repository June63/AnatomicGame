//
//  QCM_ViewController.swift
//  AnatomicGame
//
//  Created by Léa Kieffer on 19/01/2022.
//

import UIKit
import FirebaseFirestore

class QCM : UIViewController {

    // MARK: Outlet

    @IBOutlet weak var Question: UITextField!
    @IBOutlet weak var ResponseA: UIButton!
    @IBOutlet weak var ResponseB: NSLayoutConstraint!
    @IBOutlet weak var ResponseC: UIButton!
    @IBOutlet var ResponseD: UIView!
    @IBOutlet weak var Submit: UIButton!
    
    var score = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func answerPressed(_ sender: UIButton) {
        
        if sender.tag == selectedAnswer {
            print ("correct")
            score += 3
        } else {
            print ("wrong")
        }
         updateQuesiton()
    }
    
}
