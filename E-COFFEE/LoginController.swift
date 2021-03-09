//
//  ViewController.swift
//  E-COFFEE
//
//  Created by enzo toyos on 02/12/2020.
//

import UIKit
import FirebaseAuth  // authentification avec firebase
import Firebase
import GoogleSignIn   // authentification avec google API


class LoginController: UIViewController{

    //MARK:OUTLET
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    //MARK: MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test si un user c'est déja connecté  et qu'il a deja valide son email on le redirige vers la page d'accueil
        Auth.auth().addStateDidChangeListener{ auth, user in
            if user != nil {
                if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified{
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                }
            }
        }
      
        setupButtons()
        setupTextFieldManager()
        
    }//END Func viewDidLoad
    
    //MARK: Functions
    
    // lisse les bords du bouton login
    private func setupButtons(){
       LoginButton.layer.cornerRadius = 20
    }
    
    // actions lors du click sur l'ecran le keyboard s'enlève
    private func setupTextFieldManager(){
        passwordTextField.delegate = self
        emailTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Actions
    @objc private func hideKeyboard() {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    //action lorsque le bouton login est cliqué
    @IBAction func LoginButtonWasPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if error != nil {
                print(error.debugDescription)
            }else{
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
    }//END FUNC loginButtonWasPressed
    
    @IBAction func resetPasswordWasPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirmation", message: "Pour changer votre Mot de passe merci de renseigner votre adresse mail", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (login) in
            login.placeholder = "Votre E-mail"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let login = alert?.textFields![0]
            Auth.auth().sendPasswordReset(withEmail: login?.text! ?? "erreur" ) { error in
             print("email pour le reset password envoyé")
            }
            
        }))
        alert.addAction(UIAlertAction(title: "annuler", style: .cancel, handler: nil)) // bouton annuler de l'alerte
    
        self.present(alert, animated: true, completion: nil) // on affiche l'alerte
    }
}// END class LoginController




//MARK:EXTENSIONS
extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}





