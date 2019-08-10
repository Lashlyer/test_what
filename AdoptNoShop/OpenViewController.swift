//
//  OpenViewController.swift
//  
//
//  Created by Alvin on 2019/6/14.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import FirebaseAuth
import RSLoadingView
import UserNotifications
class OpenViewController: SlideMenuController,UITextFieldDelegate {
    
    let backloadingView = RSLoadingView()
    let rechability = Reachability(hostName: "www.apple.com")
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var bakaView: UIView!
    @IBOutlet weak var openImageView: UIImageView!

    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    
    var email:String = ""
    @IBOutlet weak var createButtonOutlet: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailAddress: UITextField!

    @IBAction func createButton(_ sender: UIButton) {
        if internetOK() == true {
            if let go = self.storyboard?.instantiateViewController(withIdentifier: "Registered") {
                
                present(go, animated: true, completion: nil)
            }
        }else {
            
            diplayAlert(title: "錯誤", message: "請檢察網路喔")
        }
        
    }
    @IBAction func logInButton(_ sender: UIButton) {
        if internetOK() == true {
            if emailAddress.text != "" && password.text != "" {
                
                
                authServeice(email: emailAddress.text!, password: password.text!)
                checkLogIn()
            }else{
                diplayAlert(title: "錯誤", message: "請輸入您的帳號跟密碼")
                
                print("Please entrance your email or passsword")
            }
            
        } else {
            
            diplayAlert(title: "錯誤", message: "請檢查網路喔")
        }
        
    }
    
    func checkLogIn () {
        
        UserDefaults.standard.set(emailAddress.text!, forKey: "email")
        UserDefaults.standard.set(password.text!, forKey: "password")
        
    }
    
    func iDNoLogOut () {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {return}
        guard let password = UserDefaults.standard.value(forKey: "password") as? String else {return}
        
        if email != "" {
            
            authServeice(email: email, password: password)
        }
        
    }
    
    func checkLogOut () {
        
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.loginButtonOutlet.layer.cornerRadius = 10
        self.createButtonOutlet.layer.cornerRadius = 10
        emailAddress.delegate = self
        password.delegate = self
        bakaView.isHidden = true
        backloadingView.sizeInContainer = CGSize(width: 120, height: 120)
        backloadingView.speedFactor = 1.5
        loacalNotification()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        iDNoLogOut()
    }
    
    func loacalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "有新的浪浪更新囉"
        
        content.body = "快來看看吧～"

        content.sound = UNNotificationSound.default
        
        var date = DateComponents()
        date.hour = 17
        date.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailAddress.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    func diplayAlert(title:String, message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func internetOK() -> Bool{
        if rechability?.currentReachabilityStatus().rawValue == 0 {
            
            return false
        } else {
            
            return true
        }
        
    }
  
    
    func authServeice(email:String, password:String){
        backloadingView.show(on: bakaView)
        bakaView.isHidden = false
        signInLabel.isHidden = false
        signInLabel.text = "正在登入..."
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                
                let errorString = String(describing: (error as! NSError).userInfo["FIRAuthErrorUserInfoNameKey"]!)
                
                if errorString == "ERROR_USER_NOT_FOUND"{
                    
                    self.diplayAlert(title: "登入失敗", message: "帳號尚未註冊喔，請先點擊註冊新增帳號")
                    self.bakaView.isHidden = true
                } else if errorString == "ERROR_INVALID_EMAIL" {
                    self.diplayAlert(title: "登入失敗", message: "請輸入正確的信箱")
                    self.bakaView.isHidden = true

                }
                
                
            } else {
                
                
                if let go = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") {
       
                    self.present(go, animated: true, completion: nil)
                    
                }
                
            }

        }
        
    }

}
