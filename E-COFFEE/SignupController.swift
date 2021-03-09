//
//  SignupController.swift
//  E-COFFEE
//
//  Created by enzo toyos on 02/12/2020.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class SignupController: UIViewController {

    //MARK: OUTLET
    var ref: DatabaseReference!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextFieldManager()

        
    }
    //MARK: FUNCTIONS
    // Modif visuelle du bouton "je valide"
    private func setupButtons(){
        acceptButton.layer.cornerRadius = 20
        acceptButton.layer.cornerRadius = 20
        acceptButton.layer.borderWidth = 3
        acceptButton.layer.borderColor = UIColor.white.cgColor
    }
    // Cache le clavier lors du click sur la view
    private func setupTextFieldManager(){
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    //MARK: Actions
    //cacher le clavier automatiquement
    @objc private func hideKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    // MARK:création User sur Firebase
    @IBAction func signupButtonWasPressed(_ sender: UIButton) {
        if usernameTextField.text != "" && passwordTextField.text != "" && emailTextField.text != "" {
            //Création d'un user dans la BDD 
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    print("Inscription de \(self.usernameTextField.text ?? "no name") réussie ✅")
                    let userID = Auth.auth().currentUser?.uid //recuperation de l'id UNIQUE du user
                    let db = Firestore.firestore() // initialisation Firestore
                    db.collection("users").document(userID!).setData([
                                                                        "email": self.emailTextField.text!,
                                                                        "username": self.usernameTextField.text!,
                                                                        "company": self.companyTextField.text!,
                                                                        "nb_cafe": 0]){
                        
                                (error:Error?) in
                                if let error = error{
                                    print("\(error.localizedDescription)")
                                }else{
                                    print("user was successfully creat ")
                                }
                            }
                    self.sendEmail() // envoie d'un email de verification
                }
            }
        }else{
            print("Oups! il doit manquer une information") // si erreur detecté
        }
    }// END: Func loginButton
    
    //Action pour redirection vers écran d'accueil
    @IBAction func loginButtonWasPressed(_ sender: UIButton) {
        print("redirection vers l'écran de login")
    }
    
    private func sendEmail(){
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                print("erreur lors de l'envoie")
            }else{
                print("envoyé")
                let confirmations = UIAlertController(title: "Confirmation", message: "Un E-mail viens de vous etre envoyer merci de verifier votre compte en cliquant sur le lien", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                confirmations.addAction(action)
                self.present(confirmations, animated: true, completion: nil)
                self.dismiss (animated: true, completion: nil)
                
            }
        })
    }
        
}//end class register 


//MARK: EXTENSIONS
extension SignupController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}// END: Extension


