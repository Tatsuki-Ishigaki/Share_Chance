//
//  FirstViewController.swift
//  ShareChance
//
//  Created by 石垣達樹 on 2017/11/30.
//  Copyright © 2017年 ishitatsu. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var information: Results<Information>!
    var realm: Realm!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50 //見積もり高さ
        tableView.rowHeight = UITableViewAutomaticDimension //自動設定
        
        do{
            let realm = try Realm()
            information = realm.objects(Information.self)
            
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
        label2.text = information[indexPath.row].id
        
        
        
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
    
}
