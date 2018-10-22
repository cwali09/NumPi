//
//  ViewController.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

class ViewController: UIViewController, difficultyLevel {
    
    // Delegate Functions and Variables
    var level:String?
    var lvl: difficultyLevel?
    
    func setLevel(choice: String){
        // set the different game levels
        level = choice
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seg1" {
            let passRequestedLevel = segue.destination as! GameView
            passRequestedLevel.SetLevel = level!
            lvl?.setLevel(choice: level!)
        }
    }
    
    // Set logo for menu
    @IBOutlet weak var logoLbl: UIImageView!
    
    // Set and choose different levels
    @IBAction func easyBtn(_ sender: UIButton) {
        level = "Easy"
        performSegue(withIdentifier: "seg1", sender: self)
    }
    @IBAction func medBtn(_ sender: UIButton) {
        level = "Medium"
        performSegue(withIdentifier: "seg1", sender: self)
    }
    @IBAction func hardBtn(_ sender: UIButton) {
        level = "Hard"
        performSegue(withIdentifier: "seg1", sender: self)
    }
    
    // Go to game menu
    @IBAction func menuBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "seg2", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set background img
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.logoLbl.image = UIImage(named: "logo.jpg")!
        // Do any additional setup after loading the view, typically from a nib.
    }
    

}

