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
        responseChoosen = sender.tag
        ChoiceA.backgroundColor = UIColor.green
    }
    
    @IBAction func AnswerB(_ sender: UIButton) {
        responseChoosen = sender.tag
        ChoiceB.backgroundColor = UIColor.green
    }
    
    @IBAction func AnswerC(_ sender: UIButton) {
        responseChoosen = sender.tag
        ChoiceC.backgroundColor = UIColor.green
    }
    
    @IBAction func AnswerD(_ sender: UIButton) {
        responseChoosen = sender.tag
        ChoiceD.backgroundColor = UIColor.green
    }

    @IBAction func Validation(_ sender: UIButton) {
        db.collection("QCM").document(arrayOfData[questionIndex]).getDocument { (document, error) in
        let response = document!.get("Response") as! String
            self.db.collection("QCM").document(response).getDocument { (document, error) in
                //let goodResponse = response.get("Response")
                if String(self.responseChoosen) == response {
                    self.alertResponseTrue()
                } else {
                    self.alertResponseFalse()
                }
                DispatchQueue.main.async {
                    self.questionIndex += 1
                    self.ResponseData()
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
            self.ResponseData()
        }
    }
    
    func ResponseData(){
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
                self.Start()
                }
            } else {
                print("Document does not exist")
            }
         }
    }
    
    func Start() {
        db.collection("QCM").document(arrayOfData[questionIndex]).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.db.collection("QCM").document(document.documentID).collection("Choix").getDocuments { (documentSecond, error) in
                for documents in documentSecond!.documents {
                    print ("\(documents.documentID) => \(documents.data())")
                    DispatchQueue.main.async {
                        self.Question.text = document.get("Question") as? String
                        var i = 0
                        while i <= self.arrayOfChoice.count {
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
                }
                self.AnswerA(self.ChoiceA)
                self.AnswerB(self.ChoiceB)
                self.AnswerC(self.ChoiceC)
                self.AnswerD(self.ChoiceD)
                self.Validation(self.Validate)
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


