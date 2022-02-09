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
    var questionArray: [String] = []
    var choiceArray: [String] = []
    var questionIndex = 0
    var responseChoosen = -1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func AnswerA(_ sender: UIButton) {
        sender.backgroundColor = .green
        responseChoosen = sender.tag
    }
    
    @IBAction func AnswerB(_ sender: UIButton) {
        sender.backgroundColor = .green
        responseChoosen = sender.tag
    }
    
    @IBAction func AnswerC(_ sender: UIButton) {
        sender.backgroundColor = .green
        responseChoosen = sender.tag
    }
    
    @IBAction func AnswerD(_ sender: UIButton) {
        sender.backgroundColor = .green
        responseChoosen = sender.tag
    }
    

    @IBAction func Validate(_ sender: UIButton) {
        /*db.collection("QCM").document(questionArray[questionIndex]).getDocument { (document, error) in
            let response = document.get("Response") as? String
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
    */}
    
    

    func Start(){
        choiceArray = []
        db.collection("QCM").document(questionArray[questionIndex]).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(dataDescription)")
                        self.db.collection("QCM").document(document.documentID).collection("Choix").getDocuments { (documentSecond, error) in
                            for documents in documentSecond!.documents {
                                print ("\(documents.documentID) => \(documents.data())")
                                self.choiceArray.append(documents.documentID)
                            }   }
                        DispatchQueue.main.async {
                            self.Question.text = document.get("Question") as? String
                            var response = document.get("Response") as? String
                            for response in 0..<(self.choiceArray.count-1) {
                                
                                switch response {
                                        
                                    case 0:
                                        self.ChoiceA.setTitle(self.choiceArray[0], for: .normal)
                                        break
                                        
                                    case 1:
                                        self.ChoiceB.setTitle(self.choiceArray[1], for: .normal)
                                        break
                                        
                                    case 2:
                                        self.ChoiceC.setTitle(self.choiceArray[2], for: .normal)
                                        break
                                        
                                    case 3:
                                        self.ChoiceD.setTitle(self.choiceArray[3], for: .normal)
                                        break
                                        
                                    default:
                                        print("Error")
                                }
                                
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
         }
    }
    

    func QCMData(){
        db.collection("QCM").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.questionArray.append(document.documentID)
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
                                        message: "Bonne reponse.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }

}

