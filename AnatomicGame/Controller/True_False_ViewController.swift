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
        loadData()
    }
    
    @IBAction func ChooseTrue(_ sender: UIButton) {
        if(responseChoosen != 0) {
            True.tintColor = .green
            False.tintColor = .blue
            responseChoosen = 0
        }
        print("True")
    }
    
    @IBAction func ChooseFalse(_ sender: UIButton) {
        if(responseChoosen != 1) {
            True.tintColor = .blue
            False.tintColor = .red
            responseChoosen = 1
        }
        print("False")
    }
    
    // Valide your choice and continue the game
    @IBAction func Validation(_ sender: UIButton) {
        True.isEnabled = false
        False.isEnabled = false
        db.collection("TrueFalse").getDocuments { (querySnapshot, error) in
            self.db.collection("TrueFalse").document(self.arrayOfData[self.questionIndex]).getDocument { (documentSnapshot, error) in
                let goodResponseRef = documentSnapshot!.get("Response") as! DocumentReference
                let goodResponseID = goodResponseRef.documentID
            self.db.collection("TrueFalse").getDocuments { (querySnapshot, error) in
                self.db.collection("TrueFalse").document(self.arrayOfData[self.questionIndex]).collection("Choix").getDocuments { (choixQuerySnapshot, error) in
                    for choix in choixQuerySnapshot!.documents {
                        self.arrayOfChoice.append(choix.documentID)
                    }
                }
            }
                if (self.arrayOfChoice[self.responseChoosen] == goodResponseID) {
                    DispatchQueue.main.async {
                        if(self.questionIndex + 1  < self.arrayOfData.count) {
                            self.alertResponseTrue()
                            self.True.isEnabled = true
                            self.False.isEnabled = true
                            self.questionIndex += 1
                            self.Start()
                        }else {
                            self.alertTrueEndGame()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if(self.questionIndex + 1  < self.arrayOfData.count) {
                            self.alertResponseFalse()
                            self.True.isEnabled = true
                            self.False.isEnabled = true
                            self.questionIndex += 1
                            self.Start()
                        } else {
                            self.alertFalseEndGame()
                        }
                    }
                }
            }
        }
    }
    
    //load data from firebase into an array
    func loadData(){
        db.collection("TrueFalse").getDocuments() { (querySnapshot, err) in
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
    
    // play to TrueFalseGame
    func Start(){
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
                    self.Question.text = document.get("Question") as? String
                    for index in 0...self.arrayOfChoice.count-1{
                            switch index {
                                case 0:
                                    self.db.collection("TrueFalse").document(document.documentID).collection("Choix").document(self.arrayOfChoice[index]).getDocument { (choix, error) in
                                        let choice = choix!.get("Response") as! String
                                        DispatchQueue.main.async {
                                            self.True.setTitle(choice, for: .normal)
                                        }
                                    }
                                    break
                                case 1:
                                    self.db.collection("TrueFalse").document(document.documentID).collection("Choix").document(self.arrayOfChoice[index]).getDocument { (choix, error) in
                                        let choice = choix!.get("Response") as! String
                                        DispatchQueue.main.async {
                                            self.False.setTitle(choice, for: .normal)
                                        }
                                    }
                                    break
                                default:
                                    print("Error")
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
    
    func alertTrueEndGame() {
        let alertVC = UIAlertController(title: "End Game",
                                        message: "Bonne reposne, Fin du jeu.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }
    
    func alertFalseEndGame() {
        let alertVC = UIAlertController(title: "End Game",
                                        message: "Mauvaise reponse, Fin du jeu.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }
}

