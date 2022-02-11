//
//  True_False_ViewController.swift
//  AnatomicGame
//
//  Created by Léa Kieffer on 19/01/2022.
//

import UIKit
import FirebaseFirestore
import CoreMIDI

class TrueFalse : UIViewController {

    // MARK: Outlet
 
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var True: UIButton!
    @IBOutlet weak var False: UIButton!
    @IBOutlet weak var Validate: UIButton!
    
    // Mark: Variable
    
    let db = Firestore.firestore()
    var arrayOfData: [String] = []
    var arrayOfChoice: [String] = []
    var questionIndex = 0
    var responseChoosen = -1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionData()
    }
    
    @IBAction func ChooseTrue(_ sender: UIButton) {
        responseChoosen = sender.tag
        True.backgroundColor = UIColor.blue
    }
    
    
    
    @IBAction func ChooseFalse(_ sender: UIButton) {
        responseChoosen = sender.tag
        True.backgroundColor = UIColor.blue
    }
    
    @IBAction func Validation(_ sender: UIButton) {
        db.collection("TrueFalse").document(arrayOfData[questionIndex]).getDocument { (document, error) in
        let response = document!.get("Response") as! String
            self.db.collection("TrueFalse").document(response).getDocument { (document, error) in
                /*let goodRespoonse = response.get("Response")
                if self.responseChoosen.toString() == goodRespoonse {
                    self.alertResponseTrue()
                } else {
                    self.alertResponseFalse()
                }*/
                DispatchQueue.main.async {
                    self.questionIndex += 1
                    self.Start()
                }
            }
        }
    }
    
    func QuestionData(){
        db.collection("TrueFalse").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.arrayOfData.append(document.documentID)
                }
            }
        self.ResponseData()
        }
    }
    
    func ResponseData(){
        arrayOfChoice = []
        db.collection("TrueFalse").document(arrayOfData[questionIndex]).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.db.collection("TrueFalse").document(document.documentID).collection("Choix").getDocuments { (documentSecond, error) in
                for documents in documentSecond!.documents {
                    print ("\(documents.documentID) => \(documents.data())")
                    self.arrayOfChoice.append(documents.documentID)
                    }
                self.Start()
                }
                } else {
                    print("Document does not exist")
                }
        }
    }
    
    func Start() {
        db.collection("TrueFalse").document(arrayOfData[questionIndex]).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.db.collection("TrueFalse").document(document.documentID).collection("Choix").getDocuments { (documentSecond, error) in
                for documents in documentSecond!.documents {
                    print ("\(documents.documentID) => \(documents.data())")
                    DispatchQueue.main.async {
                        self.Question.text = document.get("Question") as? String
                        var i = 0
                        while i <= self.arrayOfChoice.count {
                            switch i {
                                case 0:
                                    self.db.collection("TrueFalse").document(document.documentID).collection("Choix").document(self.arrayOfChoice[0]).getDocument { (choix, error) in
                                        let choice = choix!.get("Response") as! String
                                        DispatchQueue.main.async {
                                        self.True.setTitle(choice, for: .normal)
                                        }
                                    }
                                    break
                                case 1:
                                    self.db.collection("TrueFalse").document(document.documentID).collection("Choix").document(self.arrayOfChoice[1]).getDocument { (choix, error) in
                                        let choice = choix!.get("Response") as! String
                                        DispatchQueue.main.async {
                                        self.False.setTitle(choice, for: .normal)
                                        }
                                    }
                                    break
                                default:
                                    print("Error")
                            }
                            i += 1
                        }
                    }
                }
                self.ChooseTrue(self.True)
                self.ChooseFalse(self.False)
                //self.Validation(self.Validate)
                }
            } else {
                print("Document does not exist")
            }
        }
        
    }
  
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
                                        message: "Bonne reponse.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }

}

