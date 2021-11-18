//
//  UploadViewController.swift
//  Instagram_Clone
//
//  Created by Adam on 2021/10/14.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class UploadViewController: UIViewController {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    let picker = UIImagePickerController()
    let navigation = UINavigationController()
    var storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        navigation.delegate = self
        if let _ = imageView.image{
            
        }else{
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.imagePressed))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func imagePressed(){
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        statusLabel.text = "Beginning Unload"
        if let image = imageView.image{
            
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                return
            }
            let imagepath = Auth.auth().currentUser!.uid + "/media/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpeg"
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let storageRef = self.storage.reference(withPath: imagepath)
            storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error{
                    self.statusLabel.text = "Upload Failed"
                    print(error.localizedDescription)
                    return
                }else{
                    self.statusLabel.text = "Upload Succeeded"
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        if let imageURL = url?.absoluteString{
                            let post = ["image": imageURL, "postedBy": Auth.auth().currentUser?.email, "postText": self.textView.text] as [String : Any]
                            Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("posts").childByAutoId().setValue(post)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func takephoto(_ sender: Any) {
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
}
extension UploadViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
extension UploadViewController: UINavigationControllerDelegate{
    
}
