//
//  Settings2Controller.swift
//  E-COFFEE
//
//  Created by enzo toyos on 07/12/2020.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase


class Settings2Controller: UIViewController {

    @IBOutlet weak var water_level: UILabel!
    @IBOutlet weak var marc_level: UILabel!
    @IBOutlet weak var water_quality: UILabel!
    let db = Firestore.firestore() // initialisation Firestore
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waterLevelIndicator()
        marcLevelIndicator()
        waterQualityIndicator()
    }
    
    
    
    
    
    func waterLevelIndicator(){
        ref = Database.database().reference()
        self.ref.child("state_machine").child("water_level").observeSingleEvent(of: .value, with: { (snapshot) in
            if let id = snapshot.value as? Int {
                self.water_level.text = String(id)
            }
        })
    }
    
    func marcLevelIndicator(){
        ref = Database.database().reference()
        self.ref.child("state_machine").child("marc_quantity").observeSingleEvent(of: .value, with: { (snapshot) in
            if let id = snapshot.value as? Int {
                self.marc_level.text = String(id)
            }
        })
    }
    
    func waterQualityIndicator(){
        ref = Database.database().reference()
        self.ref.child("state_machine").child("water_quality").observeSingleEvent(of: .value, with: { (snapshot) in
            if let id = snapshot.value as? Int {
                self.water_quality.text = String(id)
            }
        })
    }
}
