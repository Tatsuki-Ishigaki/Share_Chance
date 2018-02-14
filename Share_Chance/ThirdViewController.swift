
import UIKit
import RealmSwift

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var item: Results<Item>!
    var realm: Realm!
    
    var itemTitle: String?
    var itemCategory: String?
    var itemLike: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func goBack2(_ segue:UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50 //見積もり高さ
        tableView.rowHeight = UITableViewAutomaticDimension //自動設定
        
        do{
            let realm = try Realm()
            item = realm.objects(Item.self).sorted(byKeyPath: "like")

        }catch{
    
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        super.viewWillAppear(animated)
        if let selectedRaw = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRaw, animated: true)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        let label1 = cell.viewWithTag(1) as! UILabel
        label1.text = item[indexPath.row].title
        
        let label2 = cell.viewWithTag(2) as! UILabel
        label2.text = item[indexPath.row].category
        
        let label3 = cell.viewWithTag(3) as! UILabel
        label3.text = item[indexPath.row].like
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete) {
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.item[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }catch{
            }
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemTitle = item[indexPath.item].title
        itemCategory = item[indexPath.item].category
        itemLike = item[indexPath.item].like
        
        if itemTitle != nil {
            
            performSegue(withIdentifier: "Third_2",sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "Third_2") {
            let nav = segue.destination as! UINavigationController
            let Third_2VC1 = nav.topViewController as! ThirdView_2Controller
            let Third_2VC2 = nav.topViewController as! ThirdView_2Controller
            let Third_2VC3 = nav.topViewController as! ThirdView_2Controller
            
            Third_2VC1.itemTitle = itemTitle
            Third_2VC2.itemCategory = itemCategory
            Third_2VC3.itemLike = itemLike
        }
    }

}
