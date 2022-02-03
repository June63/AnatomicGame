//
//  Play_ViewController.swift
//  AnatomicGame
//
//  Created by Léa Kieffer on 19/01/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import GameKit


class Play : UIViewController {

    // MARK: Outlet
    
    @IBOutlet weak var TrueFalse: UIButton!
    @IBOutlet weak var QCM: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (Auth.auth().currentUser == nil){
            gamecenterAuth()
            firebaseAuth()
        }
    
    }
    
    func gamecenterAuth() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if viewController != nil {
                // Present the view controller so the player can sign in.
                return
            }
            if error != nil {
                // Player could not be authenticated.
                // Disable Game Center in the game.
                return
            }
            // Player was successfully authenticated.
            // Check if there are any player restrictions before starting the game.
            if GKLocalPlayer.local.isUnderage {
                // Hide explicit game content.
            }
            if GKLocalPlayer.local.isMultiplayerGamingRestricted {
                // Disable multiplayer game features.
            }
            if GKLocalPlayer.local.isPersonalizedCommunicationRestricted {
                // Disable in game communication UI.
            }
        }
    }
    
    func firebaseAuth() {

        GameCenterAuthProvider.getCredential() { (credential, error) in
          if let error = error {
            return
          }
          // The credential can be used to sign in, or re-auth, or link or unlink.
            Auth.auth().signIn(with:credential) { (user, error) in
            if let error = error {
              return
            }
            } } }
    
    
}
