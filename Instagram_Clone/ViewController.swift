//
//  ViewController.swift
//  Instagram_Clone
//
//  Created by Adam on 2021/10/12.
//

import UIKit
import Firebase
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error{
                    print("ERROR: \(error.localizedDescription)")
                    return
                }else{
                    print("\(String(describing: user?.user.email)) login")
                    if let homevc = self.storyboard?.instantiateViewController(identifier: "home"){
                        self.present(homevc, animated: true, completion: nil)
                    }
                }
            }
        }else{
            print("Please input all TextField")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

