//
//  
//
//
//  Created by Alvin on 2019/5/31.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class DogDeailTableViewController: UITableViewController {
    var saveArray : [String] = []
    var whyArray : [String] = []
    let reference = Database.database().reference()
    weak var delegate : FavoriteCollectionViewController?
    weak var delegateGO : AllDogTableViewController?

    @IBAction func shareButtom(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [myNewImage.image!,myNewNumber.text!,myDogAge.text!,myNewSex.text!,myDogSick.text!,myNewOpen.text!,myBodyType.text!,myNewFound.text!,myNewHouse.text!,myNewPhone.text!,myNewUpdate.text!,myNewAddress.text!,myDogHospital.text!], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    @IBOutlet weak var favoriteButtonOulet: UIBarButtonItem!
    var userlove = false
    
    @IBAction func favoriteButton(_ sender: UIBarButtonItem) {
        var realId:String = ""
        guard let email = Auth.auth().currentUser else {return}
        
        realId = email.uid
        switch userlove {
        case false:
            collectButtonON()
            let collectionData : [String : Any] = ["dogNumber" : newinfoNumber,"sex" : newinfoSex ,"foundPlace" : newinfoFound, "address": newinfoAddress, "dogSick" : newDogSuck, "dogEgg" : newHospital, "house" : newinfoHouse, "housePhone": newinfoPhone, "openTime" : newinfoOpenTime, "updateTime" : newinfoUpdate, "dogAge" : newDogAge, "dogBody" : newBodyType, "picture" : picture]
            
            reference.child(realId).child("love").childByAutoId().setValue(collectionData)
            
            diplayAlert(title: "通知", message: "浪浪已經加入收藏囉")
            
            print("dadada")
            break
        case true:
            collectButtonOff()
            reference.child(realId).child("love").queryOrdered(byChild: "dogNumber").queryEqual(toValue: newinfoNumber).observe(DataEventType.childAdded) { (dataSnapShot) in
                dataSnapShot.ref.removeValue()
                self.reference.child(realId).child("love").removeAllObservers()
                self.diplayAlert(title: "通知", message: "浪浪被刪除了")
            }

            break
       
        }

        print(userlove)
    }
    
    var picture : String?
    var newinfoNumber:String?
    var newinfoAddress:String?
    var newinfoSex:String?
    var newinfoHouse:String?
    var newinfoOpenTime:String?
    var newinfoUpdate:String?
    var newinfoPhone:String?
    var newinfoFound:String?
    var newfuckImage: UIImage?
    var newHospital:String?
    var newBodyType:String?
    var newDogSuck:String?
    var newDogAge:String?
    var userLoveOn = false
    
    @IBAction func callPhone(_ sender: UIButton) {
        
        guard let phoneNumber = newinfoPhone else { return }
        if let url = URL(string: "tel://\(phoneNumber)"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            print("dddddd")
        }
        
    }
    

    @IBOutlet weak var callButtonOutlet: UIButton!
    @IBOutlet weak var mapButtonOutlet: UIButton!
    @IBOutlet weak var myDogHospital: UILabel!
    @IBOutlet weak var myDogSick: UILabel!
    @IBOutlet weak var myBodyType: UILabel!
    @IBOutlet weak var myDogAge: UILabel!
    @IBOutlet weak var myNewFound: UILabel!
    
    @IBOutlet weak var myNewUpdate: UILabel!
    @IBOutlet weak var myNewOpen: UILabel!
    @IBOutlet weak var myNewPhone: UILabel!
    @IBOutlet weak var myNewAddress: UILabel!
    @IBOutlet weak var myNewHouse: UILabel!
    @IBOutlet weak var myNewSex: UILabel!
    @IBOutlet weak var myNewNumber: UILabel!
    @IBOutlet weak var myNewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "浪浪資訊"
        myNewNumber.text = newinfoNumber
        myNewSex.text = newinfoSex
        myNewAddress.text = newinfoAddress
        myNewFound.text = newinfoFound
        myNewImage.image = newfuckImage
        myNewPhone.text = newinfoPhone
        myNewUpdate.text = newinfoUpdate
        myNewOpen.text = newinfoOpenTime
        myNewHouse.text = newinfoHouse
        myDogAge.text = newDogAge
        myDogSick.text = newDogSuck
        myDogHospital.text = newHospital
        myBodyType.text = newBodyType
        
        myNewImage.clipsToBounds = true
        myNewImage.layer.cornerRadius = 30
        mapButtonOutlet.clipsToBounds = true
        mapButtonOutlet.layer.cornerRadius = 8
        callButtonOutlet.clipsToBounds = true
        callButtonOutlet.layer.cornerRadius = 8
        
        checkUserArray()
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(userlove)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 14
 
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "MapViewController" {
            if let dogsMap = segue.destination as? MapViewController{
                dogsMap.addresDetail = myNewAddress.text ?? ""
                dogsMap.addresTitle = myNewHouse.text ?? ""
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        checkUserArray()
        
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    func collectButtonON(){
        
        favoriteButtonOulet.image = UIImage(named: "heartminus")
        
        userlove = true
        
    }
    
    
    func collectButtonOff(){
        
        favoriteButtonOulet.image = UIImage(named: "heartplus")
        
        userlove = false
    }
    func checkUserArray()  {
        
        let reference = Database.database().reference()
        var realId : String = ""
        guard let email = Auth.auth().currentUser else {return}
        
        realId = email.uid
        
        
        reference.child(realId).child("love").observe(.childAdded) { (snapShot) in
            let snapshotValue = snapShot.value as! Dictionary<String, String>
            let get = snapshotValue["dogNumber"]!
            self.whyArray.append(get)
            snapShot.ref.removeAllObservers()
            if get == self.newinfoNumber ?? "" {
                
                self.favoriteButtonOulet.image = UIImage(named: "heartminus")
                
                self.userlove = true
            }
            
        }
     
    }
    

 
    func diplayAlert(title:String, message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
