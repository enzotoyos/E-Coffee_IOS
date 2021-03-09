//
//  machineController.swift
//  E-COFFEE
//
//  Created by enzo toyos on 07/12/2020.
//

import UIKit
import FirebaseDatabase
import Firebase

class machineController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    var etat = 0
    var tasse = 00
    var fileAttente = ""
    var slider_value = 0
    var coffee = ""
    

    
    @IBOutlet weak var validerButton: UIButton!
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var picker: UIPickerView!
    
    let pickerValues = ["Espresso Classique", "Cafe Corse"]
    let db = Firestore.firestore() //initialisation Firestore
    var ref: DatabaseReference!
    
      override func viewDidLoad() {
          super.viewDidLoad()
          ref = Database.database().reference()
          setupButtons()
      }
    
    // utilisation du slider
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerValues[row])
        coffee = pickerValues[row]
    }
  
    @IBAction func sliderAction(_ sender: UISlider) {
        slider_value  = Int(temperatureSlider.value)
    }
    private func setupButtons(){
        validerButton.layer.cornerRadius = 10
        validerButton.layer.cornerRadius = 10
        validerButton.layer.borderWidth = 3
        validerButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func goButtonWasClicked(_ sender: UIButton) {
        
        self.ref.child("state_machine").child("presence_tasse").observeSingleEvent(of: .value, with: { (snapshot) in
            if let tasse = snapshot.value as? Int {
        
                self.ref.child("request_coffee").child("create_coffee").child("state").observeSingleEvent(of: .value, with: { (snapshot) in
            if let etat = snapshot.value as? Int {
        
                if etat == 0 && tasse == 1 {
                    
                    //Attribut la valeur en fonction pour l'envoyer sur firebase
                    if (self.coffee == "Espresso Classique"){
                        self.coffee = "espresso"
                    }
                    else if (self.coffee == "Espresso Classique"){
                        self.coffee = "long"
                    }
                    else{}
                    
                 // envoie les 3 données a la BDD
                    self.ref.child("request_coffee").child("create_coffee").child("quantity").setValue(self.slider_value)
                    self.ref.child("request_coffee").child("create_coffee").child("type").setValue(self.coffee)
                    self.ref.child("request_coffee").child("create_coffee").child("state").setValue(1)
                 
                 // affiche une alerte "confirmation que le cafe à été envoyé"
                    let confirmations = UIAlertController(title: "Confirmation", message: "Votre café \(self.coffee) à  bien été envoyé à la machine ", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    confirmations.addAction(action)
                    self.present(confirmations, animated: true, completion: nil)
                 
                 }else{
                    let Patientez = UIAlertController(title: "PATIENTEZ", message: "Votre café \(self.coffee) n'a pas pu etre envoyé veuillez réessayer dans 1 minute", preferredStyle: .alert)
                    
                     let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    Patientez.addAction(action)
                    self.present(Patientez, animated: true, completion: nil)

                 }
             }
        }
    )}
}
)}
}
