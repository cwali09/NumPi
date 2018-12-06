//
//  FriendsView.swift
//  Project_Team6
//
//  Created by Team6 on 11/20/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

class FriendsView: UIViewController {
    
    @IBOutlet weak var uname: UILabel!
    @IBOutlet weak var easy: UILabel!
    @IBOutlet weak var medium: UILabel!
    @IBOutlet weak var hard: UILabel!
    
    var uname1 = String()
    var easy1 = String()
    var medium1 = String()
    var hard1 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addBackground()
        
        uname.text = uname1
        easy.text = easy1
        medium.text = medium1
        hard.text = hard1
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}
