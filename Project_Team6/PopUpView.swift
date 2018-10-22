//
//  PopUpView.swift
//  Project_Team6
//
//  Created by Team6 on 10/22/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

class PopUpView: UIViewController, protoStartTimer {
    var setTrue = false
    var timer: protoStartTimer?
   
    func start(timeBool: Bool) {
        setTrue = timeBool
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startGame(sender: UIButton) {
        setTrue = true
        timer?.start(timeBool: setTrue)
        self.view.removeFromSuperview()
        //performSegue(withIdentifier: "seg4", sender: self)
    }
    
    
    
    @IBAction func cancelGame(_ sender: UIButton) {
         performSegue(withIdentifier: "seg3", sender: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
