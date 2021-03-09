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
  
    @IBOutlet weak var infosButton: UIImageView!
    @IBOutlet weak var machineImage: UIImageView!
    
    let db = Firestore.firestore() // initialisation Firestore
    var ref: DatabaseReference!
    let shapeLayer = CAShapeLayer()
    var etatmachine = "wait"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        machineCondition()
 
    }
    
    
    //MARK: FUNCTIONS
    private func setupButton(){
        settingsButton.layer.cornerRadius = 20
        settingsButton.layer.cornerRadius = 20
        settingsButton.layer.borderWidth = 3
        settingsButton.layer.borderColor = UIColor.white.cgColor
        
        machineImage.layer.cornerRadius = 20
        machineImage.layer.cornerRadius = 20
        machineImage.layer.borderWidth = 3
        machineImage.layer.borderColor = UIColor.white.cgColor
    
        infosButton.layer.cornerRadius = 20
        infosButton.layer.cornerRadius = 20
        infosButton.layer.borderWidth = 3
        infosButton.layer.borderColor = UIColor.white.cgColor
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

