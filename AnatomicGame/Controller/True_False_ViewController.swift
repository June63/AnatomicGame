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
    
    
    func TrueFalse(){
        choixArray = []
        while questionIndex < 3 {
            
            db.collection("QCM").document(questionArray[questionIndex]).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(dataDescription)")
                        let entitled = document.get("Le tibia est l os de la jambe ?") as! String
                        document.collection("choix").getDocuments { (document, error) in
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

        db.collection("TrueFalse").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.questionArray.append(document.documentID)
            }   }   }   }
}
