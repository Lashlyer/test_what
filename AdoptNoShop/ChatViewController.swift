//
//  ChatViewController.swift
//
//
//  Created by Alvin on 2019/6/21.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var chatConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var senderOutlet: UIButton!
    @IBOutlet weak var messageText: UITextField!
    let rechability = Reachability(hostName: "www.apple.com")
    var userName : String = ""
    var userUrl : String = ""
    var userTime : String = ""
    var picUrl : String = ""
    var sharePicture : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "聊天室"
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageText.delegate = self as? UITextFieldDelegate
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        retrieveMessages()
        messageTableView.separatorStyle = .none
        userDetailDataDownload()
    }
    
    @IBAction func sharePictureButton(_ sender: UIButton) {
        
        let pickImage = UIImagePickerController()
        pickImage.sourceType = UIImagePickerController.SourceType.photoLibrary
        pickImage.allowsEditing = false
        pickImage.delegate = self
        
        present(pickImage, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[(UIImagePickerController.InfoKey).originalImage] as! UIImage
        sharePicture = image
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if sharePicture != nil {
            if let imageData = self.sharePicture!.jpegData(compressionQuality: 0.1) {
                let metaData = StorageMetadata()
                let chatRef = Storage.storage().reference().child("Message").child(uid)
                chatRef.putData(imageData, metadata: metaData) { (metadata, error) in
                    if error == nil {
                        chatRef.downloadURL(completion: { (url, error) in
                            if error != nil {
                                print(error?.localizedDescription)
                                
                            } else {
                                if let okUrl = url?.absoluteString{
                                    self.picUrl = okUrl
                                    let messageDB = Database.database().reference().child("Messages")
                                    
                                    guard let uid = Auth.auth().currentUser?.uid else {return}
                                    let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": self.messageText.text!,"uid": uid, "name" : self.userName, "url" : self.userUrl, "time" : self.userTime, "picUrl" : self.picUrl]
                                    messageDB.childByAutoId().setValue(messageDictionary)
                                }
                                
                            }
                        })
                        
                    } else {
                        
                        print(error?.localizedDescription)
                    }
                }
                
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backItem(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    @IBAction func senderPress(_ sender: UIButton) {
        
        messageText.endEditing(true)
        
        messageText.isEnabled = false
        senderOutlet.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        picUrl = ""
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageText.text!,"uid": uid, "name" : userName, "url" : userUrl, "time" : userTime, "picUrl" : picUrl]
        
        messageDB.childByAutoId().setValue(messageDictionary) { (error, ref) in
            
            if error != nil {
                
                print(error!)
            } else {
                
                print("Message saved successfully")
                self.scorllToButtonm()
                self.messageText.isEnabled = true
                self.senderOutlet.isEnabled = true
                
                self.messageText.text = ""
                
            }
        }
    }
    
    func internetOK() -> Bool{
        if rechability?.currentReachabilityStatus().rawValue == 0 {
            
            return false
        } else {
            
            return true
        }
        
    }
    
    func scorllToButtonm () {
        
            let indexPath = IndexPath(row: self.messageArray.count-1, section: 0)
            messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        
        
    }
    func userDetailDataDownload () {
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let reference = Database.database().reference().child(uid).child("userDetail")
            
            reference.observe(.childAdded) { (snapShot) in
                
                let snapShotValue = snapShot.value as! Dictionary <String, String>
                
                self.userName = snapShotValue["name"]!
            }
        }
        if let uid = Auth.auth().currentUser?.uid {
            
            let reference = Database.database().reference().child(uid).child("userUrl")
            
            reference.observe(.childAdded) { (snapShot) in
                
                let snapShotValue = snapShot.value as! Dictionary <String, String>
                
                self.userUrl = snapShotValue["url"]!
            }
        }
        
        let date = Date()
        let dataFormatter : DateFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dataFormatter.locale = Locale(identifier: "zh_Hant_TW")
        userTime = dataFormatter.string(from: date)
        
    }
    
    func retrieveMessages() {
        if internetOK() == true {
            userDetailDataDownload()
            let messageDB = Database.database().reference().child("Messages")
            
            messageDB.observe(.childAdded) { (snapshot) in
                let snapshotValue = snapshot.value as! Dictionary<String, String>
                
                let text = snapshotValue["MessageBody"]!
                let sender = snapshotValue["Sender"]!
                let uid = snapshotValue["uid"]!
                let name = snapshotValue["name"]!
                let url = snapshotValue["url"]!
                let time = snapshotValue["time"]!
                let picUrl = snapshotValue["picUrl"]!
                let message = Message()
                message.messageBody = text
                message.sender = sender
                message.uid = uid
                message.name = name
                message.url = url
                message.time = time
                message.picUrl = picUrl
                self.messageArray.append(message)
                self.messageTableView.reloadData()
            }
        }  else {
            
            diplayAlert(title: "錯誤", message: "請檢察網路是否開啟")
        }
    }
    
    
    var messageArray: [Message] = [Message]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messageArray[indexPath.row].sender == Auth.auth().currentUser?.email as! String && messageArray[indexPath.row].picUrl != "" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellUserPic", for: indexPath) as? UserPicTableViewCell {
                cell.initdata()
                cell.userName.text = messageArray[indexPath.row].name
                cell.userEnterTime.text = messageArray[indexPath.row].time
                let url = URL(string: messageArray[indexPath.row].url)
                
                if (url as? URL) != nil {
                    cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "waiting"), options: [], completed: nil)
                }
                let picUrl = URL(string: messageArray[indexPath.row].picUrl)
                
                if (picUrl as? URL) != nil {
                    cell.sharePic.sd_setImage(with: picUrl, placeholderImage: UIImage(named: "waiting"), options: [], completed: nil)
                }
                
                
                return cell
                
            }

            
            
        } else if messageArray[indexPath.row].sender != Auth.auth().currentUser?.email as! String && messageArray[indexPath.row].picUrl != "" {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellChatPic", for: indexPath) as? ChatPicShareTableViewCell {
                
                cell.initdata()
                cell.userName.text = messageArray[indexPath.row].name
                cell.userEnterTime.text = messageArray[indexPath.row].time
                let url = URL(string: messageArray[indexPath.row].url)
                if (url as? URL) != nil {
                    
                    cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "waiting"), options: [], completed: nil)
                }
                
                let sharurl = URL(string: messageArray[indexPath.row].picUrl)
                
                if (sharurl as? URL) != nil {
                    
                    cell.sharePic.sd_setImage(with: sharurl, placeholderImage: UIImage(named: "waiting"), options: [], completed: nil)
                }
                
                return cell
            }
         
        } else if messageArray[indexPath.row].sender == Auth.auth().currentUser?.email as! String {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as? UserTableViewCell {
                cell.initdata()
                
                cell.userMessage.text = messageArray[indexPath.row].messageBody
                cell.userName.text = messageArray[indexPath.row].name
                cell.userEnterTime.text = messageArray[indexPath.row].time
                
                let url = URL(string: messageArray[indexPath.row].url)
                
                if (url as? URL) != nil {
                    
                    cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "waiting"), options: [], completed: nil)
                }
                return cell
                
            }
            
            
            
        } else if messageArray[indexPath.row].sender != Auth.auth().currentUser?.email as! String {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChatTableViewCell{
                cell.initdata()
                
                cell.userMessage.text = messageArray[indexPath.row].messageBody
                cell.userName.text = messageArray[indexPath.row].name
                cell.userEnterTime.text = messageArray[indexPath.row].time
                
                let url = URL(string: messageArray[indexPath.row].url)
                if (url as? URL) != nil {
                    
                    cell.UserImage.sd_setImage(with: url, placeholderImage: UIImage(named: "waiting"), options: [], completed: nil)
                }
                return cell
                
            }
            
        }
        
        return UITableViewCell()
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if messageArray[indexPath.row].sender == Auth.auth().currentUser?.email as! String && messageArray[indexPath.row].picUrl != "" {
            
            return 250.0
        } else if messageArray[indexPath.row].sender != Auth.auth().currentUser?.email as! String && messageArray[indexPath.row].picUrl != "" {
            
            return 250.0
        }
        
        return 125.0
    }
  
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    @objc func tableViewTapped() {
        messageText.endEditing(true)
        
    }
    func diplayAlert(title:String, message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
