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
        AnswerA(ChoiceA as Any)
        AnswerB(ChoiceB as Any)
        AnswerC(ChoiceC as Any)
        AnswerD(ChoiceD as Any)
        //Validation(validate as Any)
        
    }

    @IBAction func AnswerA(_ sender: Any) {
        let button = sender as! UIButton
        responseChoosen = button.tag
    }
    
    @IBAction func AnswerB(_ sender: Any) {
        let button = sender as! UIButton
        responseChoosen = button.tag
    }
    
    @IBAction func AnswerC(_ sender: Any) {
        let button = sender as! UIButton
        responseChoosen = button.tag
    }
    
    @IBAction func AnswerD(_ sender: Any) {
        let button = sender as! UIButton
        responseChoosen = button.tag
    }
    

    @IBAction func Validation(_ sender: Any) {
        db.collection("QCM").document(arrayOfData[questionIndex]).getDocument { (document, error) in
            let response = document.get("Response") as! String
            self.db.collection("QCM").document(response).getDocument { (document, error) in
                let goodRespoonse = response.get("Response")
                if responseChoosen.toString() == goodRespoonse {
                    alertResponseTrue()
                } else {
                    alertResponseFalse()
                }
                DispatchQueue.main.async {
                    questionIndex++
                    Start()
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
                                    self.ChoiceA.setTitle(self.arrayOfChoice[0], for: .normal)
                                    //self.ChoiceA.setTitle(documents.get("Response") as? String, for: .normal)
                                    break
                                case 1:
                                    self.ChoiceB.setTitle(self.arrayOfChoice[1], for: .normal)
                                    //self.ChoiceB.setTitle(documents.get("Response") as? String, for: .normal)
                                    break
                                case 2:
                                    self.ChoiceC.setTitle(self.arrayOfChoice[2], for: .normal)
                                    //self.ChoiceC.setTitle(documents.get("Response") as? String, for: .normal)
                                    break
                                case 3:
                                    self.ChoiceD.setTitle(self.arrayOfChoice[3], for: .normal)
                                    //self.ChoiceD.setTitle(documents.get("Response") as? String, for: .normal)
                                    break
                                default:
                                    print("Error")
                            }
                            i += 1
                        }
                    }
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


