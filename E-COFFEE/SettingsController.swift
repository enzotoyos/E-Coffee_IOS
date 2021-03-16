//
//  SettingsController.swift
//  E-COFFEE
//
//  Created by enzo toyos on 03/12/2020.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import WebKit

class SettingsController: UIViewController {
    
    
    //MARK: OUTLET
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var SignOutButton: UIButton!
    @IBOutlet weak var etatMachine: UILabel!
    @IBOutlet weak var settingsButton: UIImageView!
    @IBOutlet weak var nb_credits: UILabel!
    @IBOutlet weak var infosButton: UIImageView!
    @IBOutlet weak var machineImage: UIImageView!
    
    let db = Firestore.firestore() // initialisation Firestore
    var ref: DatabaseReference!
    let shapeLayer = CAShapeLayer()
    var etatmachine = "wait"
    var credits = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        machineCondition()
        getCredits()
    }
    
    
    //MARK: FUNCTIONS
    private func setupButton(){
        settingsButton.layer.cornerRadius = 30
        settingsButton.layer.cornerRadius = 30
        settingsButton.layer.borderWidth = 3
        settingsButton.layer.borderColor = UIColor.white.cgColor
        
        machineImage.layer.cornerRadius = 30
        machineImage.layer.cornerRadius = 30
        machineImage.layer.borderWidth = 3
        machineImage.layer.borderColor = UIColor.white.cgColor
    
        infosButton.layer.cornerRadius = 30
        infosButton.layer.cornerRadius = 30
        infosButton.layer.borderWidth = 3
        infosButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func getCredits() { // Gère le nombre de café de l'utilisateur
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let docRef = self.db.collection("users").document(uid ?? "erreur")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let creditsJson :Double = document["credits"] as! Double // on récupere dans l'objet json le champ "credits"
                self.credits = String(creditsJson)
                print(self.credits)
                self.nb_credits.text = self.credits
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func logOutButtonWasPressed(_ sender: UIButton) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "backToLogin", sender: self)
        }catch{
            print("impossible de déconnecter l'utilisateur")
        }
    }
    
    private func machineCondition(){
        ref = Database.database().reference()
        self.ref.child("etat_machine").observeSingleEvent(of: .value, with: { (snapshot) in
            if let id = snapshot.value as? String {
                self.etatmachine = id
                print("etat de la machine est: \(self.etatmachine)")
            }
        })
    }
    
    @IBAction func ButtonConnectMachineWasPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "http://www.grainofcoffee.fr")!, options: [:], completionHandler: nil)

    }
    
    
    
    
    
    
}// END class SettingController

