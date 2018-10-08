//
//  GameView.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

protocol difficultyLevel {
    func setLevel()
}

class GameView: UIViewController {

    @IBAction func menuBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "gameback", sender: self)
    }
    @IBOutlet weak var btn1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setLevel(){
        // set the different game levels
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
