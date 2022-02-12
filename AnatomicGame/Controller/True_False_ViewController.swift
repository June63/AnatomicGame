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
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            sender.backgroundColor = UIColor.green
            responseChoosen = sender.tag
        } else{
            sender.backgroundColor = UIColor.blue
        }
    }
    
    @IBAction func ChooseFalse(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            sender.backgroundColor = UIColor.red
            responseChoosen = sender.tag
        } else{
            sender.backgroundColor = UIColor.blue
        }
    }
    
    @IBAction func Validation(_ sender: UIButton) {
        db.collection("TrueFalse").getDocuments { (querySnapshot, error) in
        for document in querySnapshot!.documents {
            self.db.collection("TrueFalse").document(document.documentID).getDocument { (documentSnapshot, error) in
                let bonneReponseRef = documentSnapshot!.get("Reponse") as! DocumentReference
                let bonneReponseID = bonneReponseRef.documentID
        self.db.collection("QCM").getDocuments { (querySnapshot, error) in
        for document in querySnapshot!.documents {
            self.db.collection("TrueFalse").document(document.documentID).collection("Choix").getDocuments { (choixQuerySnapshot, error) in
                    for choix in choixQuerySnapshot!.documents {
                        self.arrayOfChoice.append(choix.documentID)
                        }
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
                                            self.ChooseTrue(self.True)
                                        }
                                    }
                                    break
                                case 1:
                                    self.db.collection("TrueFalse").document(document.documentID).collection("Choix").document(self.arrayOfChoice[1]).getDocument { (choix, error) in
                                        let choice = choix!.get("Response") as! String
                                        DispatchQueue.main.async {
                                            self.False.setTitle(choice, for: .normal)
                                            self.ChooseFalse(self.False)
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
                    self.Validation(self.Validate)
                }
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

