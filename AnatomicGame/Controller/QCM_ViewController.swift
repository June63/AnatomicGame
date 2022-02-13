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

    @IBOutlet weak var Question: UILabel!
    
    @IBOutlet weak var ChoiceA: UIButton!
    @IBOutlet weak var ChoiceB: UIButton!
    @IBOutlet weak var ChoiceC: UIButton!
    @IBOutlet weak var ChoiceD: UIButton!
    @IBOutlet weak var Validate: UIButton!
    
    // MARK variable
    
    let db = Firestore.firestore()
    var arrayOfData: [String] = []
    var arrayOfChoice: [String] = []
    var arrayOfResponse: [String] = []
    var questionIndex = 0
    var responseChoosen = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionData()
    }
    
    @IBAction func DidTapButton(_ sender: UIButton) {
        sender.isSelected = true
        ChoiceA.isSelected = false
        ChoiceB.isSelected = false
        ChoiceC.isSelected = false
        ChoiceD.isSelected = false
    }

    @IBAction func AnswerA(_ sender: UIButton) {
            
        if ChoiceA.isSelected == false {
            responseChoosen = 0
            ChoiceA.backgroundColor = UIColor.green
            print("A")
        } else {
            ChoiceA.backgroundColor = UIColor.blue
            print("ko")
        }
       
    }
    
    @IBAction func AnswerB(_ sender: UIButton) {
        
        if ChoiceB.isSelected == false {
            responseChoosen = 1
            ChoiceB.backgroundColor = UIColor.green
            print("B")
        } else {
            ChoiceB.backgroundColor = UIColor.blue
            print("ko")
            ChoiceB.isSelected = false
        }
   
    }
    
    @IBAction func AnswerC(_ sender: UIButton) {
        
        if ChoiceC.isSelected == false {
            responseChoosen = 2
            ChoiceC.backgroundColor = UIColor.green
            print("C")
        } else {
            ChoiceC.backgroundColor = UIColor.blue
            print("ko")
            ChoiceC.isSelected = false
        }
    }
    
    @IBAction func AnswerD(_ sender: UIButton) {
        
        if ChoiceD.isSelected == false {
            responseChoosen = 3
            ChoiceD.backgroundColor = UIColor.green
            print("D")
        } else {
            ChoiceD.backgroundColor = UIColor.blue
            print("ko")
            ChoiceB.isSelected = false
        }
    }
    
    @IBAction func Validation(_ sender: UIButton) {
        db.collection("QCM").getDocuments { (querySnapshot, error) in
        for document in querySnapshot!.documents {
            self.db.collection("QCM").document(document.documentID).getDocument { (documentSnapshot, error) in
                let bonneReponseRef = documentSnapshot!.get("Reponse") as! DocumentReference
                print(bonneReponseRef as DocumentReference)
                let bonneReponseID = bonneReponseRef.documentID
                //print(bonneReponseID)
        self.db.collection("QCM").getDocuments { (querySnapshot, error) in
        for document in querySnapshot!.documents {
            self.db.collection("QCM").document(document.documentID).collection("Choix").getDocuments { (choixQuerySnapshot, error) in
                    for choix in choixQuerySnapshot!.documents {
                        self.arrayOfChoice.append(choix.documentID)
                    }
                //print(self.responseChoosen)
               if (self.arrayOfChoice[self.responseChoosen] == bonneReponseID) {
                    self.alertResponseTrue()
                } else {
                self.alertResponseFalse()
                }
            }
        }
        }
            }
        }
        }
    }
    
    func QuestionData(){
        db.collection("QCM").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.arrayOfData.append(document.documentID)
                }
            }
            self.Start()
        }
    }
    
    func Start(){
        arrayOfChoice = []
        db.collection("QCM").document(arrayOfData[questionIndex]).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.db.collection("QCM").document(document.documentID).collection("Choix").getDocuments { (documentSecond, error) in
                for documents in documentSecond!.documents {
                print ("\(documents.documentID) => \(documents.data())")
                self.arrayOfChoice.append(documents.documentID)
                    DispatchQueue.main.async {
                        self.Question.text = document.get("Question") as? String
                        var i = 0
                        while i < self.arrayOfChoice.count {
                            switch i {
                                case 0:
                                    self.db.collection("QCM").document(document.documentID).collection("Choix").document(self.arrayOfChoice[0]).getDocument { (choix, error) in
                                        let choice = choix!.get("Response") as! String
                                        DispatchQueue.main.async {
                                            self.ChoiceA.setTitle(choice, for: .normal)
                                        }
                                    }
                                    break
                                case 1:
                                    self.db.collection("QCM").document(document.documentID).collection("Choix").document(self.arrayOfChoice[1]).getDocument { (choix, error) in
                                        let choice = choix!.get("Response") as! String
                                        DispatchQueue.main.async {
                                            self.ChoiceB.setTitle(choice, for: .normal)
                                        }
                                    }
                                    break
                                case 2:
                                    self.db.collection("QCM").document(document.documentID).collection("Choix").document(self.arrayOfChoice[2]).getDocument { (choix, error) in
                                        let choice = choix!.get("Response") as! String
                                        DispatchQueue.main.async {
                                            self.ChoiceC.setTitle(choice, for: .normal)
                                            
                                        }
                                    }
                                    break
                                case 3:
                                    self.db.collection("QCM").document(document.documentID).collection("Choix").document(self.arrayOfChoice[3]).getDocument { (choix, error) in
                                        let choice = choix!.get("Response") as! String
                                        DispatchQueue.main.async {
                                            self.ChoiceD.setTitle(choice, for: .normal)
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
                    DispatchQueue.main.async {
                        self.DidTapButton(self.ChoiceA)
                        self.DidTapButton(self.ChoiceB)
                        self.DidTapButton(self.ChoiceC)
                        self.DidTapButton(self.ChoiceD)
                        self.Validation(self.Validate)
                    }
                }
                }else {
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
