//
//  MenuView.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

class MenuView: UIViewController {
    
    // Value sent through delegate
    var showHighest: String!
    var showRecent: String!
    
    // Logo Labes
    @IBOutlet weak var logoLbl: UIImageView!
    
    // Score Labels
    @IBOutlet weak var recentScore: UILabel!
    @IBOutlet weak var highScore: UILabel!
    
    // Menu button
    @IBAction func menuBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "menuBack", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set background img
        self.recentScore.text = "0"//showRecent UNCOMMENT
        self.highScore.text = "0" 
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //var tempHigh:Int
        //var tempRecent: Int
        //tempHigh = 0 //Int(showHighest!)! UNCOMMENT
        //tempRecent = 0 //Int(showRecent!)! UNCOMMENT
        //if(tempHigh < tempRecent){
        //    showHighest = showRecent
        //}
        //showHighest UNCOMMENT
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
