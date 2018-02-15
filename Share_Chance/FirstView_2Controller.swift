import UIKit
import JSQMessages
import Firebase
import FirebaseDatabase
import RealmSwift


class FirstView_2Controller: JSQMessagesViewController {
    
    var you_name: String?
    var my_name: String?
    var my_id: String?
    var you_id: String?
    var mix_id: String?
    var my_pr: String?
    var flag: String?
    
    var realm: Realm!
    var infomation: Results<Information>!
    var my_inf: Results<My_Information>!
    var id: Results<Id>!
    
    var messages: [JSQMessage] = []
    
    //ID作成
    //自分ID
    var ida = "9999"
    //相手ID
    var idb = "8888"
    
    var rid = "8888_9999"
    
    
    let button = UIButton()
    
    var SelfIntroduction:String?
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        print("rid ID:", rid)
        
        inputToolbar.contentView.textView.text = ""
        let ref = Database.database().reference()
        
        SelfIntroduction = "---自動送信(自己紹介から)" + "---"
        
//        let flag_int = (Int)(flag!)
//        if  flag_int == 0 {
//            ref.child(String(rid)).childByAutoId().setValue(["senderId": senderId, "text": SelfIntroduction as Any, "displayName": senderDisplayName, "date": [".sv": "timestamp"]])
//
//            for i in 0...(infomation.count){
//                if(infomation[i].you_id == you_id){
//                    infomation[i].flag = "1"
//                }
//            }
//
//        }
        ref.child(String(rid)).childByAutoId().setValue(["senderId": senderId, "text": SelfIntroduction as Any, "displayName": senderDisplayName, "date": [".sv": "timestamp"]])
        
        ref.child(String(rid)).childByAutoId().setValue(["senderId": senderId, "text": text, "displayName": senderDisplayName, "date": [".sv": "timestamp"]])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ida = my_id!
//        idb = you_id!
//        rid = mix_id!
        
        
        do{
            let realm = try Realm()
            infomation = realm.objects(Information.self).sorted(byKeyPath: "id")
            my_inf = realm.objects(My_Information.self)
            id = realm.objects(Id.self)
            
        }catch{
            
        }
        
        button.frame = CGRect(x: 5, y: 20, width: 80, height: 30)
        button.backgroundColor = UIColor.darkGray
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10.0
        button.setTitle("<Back", for: .normal)
        button.addTarget(self, action: #selector(FirstView_2Controller.changeColor(sender: )), for: .touchUpInside)
        view.addSubview(button)
        //相手
        senderDisplayName = "Tatsuki"
        //自分
        senderId = "Test"
        let ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            guard let dic = snapshot.value as? Dictionary<String, AnyObject> else {
                return
            }
            guard let posts = dic[String(self.rid)] as? Dictionary<String, Dictionary<String, AnyObject>> else {
                return
            }
            // keyとdateが入ったタプルを作る
            var keyValueArray: [(String, Int)] = []
            for (key, value) in posts {
                keyValueArray.append((key: key, date: value["date"] as! Int))
            }
            keyValueArray.sort{$0.1 < $1.1}             // タプルの中のdate でソートしてタプルの順番を揃える(配列で) これでkeyが順番通りになる
            // messagesを再構成
            var preMessages = [JSQMessage]()
            for sortedTuple in keyValueArray {
                for (key, value) in posts {
                    if key == sortedTuple.0 {           // 揃えた順番通りにメッセージを作成
                        let senderId = value["senderId"] as! String!
                        let text = value["text"] as! String!
                        let displayName = value["displayName"] as! String!
                        preMessages.append(JSQMessage(senderId: senderId, displayName: displayName, text: text))
                    }
                }
            }
            self.messages = preMessages
            
            self.collectionView.reloadData()
        })
        
    }
    @objc func changeColor(sender: Any) { // buttonの色を変化させるメソッド
        button.backgroundColor = UIColor.darkGray
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    // コメントの背景色の指定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.row].senderId == senderId {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
        }
    }
    
    // コメントの文字色の指定
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        if messages[indexPath.row].senderId == senderId {
            cell.textView.textColor = UIColor.white
        } else {
            cell.textView.textColor = UIColor.darkGray
        }
        return cell
    }
    
    // メッセージの数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // ユーザのアバターの設定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(
            withUserInitials: messages[indexPath.row].senderDisplayName,
            backgroundColor: UIColor.lightGray,
            textColor: UIColor.white,
            font: UIFont.systemFont(ofSize: 10),
            diameter: 30)
    }
    
    //時刻表示のための高さ調整
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.item]
        if indexPath.item == 0 {
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            if message.date.timeIntervalSince(previousMessage.date) / 60 > 1 {
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            }
        }
        return nil
    }
    
    
    // 送信時刻を出すために高さを調整する
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            let message = messages[indexPath.item]
            if message.date .timeIntervalSince(previousMessage.date) / 60 > 1 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0.0
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!){
        //self.dismiss(animated: true, completion: nil)
        
    }
    
}

