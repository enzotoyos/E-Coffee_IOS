//
//  InformationController.swift
//  E-COFFEE
//
//  Created by enzo toyos on 07/12/2020.
//

import UIKit
import Firebase

class InformationController: UIViewController {

    @IBOutlet weak var emailtextfield: UILabel!
    let db = Firestore.firestore() // initialisation Firestore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        afficherEmail()
       
    }
    
    
    private func afficherEmail(){
        let user = Auth.auth().currentUser
        
        if let user = user {
          let email = user.email
            print(email ?? "wait")
            self.emailtextfield.text = email
         
        }
    }

    
    private func supprimerUser(){
        
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
            print(error)
          } else {
            
            print("utilisateur supprimé")
          }
        }
    }
    
    // MARK: DELETE USER
    @IBAction func deleteButtonWasClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirmation", message: "Pour supprimer votre compte merci de vous authentifier", preferredStyle: .alert)

        //affichage de la Pop Up
        alert.addTextField { (login) in
            login.placeholder = "E-mail"
        }
        alert.addTextField { (password) in
            password.placeholder = "password"
            password.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let login = alert?.textFields![0]
            let password = alert?.textFields![1]
            print(login?.text ?? "erreur")
            print(password?.text ?? "erreur")
            
             Auth.auth().signIn(withEmail: login?.text! ?? "erreur", password: password?.text! ?? "erreur") { (authResult, error) in
                if error != nil {
                    print(error.debugDescription)
                }else{
                    print("utilisateur authentifié")
                    self.supprimerUser()
                    self.performSegue(withIdentifier: "goBackLogin", sender: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "annuler", style: .default, handler: nil))
    
        self.present(alert, animated: true, completion: nil)
    }//end function delete user
    
    
    
    // MARK: BUTTON CHANGE EMAIL
    @IBAction func changeEmailWasClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirmation", message: "Pour changer votre adresse mail merci de vous authentifier", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (login) in
            login.placeholder = "E-mail actuel"
        }
        alert.addTextField { (password) in
            password.placeholder = "password"
            password.isSecureTextEntry = true
        }
        alert.addTextField { (newEmail) in
            newEmail.placeholder = "nouvel E-mail"
        }
    
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let login = alert?.textFields![0]
            let password = alert?.textFields![1]
            let newEmail = alert?.textFields![2]
        
        
             Auth.auth().signIn(withEmail: login?.text! ?? "erreur", password: password?.text! ?? "erreur") { (authResult, error) in
                if error != nil {
                    print(error.debugDescription)
                }else{
                    print("utilisateur authentifié")
                    Auth.auth().currentUser?.updateEmail(to: newEmail?.text! ?? "erreur") { (error) in
                    print("email changé")
                        let user = Auth.auth().currentUser
                        if let user = user {
                          let uid = user.uid //recupere l'uid unique de l'utilisateur
                          let emailNew = user.email // recupere l'adrsse mail changé
                        
                            self.db.collection("users").document(uid).setData(["email": emailNew ?? "erreur"], merge: true) // merge = true permet de ne pas ecraser les donnees mais fusionner
                        }
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "annuler", style: .default, handler: nil)) // bouton annuler de l'alerte
    
        self.present(alert, animated: true, completion: nil) // on affiche l'alerte
        
    }
    
    //MARK: CHANGE COMPANY
    
    @IBAction func changeCompanyWasClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirmation", message: "Pour changer le nom de votre entreprise merci de vous authentifier", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (login) in
            login.placeholder = "E-mail"
        }
        alert.addTextField { (password) in
            password.placeholder = "password"
            password.isSecureTextEntry = true
        }
        alert.addTextField { (company) in
            company.placeholder = "Entreprise"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let login = alert?.textFields![0]
            let password = alert?.textFields![1]
            let company = (alert?.textFields![2])
            
             Auth.auth().signIn(withEmail: login?.text! ?? "erreur", password: password?.text! ?? "erreur") { (authResult, error) in
                if error != nil {
                    print(error.debugDescription)
                }else{
                    print("utilisateur authentifié")
                    let user = Auth.auth().currentUser
                    if let user = user {
                      let uid = user.uid //recupere l'uid unique de l'utilisateur
                        
                        print(company?.text! ?? "erreur")
                       self.db.collection("users").document(uid).setData(["company": company?.text! ?? "erreur"], merge: true) // merge = true permet de ne pas ecraser les donnees mais fusionner
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "annuler", style: .default, handler: nil))
    
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: MODIFY PASSWORD

    @IBAction func modifyPasswordWasClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirmation", message: "Pour changer votre Mot de passe merci de vous authentifier", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (login) in
            login.placeholder = "E-mail actuel"
        }
        alert.addTextField { (password) in
            password.placeholder = "password"
            password.isSecureTextEntry = true
        }
        alert.addTextField { (newPassword) in
            newPassword.placeholder = "Nouveau mot de passe"
        }
        alert.addTextField { (newPassword2) in
            newPassword2.placeholder = "Cofirmation mot de passe"
        }
    
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let login = alert?.textFields![0]
            let password = alert?.textFields![1]
            let newPassword = alert?.textFields![2]
         
        

             Auth.auth().signIn(withEmail: login?.text! ?? "erreur", password: password?.text! ?? "erreur") { (authResult, error) in
                if error != nil {
                    print(error.debugDescription)
                }else{

                    print("utilisateur authentifié")
                    Auth.auth().currentUser?.updatePassword(to: newPassword?.text! ?? "erreur") { (error) in    print("mot de passe change")
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "annuler", style: .default, handler: nil)) // bouton annuler de l'alerte
    
        self.present(alert, animated: true, completion: nil) // on affiche l'alerte
        
    }
    

}

