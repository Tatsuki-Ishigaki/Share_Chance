
import UIKit
import RealmSwift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var information: Results<Information>!
    var id: Results<Id>!
    var My_inf: Results<My_Information>!
    
    var realm: Realm!
    
    var my_name: String?
    var you_name: String?
    var my_id: String?
    var you_id: String?
    var mix_id: String?
    var my_pr: String?
    var flag: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func goSegue3(segue: UIStoryboardSegue) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50 //見積もり高さ
        tableView.rowHeight = UITableViewAutomaticDimension //自動設定
        
        do{
            let realm = try Realm()
            information = realm.objects(Information.self).sorted(byKeyPath: "id")
            id = realm.objects(Id.self)
            My_inf = realm.objects(My_Information.self)
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
        return information.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as UITableViewCell
        
        let label1 = cell.viewWithTag(1) as! UILabel
        label1.text = information[indexPath.row].name
        
        let label2 = cell.viewWithTag(2) as! UILabel
        label2.text = information[indexPath.row].mach
        
        
        
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
                    realm.delete(self.information[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }catch{
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        my_name = My_inf[0].name
        you_name = information[indexPath.item].name
        my_id  = id[0].my_id
        you_id = information[indexPath.item].you_id
        mix_id = information[indexPath.item].id
        my_pr = My_inf[0].pr
        flag = information[indexPath.item].flag
        

        performSegue(withIdentifier: "First_2",sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "First_2") {
//            let nav = segue.destination as! UINavigationController
            
//            let First_2VC1 = nav.topViewController as! FirstView_2Controller
//            let First_2VC2 = nav.topViewController as! FirstView_2Controller
//            let First_2VC3 = nav.topViewController as! FirstView_2Controller
//            let First_2VC4 = nav.topViewController as! FirstView_2Controller
//            let First_2VC5 = nav.topViewController as! FirstView_2Controller
//            let First_2VC6 = nav.topViewController as! FirstView_2Controller
//            let First_2VC7 = nav.topViewController as! FirstView_2Controller
//
//
//            First_2VC1.my_name = my_name
//            First_2VC2.you_name = you_name
//            First_2VC3.my_id = my_id
//            First_2VC4.you_id = you_id
//            First_2VC5.mix_id = mix_id
//            First_2VC6.my_pr = my_pr
//            First_2VC7.flag = flag
            
            
        }
    }
    
}
