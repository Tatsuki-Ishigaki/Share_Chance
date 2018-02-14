//
//  ThirdView_2Controller.swift
//  Share_Chance
//
//  Created by 石垣達樹 on 2018/02/13.
//  Copyright © 2018年 ishitatsu. All rights reserved.
//

import UIKit
import RealmSwift
import CoreBluetooth

class ThirdView_2Controller: UIViewController {
    
    var realm: Realm!
    var item: Results<Item>!
    var inf: Results<My_Information>!
    var my_id: Results<Id>!
    
    var itemTitle: String?
    var itemCategory: String?
    var itemLike: String?
    
    
    @IBOutlet weak var title_2: UILabel!
    @IBOutlet weak var category_2: UILabel!
    @IBOutlet weak var like_2: UILabel!
    
    var serviceCentralManager: ServiceCentralManager?
    var servicePeripheralManager: ServicePeripheralManager?
    
    var isWriteState = false
    var isReadState = false
    var isNotificationSate = false
    var timer:Timer = Timer()
    var all: String?
    
    @IBOutlet weak var characteristicLabel: UILabel?
    @IBAction func back(_ sender:UIButton) {
        servicePeripheralManager?.peripheralManager?.stopAdvertising()
        isNotificationSate = false
        if timer.isValid == true {
            //timerを破棄する.
            timer.invalidate()
        }
        self.serviceCentralManager?.centralManager.stopScan()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title_2.text = itemTitle
        category_2.text = itemCategory
        like_2.text = itemLike
        
        super.viewDidLoad()
        characteristicLabel?.text = ""
        
        do{
            let realm = try Realm()
            item = realm.objects(Item.self).sorted(byKeyPath: "like")
            inf = realm.objects(My_Information.self)
            my_id = realm.objects(Id.self)
            
        }catch{
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startScan(_ sender: UIButton) {
        characteristicLabel?.text = "マッチングを開始！"
        timer = Timer.scheduledTimer(timeInterval: 4.0,
                                     target: self,
                                     selector: #selector(ThirdView_2Controller.Scan),
                                     userInfo: nil,
                                     repeats: true)
    }
    /**
     * ペリフェラルのスキャンを停止する
     */
    @IBAction func stopScan(_ sender: UIButton) {
        characteristicLabel?.text = "マッチングを終了"
        print("Stop advertisement")
        servicePeripheralManager?.peripheralManager?.stopAdvertising()
        print("stopScan")
        isNotificationSate = false
        if timer.isValid == true {
            //timerを破棄する.
            timer.invalidate()
        }
        self.serviceCentralManager?.centralManager.stopScan()
    }
    
    
    @objc func Scan(){
        
        let id = my_id[0].id
        
        let name = inf[0].name
        
        let pr = inf[0].pr
        
        let send_item:String = itemTitle! + "," + itemCategory! + "," + itemLike!

        let send_inf:String =  id + "," + name + "," + pr
        
        let send:String = send_item + "," + send_inf
        
        let settings = CharacteristicSettings(UUID: "FFF1", value: send)
        servicePeripheralManager = ServicePeripheralManager(characteristicSettings: settings)
        print("startScan")
        isNotificationSate = false
        isReadState = true
        
        all = String(itemTitle! + "," + itemCategory! + "," + itemLike!)
        
        serviceCentralManager = ServiceCentralManager(all: all!)
        serviceCentralManager?.delegate = self as ServiceCentralManagerDelegate
        
        
    }
    
}

extension ThirdView_2Controller: ServiceCentralManagerDelegate {
    
    func dealWithCharacteristic(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        // 読み取り
        if characteristic.properties.contains(.read) && isReadState == true {
            isReadState = false
            //print("Start reading data with property read.")
            // 特性の値を読み取る
            peripheral.readValue(for: characteristic)
        }
        // 通知
        if characteristic.properties.contains(.notify) && isNotificationSate == false {
            // 特性の値が変化したときに通知するよう申し込む
            isNotificationSate = true
            //print("Apply to notify when property values change.")
            peripheral.setNotifyValue(true, for: characteristic)
        }
 
    }
    // 特性の値をラベルに表示する
    func displayCharacteristicValue(value: String) {
        characteristicLabel?.text = value + "さんとマッチングしました"
    }
}

final class CharacteristicSettings {
    var UUID: String
    var value: String
    init(UUID: String, value: String) {
        self.UUID = UUID
        self.value = value
    }
}


extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
}
