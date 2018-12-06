//
//  MultiplayerScoringView.swift
//  Project_Team6
//
//  Created by Team6 on 12/5/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit
import GameKit

class MultiplayerScoringView: UIViewController {
    @IBOutlet weak var playerOne: UILabel!
    @IBOutlet weak var playerTwo: UILabel!
    var enemyScore = "0"
    var userScore = "0"
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var enemyLabel: UILabel!
    @IBOutlet weak var winnerWinnerChickenDinner: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()

        playerOne.text = GKLocalPlayer.local.alias
        playerTwo.text = StoreMatch.gkMatch.players[0].alias
        userLabel.text = "Score: " + userScore
        enemyLabel.text = "Score: " + enemyScore
        
        if(Int(enemyScore)! > Int(userScore)!){
           winnerWinnerChickenDinner.text = "\(playerTwo.text!) is the Winner!"
        }
        else if (Int(userScore)! > Int(enemyScore)!){
            winnerWinnerChickenDinner.text = "\(playerOne.text!) is the Winner!"
        }
        else {
            winnerWinnerChickenDinner.text = "Its a Tie!"
        }
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
