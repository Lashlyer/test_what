//111
//  
//22222
//22222222222
//  Created by Alvin on 2019/5/27.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import SQLite3
import MessageUI
import FirebaseAuth
import RSLoadingView
import SDWebImage
import FirebaseDatabase

class AllDogTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    struct User:Decodable {//存取USER相關的資訊
        var animal_id:Int?
        var shelter_address:String?//地址
        var shelter_tel:String?//電話
        var album_file:String?//圖片
        var shelter_name:String?
        var animal_sex:String?
        var animal_kind:String?
        var animal_area_pkid:Int?
        var animal_opendate:String?
        var cDate:String?
        var animal_foundplace:String?
        var animal_sterilization:String?//絕育
        var animal_bacterin:String?//狂犬病
        var animal_age:String?//年紀
        var animal_bodytype:String?//體型
    }
    
    let height:CGFloat = 15
    var session = URLSession(configuration: .default)
    var dogs:[User] = []
    var reuse:[User] = []
    var data:[User] = []
    var kindOfDogAndCat:[User] = []
    let cellSpacingHeight: CGFloat = 20.0
    let loadingView = UIView()
    var favorietDogs : [String] = []
    var downloadOk = false
    var backAllView = UIView()
    var save : String!
    var saveKind : String!
    let testloadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    let rechability = Reachability(hostName: "www.apple.com")
    
    @IBAction func searchData(_ sender: UIButton) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            vc.delegate = self
            vc.save = save
            vc.saveKind = saveKind
            self.navigationController?.pushViewController(vc, animated: true)
        }
        backAllView.isHidden = true
    }
    
    func searchDogData(status: Int) {//過濾縣市
        //過濾和reloadDat
        self.data = []
        if status == 0 {
            self.data = dogs
        }else{
            
            for dog in self.dogs {
                if dog.animal_area_pkid == status{
                    self.data.append(dog)
                }
            }
        }
        self.reuse = data
        self.tableView.reloadData()
        
        print(status)
    }
    
    func searchKindData(kind: Int) {//過濾貓狗
        
        self.data = reuse
        self.kindOfDogAndCat = []
        if kind == 0 {
            
            for dog in self.data {
                
                self.kindOfDogAndCat.append(dog)
                self.data = kindOfDogAndCat
                
            }
            print(data.count)
            
        } else if kind == 1 {
            
            for dog in self.data{
                if dog.animal_kind == "狗"{
                    self.kindOfDogAndCat.append(dog)
                    self.data = kindOfDogAndCat
                    
                }
            }
            print(data.count)
            
        }else{
            
            for dog in self.data{
                if dog.animal_kind == "貓"{
                    self.kindOfDogAndCat.append(dog)
                    self.data = kindOfDogAndCat
                    
                }
            }
            print(data.count)
        }
        
        self.tableView.reloadData()
        print("dasdada")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Thread.sleep(forTimeInterval: 3.0)
        downloadJson()
        self.navigationItem.title = "浪浪搜尋"
        
        testloadingView.dimBackgroundColor = UIColor.black.withAlphaComponent(0.7)
        testloadingView.speedFactor = 1.5
        testloadingView.sizeFactor = 2.0

        checkUserArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkUserArray()
        self.tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        tableViewBackView()
        
    }
    
    func internetOK() -> Bool{
        if rechability?.currentReachabilityStatus().rawValue == 0 {
            
            return false
        } else {
            
            return true
        }
        
    }
    
    func tableViewBackView () {
        
        if downloadOk == false {
            let red = CGFloat(arc4random_uniform(255)) / 255.0
            let green = CGFloat(arc4random_uniform(255)) / 255.0
            let blue = CGFloat(arc4random_uniform(255)) / 255.0
            let backgroundView = UIView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
            
            backAllView = UIView(frame: self.view.frame)
            
            
            backAllView.addSubview(backgroundView)
            testloadingView.show(on: backgroundView)
            testloadingView.mainColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
            
            backgroundView.backgroundColor = .clear
            
            self.tableView.addSubview(backAllView)
            backAllView.backgroundColor = .black
            backAllView.alpha = 0.6
            
        }
     
    }
    
    func checkUserArray()  {
        favorietDogs = []
        let reference = Database.database().reference()
        var realId : String = ""
        guard let email = Auth.auth().currentUser else {return}
        
        realId = email.uid
        
        
        reference.child(realId).child("love").observe(.childAdded) { (snapShot) in
            let snapshotValue = snapShot.value as! Dictionary<String, String>
            let get = snapshotValue["dogNumber"]!
            self.favorietDogs.append(get)
            snapShot.ref.removeAllObservers()
            self.tableView.reloadData()
        }
        
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return height
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath:\(indexPath)")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SpecialTableViewCell  else {
            let cell = UITableViewCell()
            return cell
        }
        
        cell.initdata()
        
        if data[indexPath.section].animal_sex == "M"{
            cell.mySexImage.image = UIImage(named: "masculine")
        }else if data[indexPath.section].animal_sex == "F"{
            cell.mySexImage.image = UIImage(named: "femenine")
        } else {
            
            cell.mySexImage.image = UIImage(named: "gowait")
        }
        for get in favorietDogs {
            if get == String(data[indexPath.section].animal_id!) {
                cell.loveImage.isHidden = false
            }
        }
        
        cell.myAge.text = dataChange(data: data[indexPath.section].animal_age ?? "")
        cell.myHospital.text = dataTrueOrFalseChange(data: data[indexPath.section].animal_sterilization ?? "")
        switch data[indexPath.section].animal_area_pkid {
        case 2:
            cell.myHouse.text = "台北市"
            break
        case 3:
            cell.myHouse.text = "新北市"
            break
        case 4:
            cell.myHouse.text = "基隆市"
            break
        case 5:
            cell.myHouse.text = "宜蘭市"
            break
        case 6:
            cell.myHouse.text = "桃園市"
            break
        case 7:
            cell.myHouse.text = "新竹縣"
            break
        case 8:
            cell.myHouse.text = "新竹市"
            break
        case 9:
            cell.myHouse.text = "苗栗縣"
            break
        case 10:
            cell.myHouse.text = "台中市"
            break
        case 11:
            cell.myHouse.text = "彰化縣"
            break
        case 12:
            cell.myHouse.text = "南投縣"
            break
        case 13:
            cell.myHouse.text = "雲林縣"
            break
        case 14:
            cell.myHouse.text = "嘉義縣"
            break
        case 15:
            cell.myHouse.text = "嘉義市"
            break
        case 16:
            cell.myHouse.text = "台南市"
            break
        case 17:
            cell.myHouse.text = "高雄市"
            break
        case 18:
            cell.myHouse.text = "屏東縣"
            break
        case 19:
            cell.myHouse.text = "花蓮縣"
            break
        case 20:
            cell.myHouse.text = "台東縣"
            break
        case 21:
            cell.myHouse.text = "澎湖縣"
            break
        case 22:
            cell.myHouse.text = "金門縣"
            break
        case 23:
            cell.myHouse.text = "連江縣"
            break
        default:
            cell.myHouse.text = "未知"
            break
        }
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 30
        
        //解析圖片網址
        guard let imageAdders = data[indexPath.section].album_file, let imageUrl = URL(string: imageAdders) else {
            return cell
        }
        
        //套件
        cell.myImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "waiting"), options: [], progress: nil, completed: nil)
        
        //apple原生
        
        //        session.downloadTask(with: imageUrl, completionHandler: { (url, responds, error) in
        //
        //            guard let okURL = url else{
        //                return
        //            }
        //
        //            do {
        //                let downloadImage = UIImage(data: try Data(contentsOf: okURL))
        //                DispatchQueue.main.async {
        //                    cell.myImageView.image = downloadImage//放圖片
        //
        //                }
        //            }catch {}
        //
        //        }).resume()
    
        return cell
    }
    
    func downloadJson(){
        if internetOK() == true {
            let url = URL(string: "http://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL")
            
            guard let downloadURL = url else {
                return
            }
            
            URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                guard let data = data else {
                    return
                }
                
                do{
                    let decoder = JSONDecoder()
                    //因為最外面是陣列，所以是[AllData]
                    let classer = try decoder.decode([User].self, from: data)
                    self.dogs = classer
                    self.data = classer
                    self.downloadOk = true
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                        self.backAllView.isHidden = true
                    }
                }catch{
                    print("error")
                }
                
                }.resume()
            
            print("hello")
        } else {
            
            diplayAlert(title: "錯誤", message: "請檢察網路是否開啟")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let go = self.storyboard?.instantiateViewController(withIdentifier: "DogDeailTableViewController") as? DogDeailTableViewController {
            if let cell = tableView.cellForRow(at: indexPath) as? SpecialTableViewCell, let image = cell.myImageView.image {
                go.newfuckImage = image
                if let dogsId = data[indexPath.section].animal_id{
                    go.newinfoNumber = String(dogsId)
                }
                
                if let dogsAddress = data[indexPath.section].shelter_address{
                    go.newinfoAddress = dogsAddress.replacingOccurrences(of: "~", with: "-")
                }
                
                go.newinfoSex = dataChange(data: data[indexPath.section].animal_sex ?? "")
                
                go.newinfoHouse = data[indexPath.section].shelter_name
                
                go.newinfoOpenTime = data[indexPath.section].animal_opendate
                
                if let dogsUpdate = data[indexPath.section].cDate{
                    go.newinfoUpdate  = dogsUpdate.replacingOccurrences(of: "/", with: "-")
                    
                }
                
                go.newinfoPhone = data[indexPath.section].shelter_tel
                
                if data[indexPath.section].animal_foundplace != " "{
                    go.newinfoFound = data[indexPath.section].animal_foundplace
                }else {
                    go.newinfoFound = "未知"
                }
                
                go.newHospital = dataTrueOrFalse(data: data[indexPath.section].animal_sterilization ?? "")
                
                go.newDogAge = dataChange(data: data[indexPath.section].animal_age ?? "")
                
                go.newDogSuck = dataTrueOrFalse(data: data[indexPath.section].animal_bacterin ?? "")
                
                go.newBodyType = dataChange(data: data[indexPath.section].animal_bodytype ?? "")
                
                go.picture = data[indexPath.section].album_file
                go.delegateGO = self
                
                self.navigationController?.pushViewController(go, animated: true)
                
                
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    func diplayAlert(title:String, message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dataChange(data:String) ->String {
        switch data {
        case "M":
            return "男生"
        case "F":
            return "女生"
        case "ADULT":
            return "成年"
        case "CHILD":
            return "幼年"
        case "SMALL":
            return "小型"
        case "MEDIUM":
            return "中型"
        case "BIG":
            return "大型"
            
        default:
            return "未知"
        }
        
        
    }
    
    func dataTrueOrFalse(data:String) ->String {
        
        switch data {
        case "T":
            return "是"
            
        case "F":
            return "否"
            
        default:
            return "未知"
        }
        
    }
    
    func dataTrueOrFalseChange (data : String) -> String {
        
        switch data {
        case "T":
            return "已絕育"
        case "F":
            return "未絕育"
        
        default:
            return "未知"
        }
    }
    
    
}

