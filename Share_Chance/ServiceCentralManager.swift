import UIKit
import RealmSwift
import CoreBluetooth

protocol ServiceCentralManagerDelegate {
    func dealWithCharacteristic(peripheral: CBPeripheral, characteristic: CBCharacteristic)
    func displayCharacteristicValue(value: String)
}

class ServiceCentralManager: NSObject {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var delegate : ServiceCentralManagerDelegate!
    let serviceUUID = CBUUID(string: "FFF0")
    let characteristicUUID = CBUUID(string: "FFF1")
    var all: String?
    var title: String?
    var category: String?
    var like: String?
    
    var realm: Realm!
    var information: Results<Information>!
    var my_id: Results<Id>!
    var rid: String?
    
    
    // サービスを作成してペリフェラルマネージャに登録する
    init(all: String) {
        self.all = all
        super.init()
        // 並列処理
        let centralQueue: DispatchQueue = DispatchQueue(label: "-.com.e165733.central", attributes: [])
        //バックグラウンド動作
//        let centralOptions: [String : AnyObject] = [
//            CBCentralManagerOptionRestoreIdentifierKey : "-.com.e165733.central.restore" as AnyObject
//        ]
        self.centralManager = CBCentralManager(delegate: self, queue: centralQueue, options: nil)
    }
    
}

extension ServiceCentralManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    /**
     * セントラルマネージャが生成された際のデリゲートメソッド
     */
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // CBUUIDオブジェクトの配列を指定すると該当するサービスをアドバタイズしているペリフェラルのみが返される
            self.centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
            
            let arr1 = all?.components(separatedBy: ",")
            
            title = arr1![0]
            category = arr1![1]
            like = arr1![2]
            
        default:
            return
        }
    }
    /**
     * ペリフェラルを検出した際のデリゲートメソッド
     */
    internal func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //print("Name of BLE device discovered: \(String(describing: peripheral.name))")
        // 接続先のペリフェラルが見つかったら、省電力のため、他のペリフェラルの走査は停止する
        self.centralManager.stopScan()
        
        self.peripheral = peripheral
        // 検出したペリフェラルに接続する
        self.centralManager.connect(peripheral, options: nil)
    }
    /**
     * ペリフェラルの接続に成功した際のデリゲートメソッド
     */
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        //print("Successful connect to the peripheral.")
        
        // ペリフェラルとのやり取りを始める前に、ペリフェラルのデリデートをセット
        peripheral.delegate = self
        
        // UUIDを保存しておく
        let UUID = peripheral.identifier.uuidString
        UserDefaults.standard.set(UUID, forKey: "UUID")
        
        // サービスの検出開始
        // 不要なサービスが多数見つかる場合、電池と時間が無駄になるので必要なサービスのUUIDを具体的に指定すると良い
        peripheral.discoverServices([serviceUUID])
    }
    /**
     * ペリフェラルの接続に失敗した際のデリゲートメソッド
     */
    internal func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        //print("Failure to connect to peripheral.")
    }
    /**
     * サービスを検出した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        //print("サービスを検出")
        if error != nil {
            //print("Failed to detect service.")
            return
        }
        guard let services = peripheral.services  else {
            return
        }
        //print("Discover \(services.count) services! \(services)")
        for service in services {
            // 特性をすべて検出する
            // 不要な特性が多数見つかる場合、電池と時間が無駄になるので必要な特性のUUIDを具体的に指定する
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
    }
    /**
     * 特性を検出した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        //print("Discover \(characteristics.count) characteristics! \(characteristics)")
        for characteristic in characteristics {
            self.delegate?.dealWithCharacteristic(peripheral: peripheral, characteristic: characteristic)
        }
    }
    /**
     * 特性の値の読み取りが終了した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let error = error {
            print("\(error.localizedDescription)")
            return
        }
        guard let value = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) else {
            return
        }
        let arr2 = value.components(separatedBy: ",")
        
        print(title! + category! + like!)
        print(arr2[0] + arr2[1] + arr2[2])
        
        var judge: Bool
        var inf_id:[String] = []
        
        do{
            let realm = try Realm()
            information = realm.objects(Information.self).sorted(byKeyPath: "id")
            my_id = realm.objects(Id.self)
            
        }catch{
            
        }
        
        let me = (Int)(my_id[0].my_id)
        let you = (Int)(arr2[3])
        
        if me! < you! {
            rid = my_id[0].my_id + "_" + arr2[3]
        }else{
            rid = arr2[3] + "_" + my_id[0].my_id
        }
        
        if (information.count==0) {
            judge = true
        }else if (information.count==1){
            inf_id.append(information[0].id)
            
            if(inf_id.contains(rid!) == false){
                judge = true
            }else{
                judge = false
            }
        }else{
            for i in 0...(information.count-1){
                inf_id.append(information[i].id)
            }
            if(inf_id.contains(rid!) == false){
                judge = true
            }else{
                judge = false
            }
        }
        
        if(judge==true && arr2[0]==title && arr2[1]==category && arr2[2]==like){
            
            let inf = Information()
            
            inf.you_id = arr2[3]
            inf.id = rid!
            inf.name = arr2[4]
            inf.mach = arr2[0]
            inf.pr = arr2[5]
            
            do{
                let realm = try Realm()
                try realm.write({ () -> Void in
                    realm.add(inf)
                    print("Saved")
                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                })
            }catch{
                print("Save is Faild")
            }
            print(arr2[4] + "さんとマッチングしました")
            self.delegate?.displayCharacteristicValue(value: arr2[4] as String)
            
        }
        
    
        //特性の値をラベルに表示する
        
    }
    /**
     * 通知の申し込みが終了した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("\(error.localizedDescription)")
            return
        }
    }


}
