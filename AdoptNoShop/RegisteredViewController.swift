//
//  UserDeailViewController.swift
//  
//
//  Created by Alvin on 2019/6/24.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import RSLoadingView

class RegisteredViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    let loadIngViewGO = RSLoadingView()
    var regist = false
    
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBAction func backItem(_ sender: Any) {
        loadIngViewGO.show(on: loadingView)
        loadingView.isHidden = false
        loadinLabel.isHidden = false
        loadinLabel.text = "載入中..."
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OpenViewController") {
            
            present(vc, animated: true, completion: nil)
        }
        
    }
    @IBOutlet weak var loadinLabel: UILabel!

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var registButtonOutlet: UIButton!
    @IBOutlet weak var downloadImage: UIImageView!
    var uploadImage : UIImage?
    @IBAction func selectPic(_ sender: UIButton) {
        let reference = Storage.storage().reference()
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let deleteImage = reference.child(uid).child(uid)
            
            deleteImage.delete { (error) in
                
                if error != nil {
                    
                    print(error?.localizedDescription)
                } else {
                    
                    
                }
            }
        }
        
        
    }
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    @IBOutlet weak var upLoadProgess: UIProgressView!
    @IBOutlet weak var userImage: UIImageView!
    @IBAction func upLoad(_ sender: UIButton) {
        
        let pickImage = UIImagePickerController()
        pickImage.sourceType = UIImagePickerController.SourceType.photoLibrary
        pickImage.allowsEditing = false
        pickImage.delegate = self
        
        present(pickImage, animated: true, completion: nil)
    
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
    
    func userDetailData (email : String, password : String, name : String, phone : String, url : String) {
        if let uid = Auth.auth().currentUser?.uid {
            let reference = Database.database().reference().child(uid).child("userDetail")
            let data : [String : String] = ["email" : email, "name" : name, "phone" : phone]
            
            reference.childByAutoId().setValue(data)
        }
        if let uid = Auth.auth().currentUser?.uid {
            let reference = Database.database().reference().child(uid).child("userUrl")
            let data : [String : String] = ["url" : url]
            
            reference.childByAutoId().setValue(data)
        }
        
        
    }
    
    func userImageDownLoad(){
        authServeice(email: emailAdress!.text!, password: passwordText!.text!)
        let storageRefenece = Storage.storage().reference()
        if let uid = Auth.auth().currentUser?.uid {
            let riverRef = storageRefenece.child(uid)
            riverRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                
                if error != nil {
                    
                    print(error?.localizedDescription)
                    
                } else {
                    
                    self.downloadImage.image = UIImage(data: data!)
                }
            }
        }
    }
    
    func diplayAlert(title:String, message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func authServeice(email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                
                let errorString = String(describing: (error as! NSError).userInfo["FIRAuthErrorUserInfoNameKey"]!)
                
                if errorString == "ERROR_USER_NOT_FOUND"{
                    
                    self.diplayAlert(title: "登入失敗", message: "帳號尚未註冊喔，請先點擊註冊新增帳號")
                    
                } else {
                    
                    
                }
                
                
            } else {
                
                
                if let go = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") {
                    
                    self.present(go, animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func RegisteredButton(_ sender: UIButton) {
        
        if regist == false {
           
            loadingView.isHidden = false
            loadinLabel.isHidden = false
            loadIngViewGO.show(on: loadingView)
            loadinLabel.text = "註冊中..."
            Auth.auth().createUser(withEmail: emailAdress.text!, password: passwordText.text!) { (user, error) in
                
                if error != nil {
                    
                    self.diplayAlert(title: "Create Acount Error", message: (error?.localizedDescription)!)
                    self.loadingView.isHidden = true
                    self.loadinLabel.isHidden = true
                    
                } else {
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = "Rider"
                    changeRequest?.commitChanges(completion: nil)
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        
                        if self.uploadImage != nil {
                            if let imageData = self.uploadImage!.jpegData(compressionQuality: 0.5){
                                let metaData = StorageMetadata()
                                let riverRef = Storage.storage().reference().child(uid).child(uid)
                                metaData.customMetadata = ["myKye" : "my Value"]
                                self.upLoadProgess.isHidden = false
                                
                                //上傳圖片
                                let task = riverRef.putData(imageData, metadata: metaData) { (metadata, error) in
                                    self.upLoadProgess.isHidden = true
                                    
                                    if error == nil {
                                        self.regist = true
                                        self.registButtonOutlet.setTitle("登入", for: .normal)
                                        self.diplayAlert(title: "完成", message: "完成註冊，現在可以開始登入囉")
                                        self.loadingView.isHidden = true
                                        self.loadinLabel.isHidden = true
                                        
                                        riverRef.downloadURL(completion: { (url, error) in
                                            print("fuck")
                                            if error != nil {
                                                
                                                print(error?.localizedDescription)
                                            } else {
                                                
                                                if let okUrl = url?.absoluteString {
                                                    
                                                   self.userDetailData(email: self.emailAdress.text!, password: self.passwordText.text!, name: self.userName.text!, phone: self.userPhone.text!, url:okUrl)
                                                }
                                                
                                            }
                                            
                                        })
                                        
                                    } else {
                                        
                                        print(error?.localizedDescription)
                                    }
                                }
                                task.observe(.progress) { (snapshot) in
                                    
                                    if let theProgess = snapshot.progress?.fractionCompleted {
                                        
                                        self.upLoadProgess.progress = Float(theProgess)
                                    }
                                }
                                
                            }
                        } else {
                            
                            self.regist = true
                            self.registButtonOutlet.setTitle("登入", for: .normal)
                            self.loadingView.isHidden = true
                            self.loadinLabel.isHidden = true
                            self.diplayAlert(title: "完成", message: "完成註冊，現在可以開始登入摟")
                        }
                        
                    }
                  
                }
                
            }
           
        } else {
            loadIngViewGO.show(on: loadingView)
            loadingView.isHidden = false
            loadinLabel.isHidden = false
            loadinLabel.text = "登入中..."
            authServeice(email: emailAdress.text!, password: passwordText.text!)
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = true
        upLoadProgess.isHidden = true
        emailAdress.delegate = self
        passwordText.delegate = self
        loadIngViewGO.speedFactor = 1.5
        loadIngViewGO.sizeInContainer = CGSize(width: 120, height: 120)
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.layer.borderColor = UIColor.white.cgColor
        emailAdress.text = ""
        passwordText.text = ""
        userName.text = ""
        userPhone.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

