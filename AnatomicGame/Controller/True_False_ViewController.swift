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
        ChooseTrue(True as Any)
        ChooseFalse(False as Any)
        //Validation(Validate as Any)
    }
    
    
    @IBAction func ChooseTrue(_ sender: Any) {
        let button = sender as! UIButton
        responseChoosen = button.tag
    }
    
    
    
    @IBAction func ChooseFalse(_ sender: Any) {
        let button = sender as! UIButton
        responseChoosen = button.tag
    }
    
    
    @IBAction func Validation(_ sender: Any) {
        /*db.collection("TrueFalse").document(arrayOfData[questionIndex]).getDocument { (document, error) in
            let response = document!.get("Response") as! String
            self.db.collection("QCM").document(response).getDocument { (document, error) in
            let goodRespoonse = response
                if  String(goodRespoonse) == "responseChoosen" {
                    self.alertResponseTrue()
                } else {
                    self.alertResponseFalse()
                }
                DispatchQueue.main.async {
                    self.questionIndex += 1
                    self.QuestionData()
                }
            }
        }*/
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
            DispatchQueue.main.async {
                self.Question.text = document!.get("Question") as? String
                var i = 0
                while i <= self.arrayOfChoice.count {
                    switch i {
                        case 0:
                            self.True.setTitle(self.arrayOfChoice[0], for: .normal)
                            //self.True.setTitle(document!.get("Response") as? String, for: .normal)
                            break
                        case 1:
                            self.False.setTitle(self.arrayOfChoice[1], for: .normal)
                            //self.False.setTitle(document!.get("Response") as? String, for: .normal)
                            break
                        default:
                            print("Error")
                        }
                    i += 1
                }
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
                                        message: "Bonne réponse.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }

}

