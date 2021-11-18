//
//  SignUpViewController.swift
//  Instagram_Clone
//
//  Created by Adam on 2021/10/13.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confiempasswordTextField: UITextField!
    
    @IBAction func creatAccount(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text, let confiempassword = confiempasswordTextField.text{
            if password == confiempassword{
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }else{
                        print("\(String(describing: user?.user.email)) created")
                        if let homevc = self.storyboard?.instantiateViewController(identifier: "home"){
                            self.present(homevc, animated: true, completion: nil)
                        }
                    }
                }
            }else{
                print("Password didn't match")
            }
        }else{
            print("Please input all TextField")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
