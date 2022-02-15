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
    var questionIndex = 0
    var responseChoosen = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionData()
    }
    
    @IBAction func AnswerA(_ sender: UIButton) {
        responseChoosen = 0
        print("A")
    }
    
    @IBAction func AnswerB(_ sender: UIButton) {
        responseChoosen = 1
        print("B")
    }
    
    @IBAction func AnswerC(_ sender: UIButton) {
        responseChoosen = 2
        print("C")
    }
    
    @IBAction func AnswerD(_ sender: UIButton) {
        responseChoosen = 0
        print("D")
    }
    
    @IBAction func Validation(_ sender: UIButton) {
        
        ChoiceA.isEnabled = false
        ChoiceB.isEnabled = false
        ChoiceC.isEnabled = false
        ChoiceD.isEnabled = false
        
        db.collection("QCM").getDocuments { (querySnapshot, error) in
            self.db.collection("QCM").document(self.arrayOfData[self.questionIndex]).getDocument { (documentSnapshot, error) in
                let bonneReponseRef = documentSnapshot!.get("Response") as! DocumentReference
                let bonneReponseID = bonneReponseRef.documentID
        self.db.collection("QCM").getDocuments { (querySnapshot, error) in
        for document in querySnapshot!.documents {
            self.db.collection("QCM").document(document.documentID).collection("Choix").getDocuments { (choixQuerySnapshot, error) in
                    for choix in choixQuerySnapshot!.documents {
                        self.arrayOfChoice.append(choix.documentID)
                    }
            }
        }
        }
                if (self.arrayOfChoice[self.responseChoosen] == bonneReponseID) {
                    self.alertResponseTrue()
                    DispatchQueue.main.async {
                        self.Validate.isEnabled = false
                        self.questionIndex += 1
                        self.Start()
                    }
                } else {
                    self.alertResponseFalse()
                    DispatchQueue.main.async {
                        self.Validate.isEnabled = false
                        self.questionIndex += 1
                        self.Start()
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
                    }
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
