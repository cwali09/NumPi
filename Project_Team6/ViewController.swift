//
//  ViewController.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func easyBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "seg1", sender: self)
    }
    @IBAction func medBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "seg1", sender: self)
    }
    @IBAction func hardBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "seg1", sender: self)
    }
    
    @IBAction func menuBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "seg2", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

}

