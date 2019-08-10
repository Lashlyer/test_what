//
//  UserDetailDataViewController.swift
//  TestFuckJson
//
//  Created by Alvin on 2019/6/30.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import RSLoadingView
class UserDetailDataViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let loadIngViewGo = RSLoadingView()
    let loadIngViewGoGo = RSLoadingView()
    @IBOutlet weak var userImageBackView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadIngView: UIView!
    @IBAction func selectPictureButton(_ sender: Any) {
        
        let pickImage = UIImagePickerController()
        pickImage.sourceType = UIImagePickerController.SourceType.photoLibrary
        pickImage.allowsEditing = false
        pickImage.delegate = self
        
        present(pickImage, animated: true, completion: nil)
    }
    weak var delegate : LeftTableViewController?
    var uploadImage : UIImage?
    @IBOutlet weak var userPhoneTextFeild: UITextField!
    @IBOutlet weak var userEmailTextFeild: UITextField!

    @IBOutlet weak var userNameTextFeild: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 10
        userPhoneTextFeild.delegate = self
        userNameTextFeild.delegate = self
        userEmailTextFeild.delegate = self
        userDetailDataDownload()
        userImageDownLoad()
        
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.layer.borderColor = UIColor.white.cgColor
        userImageBackView.layer.borderWidth = 1
        userImageBackView.clipsToBounds = true
        userImageBackView.layer.cornerRadius = userImageBackView.frame.width / 2
        userImageBackView.layer.borderColor = UIColor.white.cgColor
        loadIngViewGoGo.sizeInContainer = CGSize(width: 40, height: 40)
        loadIngViewGoGo.speedFactor = 1.5
        loadIngViewGo.sizeInContainer = CGSize(width: 120, height: 120)
        loadIngViewGo.dimBackgroundColor = UIColor.black.withAlphaComponent(0.1)
        loadIngViewGo.speedFactor = 1.5
        
        loadIngView.isHidden = true
        loadingLabel.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func changeDataButton(_ sender: Any) {
        
        userDetailDataChange()
        upLoadImage()
    }

    func upLoadImage () {
        
        loadIngView.isHidden = false
        loadingLabel.isHidden = false
        loadIngViewGo.show(on: loadIngView)
        if uploadImage != nil {
            
            if let uid = Auth.auth().currentUser?.uid {

                if let imageData = self.uploadImage!.jpegData(compressionQuality: 0.5){
                    
                    let reference = Storage.storage().reference().child(uid).child(uid)
                    let metadata = StorageMetadata()
                    reference.putData(imageData, metadata: metadata) { (metadata, error) in
                        
                        if error != nil {
                            
                            print(error?.localizedDescription)
                        } else {
                           
                            reference.downloadURL(completion: { (url, error) in
                                
                                if let okUrl = url?.absoluteString{
                                    
                                    self.userUrlChange(url: okUrl)
                                }
                            })
                            self.loadIngView.isHidden = true
                            self.loadingLabel.isHidden = true
                            
                            self.diplayAlert(title: "儲存完畢", message: "資料修改完成")
                            
                        }
                    }
                    
                }
                
            }
        } else {
            
            self.loadIngView.isHidden = true
            self.loadingLabel.isHidden = true
            self.diplayAlert(title: "儲存完畢", message: "資料修改完成")
        }
        
    }
    
    func diplayAlert(title:String, message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "ok", style: .default) { (UIAlertAction) in
        }
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[(UIImagePickerController.InfoKey).originalImage] as! UIImage
        
        uploadImage = image
        userImage.image = image
        print(image)
        picker.dismiss(animated: true, completion: nil)
        var filename = "image.JPG"
        
        if let url = info[(UIImagePickerController.InfoKey).imageURL] as? URL {
            
            filename = url.lastPathComponent
            
        }
    }
    func userUrlChange(url : String) {
        if let uid = Auth.auth().currentUser?.uid {
            let reference = Database.database().reference().child(uid).child("userUrl")
            reference.observe(.childAdded, with: { (snapShot) in
                let key = snapShot.key
                
                
                let data : [String : String] = ["url" : url]
                
                reference.child(key).setValue(data)
            })
        }
        
    }
    func userDetailDataChange () {
        
        if let uid = Auth.auth().currentUser?.uid {
            let reference = Database.database().reference().child(uid).child("userDetail")
            reference.observe(.childAdded) { (snapShot) in
                
                let key = snapShot.key
                print(key)
                let snpaShotValue = snapShot.value as! Dictionary<String, String>
                
                let dataDic : [String : String] = ["email" : self.userEmailTextFeild.text!, "name" : self.userNameTextFeild.text!, "phone" : self.userPhoneTextFeild.text!]
                reference.child(key).setValue(dataDic)
            }
            
        }
        
    }
    
    
    
    func userDetailDataDownload () {
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let reference = Database.database().reference().child(uid).child("userDetail")
            
            reference.observe(.childAdded) { (snapShot) in
                
                let snapShotValue = snapShot.value as! Dictionary <String, String>
                
                self.userEmailTextFeild.text = snapShotValue["email"]!
                self.userNameTextFeild.text = snapShotValue["name"]!
                self.userPhoneTextFeild.text = snapShotValue["phone"]!
            }
        }
    }
    
    func userImageDownLoad(){
        userImageBackView.isHidden = false
        loadIngViewGoGo.show(on: userImageBackView)
        if let uid = Auth.auth().currentUser?.uid {
            
            let reference = Database.database().reference().child(uid).child("userUrl")
            reference.observe(.childAdded) { (snapShot) in
                let snapShotValue = snapShot.value as! Dictionary<String, String>
                
                let url = snapShotValue["url"]!
                let turnUrl = URL(string: url)
                
                guard let okUrl = turnUrl else {return}
                
                self.userImage.sd_setImage(with: okUrl, placeholderImage: UIImage(named: "usericon"), options: [], completed: nil)
                self.userImageBackView.isHidden = true
                self.loadIngViewGoGo.hide()
            }
        }
     
    }
    
    func userDetailData (email : String, name : String, phone : String) {
        if let uid = Auth.auth().currentUser?.uid {
            let reference = Database.database().reference().child(uid).child("userDetail")
            let data : [String : String] = ["email" : email, "name" : name, "phone" : phone]
            
            reference.childByAutoId().setValue(data)
        }
        
        
    }
    
}
