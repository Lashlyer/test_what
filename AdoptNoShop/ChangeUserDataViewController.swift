//
//  ChangeUserDataViewController.swift
//  
//
//  Created by Alvin on 2019/6/28.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ChangeUserDataViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate : LeftTableViewController?
    @IBAction func goButton(_ sender: Any) {
        
        self.delegate?.userImageDownLoad()
    }
    var uploadImage : UIImage?
    @IBOutlet weak var userImage: UIImageView!
    @IBAction func selectPicture(_ sender: Any) {
        let pickImage = UIImagePickerController()
        pickImage.sourceType = UIImagePickerController.SourceType.photoLibrary
        pickImage.allowsEditing = false
        pickImage.delegate = self
        
        present(pickImage, animated: true, completion: nil)
        
    }
    @IBAction func saveButton(_ sender: Any) {
        
        if let uid = Auth.auth().currentUser?.uid {
            if let imageData = self.uploadImage!.jpegData(compressionQuality: 0.5){
                
                let reference = Storage.storage().reference().child(uid).child(uid)
                let metadata = StorageMetadata()
                reference.putData(imageData, metadata: metadata) { (metadata, error) in
                    
                    if error != nil {
                        
                        print(error?.localizedDescription)
                    } else {
                        self.diplayAlert(title: "OK", message: "dadada")
                        
                    }
                }
                
            }
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "會員資料修改"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[(UIImagePickerController.InfoKey).originalImage] as! UIImage
        
        uploadImage = image
        userImage.image = image
        picker.dismiss(animated: true, completion: nil)
        var filename = "image.JPG"
        
        if let url = info[(UIImagePickerController.InfoKey).imageURL] as? URL {
            
            filename = url.lastPathComponent
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func diplayAlert(title:String, message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "ok", style: .default) { (UIAlertAction) in
        }
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
