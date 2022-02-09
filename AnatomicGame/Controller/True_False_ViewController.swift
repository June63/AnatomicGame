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
    static var shared = TrueFalse()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupTrueFalse(){
        QuestionData()
        TrueFalseGame()
        ChoiceResponse(True, False)
    }
    
    @IBAction func ChoiceResponse(_ sender: UIButton) {
        /*if la reponse est correct {
         alertResponseTrue()
        } else {
         alertResponseFalse()
        }*/
    }
    
    
    func TrueFalseGame(){
        choixArray = []
        while questionIndex < 3 {
            
            db.collection("QCM").document(questionArray[questionIndex]).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(dataDescription)")
                        let entitled = document.get("Le tibia est l os de la jambe ?") as! String
                        document.collection("Choix").getDocuments { (document, error) in
                            for document in QuerySnapshot.documents {
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
    
    func alertResponseFalse() {
        let alertVC = UIAlertController(title: "Response",
                                        message: "Mauvaise reponse.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }
    
    func alertResponseTrue() {
        let alertVC = UIAlertController(title: "Response",
                                        message: "Bonne réponse.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }
}
