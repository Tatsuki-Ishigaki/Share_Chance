//
//  First2.swift
//  ShareChance
//
//  Created by Hiroyuki Tamae on 2018/02/12.
//  Copyright © 2018年 Univ of the Ryukyu. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewControllerSecond : UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var swipe: UIImageView!
    var image2: UIImage!
    var finger: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        image2 = UIImage(named:"streetpass.png")
        finger = UIImage(named:"swipe.png")
        imageView.image = image2
        swipe.image = finger
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat], animations: {
            self.swipe.center.x -= 100.0
        }, completion: nil)
        _ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.timer), userInfo: nil, repeats: true)
    }
    
    @objc func timer(){
        swipe.layer.removeAllAnimations()
        swipe.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
