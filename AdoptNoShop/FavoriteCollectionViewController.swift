//
//  FavoriteCollectionViewController.swift
//  TestFuckJson
//
//  Created by Alvin on 2019/6/17.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

class FavoriteCollectionViewController: UICollectionViewController {
    
    @IBOutlet var myCollectionView: UICollectionView!
    let rechability = Reachability(hostName: "www.apple.com")
    let reference = Database.database().reference()
    var favorietDogs : [DataSnapshot] = []
    var favoriteDogsback : [DataSnapshot] = []
    var session = URLSession(configuration: .default)
    weak var delegate : AllDogTableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的收藏"

    }
    
    
    func retriveData(){
        if internetOK() == true {
            var realId : String = ""
            guard let email = Auth.auth().currentUser else {return}
            
            realId = email.uid
            
            self.favorietDogs.removeAll()
            reference.child(realId).child("love").observe(DataEventType.childAdded) { (dataSnapShot) in
                
                self.favorietDogs.append(dataSnapShot)
                dataSnapShot.ref.removeAllObservers()
                self.myCollectionView.reloadData()
                
            }
        } else {
            
            diplayAlert(title: "錯誤", message: "請檢察網路是否開啟")
        }
    }
    
    func internetOK() -> Bool{
        if rechability?.currentReachabilityStatus().rawValue == 0 {
            
            return false
        } else {
            
            return true
        }
        
    }
    
    func backData() {
        
        var realId : String = ""
        guard let email = Auth.auth().currentUser else {return}
        
        realId = email.uid
        self.favorietDogs.removeAll()
        reference.child(realId).child("love").observe(DataEventType.childAdded) { (dataSnapShot) in
            self.favorietDogs.append(dataSnapShot)
            dataSnapShot.ref.removeAllObservers()
            self.myCollectionView.reloadData()
        
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        retriveData()
        print(favorietDogs.count)
        self.myCollectionView.reloadData()
    }
    
  
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return favorietDogs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as? FavoriteCollectionViewCell else {
            let cell = UICollectionViewCell()
            return cell
        }
        
        cell.initdata()
        let snapShot = favorietDogs[indexPath.item]
        
        if let favorietDogs = snapShot.value as? [String : Any] {
            
            guard let dogImage = favorietDogs["picture"] as? String, let dogUrl = URL(string: dogImage) else {
                
                return cell
            }
           cell.dogsImage.sd_setImage(with: dogUrl, placeholderImage: UIImage(named: "waiting"), options: [], progress: nil, completed: nil)
            
           
           
        }
    
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 30
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if let go = self.storyboard?.instantiateViewController(withIdentifier: "DogDeailTableViewController") as? DogDeailTableViewController {
            if let cell = collectionView.cellForItem(at: indexPath) as? FavoriteCollectionViewCell, let image = cell.dogsImage.image {
                go.newfuckImage = image
                
                }
            if indexPath.item > favorietDogs.count-1 {
                return
            }
            let snapShot = favorietDogs[indexPath.item]
            
            if let favoriteDogs = snapShot.value as? [String : Any] {
                go.newinfoNumber = favoriteDogs["dogNumber"] as? String
                
                go.newinfoSex = favoriteDogs["sex"] as? String

                go.newinfoFound = favoriteDogs["foundPlace"] as? String
                
                go.newinfoAddress = favoriteDogs["address"] as? String
                    
                go.newDogSuck = favoriteDogs["dogSick"] as? String
            
                go.newHospital = favoriteDogs["dogEgg"] as? String
                
                go.newinfoHouse = favoriteDogs["house"] as? String
                
                go.newinfoPhone = favoriteDogs["housePhone"] as? String
                
                go.newinfoOpenTime = favoriteDogs["openTime"] as? String
                
                go.newinfoUpdate = favoriteDogs["updateTime"] as? String
            
                go.newDogAge = favoriteDogs["dogAge"] as? String
                
                go.newBodyType = favoriteDogs["dogBody"] as? String
             
            }
            
            go.userlove = true
            go.favoriteButtonOulet.image = UIImage(named: "heartminus")
            go.delegate = self
            self.navigationController?.pushViewController(go, animated: true)

        }
      
    }
    
    func diplayAlert(title:String, message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

   
}
