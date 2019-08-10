//
//  LeftTableViewController.swift
//  
//
//  Created by Alvin on 2019/6/23.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import FirebaseAuth
import MessageUI
import FirebaseStorage
import RSLoadingView
import SDWebImage
import FirebaseDatabase

class LeftTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    weak var delegate : UIViewController?
    let loadIngViewGo = RSLoadingView()
    let loadIngViewGoGo = RSLoadingView()
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.layer.borderColor = UIColor.white.cgColor
        loadingView.layer.borderWidth = 1
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = userImage.frame.width / 2
        loadingView.layer.borderColor = UIColor.white.cgColor
        loadingView.isHidden = true
        loadIngViewGo.sizeInContainer = CGSize(width: 45, height: 45)
        loadIngViewGo.speedFactor = 1.5
        loadIngViewGoGo.sizeInContainer = CGSize(width: 120, height: 120)
        
        userImageDownLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userImageDownLoad()
    }
    func userImageDownLoad(){
        loadingView.isHidden = false
        loadIngViewGo.show(on: loadingView)
        if let uid = Auth.auth().currentUser?.uid {
            
            let reference = Database.database().reference().child(uid).child("userUrl")
            reference.observe(.childAdded) { (snapShot) in
                let snapShotValue = snapShot.value as! Dictionary<String, String>
                
                let url = snapShotValue["url"]!
                let turnUrl = URL(string: url)
                
                guard let okUrl = turnUrl else {return}
                
                self.userImage.sd_setImage(with: okUrl, placeholderImage: UIImage(named: "usericon"), options: [], completed: nil)
                self.loadingView.isHidden = true
                self.loadIngViewGo.hide()
            }
        }

    }

    
    @IBAction func userDetail(_ sender: UIButton) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailDataViewController") {
            

           (vc as? UserDetailDataViewController)?.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
//            self.tabBarController?.tabBar.isHidden = true
            
        }
    }
    

    
    @IBAction func goChatPage(_ sender: UIButton) {
        
        if let go = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") {
            
            self.navigationController?.pushViewController(go, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }
    }

    
    @IBAction func goMailPage(_ sender: UIButton) {
        
        let emailTitle = "意見回饋"
        let messageBody = ""
        let toRecipents = ["lashlyer123@gmail.com"]
        
        if MFMailComposeViewController.canSendMail() {
            let mc = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            
            present(mc, animated: true, completion: nil)
            
        } else {
            diplayAlert(title: "錯誤", message: "請登入apple信箱並開啟權限")
            print("fafafafafa")
        }

    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func informationPage(_ sender: UIButton) {
        
        if let go = self.storyboard?.instantiateViewController(withIdentifier: "InFoMationViewController") {
            
            self.navigationController?.pushViewController(go, animated: true)
//            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    
    @IBAction func logOut(_ sender: UIButton) {
        
        do{
            let backgroundView = UIView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
            backgroundView.backgroundColor = UIColor.clear
            self.tableView.addSubview(backgroundView)
            
            loadIngViewGoGo.show(on: backgroundView)
            
            try Auth.auth().signOut()
            checkLogOut()
            if let go = self.storyboard?.instantiateViewController(withIdentifier: "OpenViewController") {
                
                present(go, animated: true, completion: nil)
            }
            
        } catch {
            
            print("User could not sign out")
        }
        
        
        
    }
    func checkLogOut () {
        
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    func diplayAlert(title:String, message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "ok", style: .default) { (UIAlertAction) in
        }
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
