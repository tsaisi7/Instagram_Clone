//
//  HomeViewController.swift
//  Instagram_Clone
//
//  Created by Adam on 2021/10/14.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Alamofire
import AlamofireImage

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var emailArray = [String]()
    var imageUrlArray = [String]()
    var postTextArray = [String]()
    var storageRef: StorageReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    
    func getData(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("posts").observe(.childAdded) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            self.emailArray.append(value["postedBy"] as! String)
            self.imageUrlArray.append(value["image"] as! String)
            self.postTextArray.append(value["postText"] as! String)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
        
        

    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let loginVC = self.storyboard?.instantiateViewController(identifier: "loginVC")
            let delegate: SceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
            delegate.window?.rootViewController = loginVC
            
        }catch let error as NSError{
            print("ERROR: \(error)")
        }
    }
}
extension HomeViewController: UITableViewDelegate{
    
}
extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        if let cell = cell as? PostTableViewCell{
            cell.userNameLabel.text = emailArray[indexPath.row]
            cell.postText.text = postTextArray[indexPath.row]
            print(postTextArray[indexPath.row])
            let filePath = imageUrlArray[indexPath.row]
            AF.request(filePath).responseImage { (response) in
                if case .success(let image) = response.result {
                    print("image downloaded: \(image)")
                    let size = CGSize(width: 390, height: 280)
                    let image = image.af_imageAspectScaled(toFit: size)
                    cell.postImage.image = image
                }
            }
            return cell
        }
        return cell
    }
    
    
}
