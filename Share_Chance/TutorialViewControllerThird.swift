//
//  First3.swift
//  ShareChance
//
//  Created by Hiroyuki Tamae on 2018/02/12.
//  Copyright © 2018年 Univ of the Ryukyu. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewControllerThird : UIViewController {
    @IBOutlet var CloseButton: UIButton!
    @IBOutlet var AlwaysCloseButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var image3: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        image3 = UIImage(named:"human.png")
        imageView.image = image3
    }
    @IBAction func Close(sender : AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController()
        present(nextView!, animated: true, completion: nil)
    }
    @IBAction func AlwaysClose(sender : AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userDefaults.set(false, forKey: "DataStore")
        appDelegate.userDefaults.synchronize()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController()
        present(nextView!, animated: true, completion: nil)
    }
}
