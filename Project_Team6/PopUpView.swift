//
//  PopUpView.swift
//  Project_Team6
//
//  Created by Team6 on 10/22/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

class PopUpView: UIViewController {
    var passobj: GameView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startGame(sender: UIButton) {
    
        self.view.removeFromSuperview()
        performSegue(withIdentifier: "seg4", sender: self)
    }
    
    @IBAction func cancelGame(_ sender: UIButton) {
         performSegue(withIdentifier: "seg3", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "seg4" {
            
        }
    }
}
