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
    @IBOutlet weak var ResponseB: UIButton!
    @IBOutlet weak var ResponseC: UIButton!
    @IBOutlet weak var ResponseD: UIButton!
    @IBOutlet weak var Submit: UIButton!
    
    // MARK variable
    
    let db = Firestore.firestore()
    var questionArray = [String]()
    var choixArray = [String]()
    var questionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ClickedChoice(_ sender: UIButton) {
        if  {
            print ("correct")
        } else {
            print ("wrong")
        }
    }
    
    func qcm(){
        choixArray = []
        while questionIndex < 3 {
            db.collection("QCM").document(questionArray[questionIndex]).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(dataDescription)")
                        let entitled = document.get("Combien d os compose l articulation du poignet ?") as! String
                        document.collection("Choix").getDocuments { (document, error) in
                            for document in querySnapchot.documents {
                                print ("\(document.documentID) => \(document.data())")
                                self.choixArray.append(document.documentID)
                            }   }
                        DispatchQueue.main.async {
                        self.accessibilityLabel = entitled
                        }
                    } else {
                        print("Document does not exist")
                    }   }
            questionIndex += 1
        }   }
    

    func QuestionData(){
        db.collection("QCM").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.questionArray.append(document.documentID)
            }   }   }   }

}
