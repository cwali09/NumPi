//
//  MultiplayerScoringView.swift
//  Project_Team6
//
//  Created by Team6 on 12/5/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit
import GameKit
import ImageIO

protocol PassScore {
    func setPlayerScores(enemyScore: String, localScore: String)
}

class MultiplayerScoringView: UIViewController, PassScore {
    
    @IBOutlet weak var playerOne: UILabel!
    @IBOutlet weak var playerTwo: UILabel!
    var enemyScore = "0"
    var userScore = "0"
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var enemyLabel: UILabel!
    @IBOutlet weak var winnerWinnerChickenDinner: UILabel!
    @IBOutlet weak var loserImage: UIImageView!
    @IBOutlet weak var winnerImage: UIImageView!
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backMultiplayer", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playerOne.text = GKLocalPlayer.local.alias
        playerTwo.text = StoreMatch.gkMatch.players[0].alias
        userLabel.text = "Score: " + self.userScore
        enemyLabel.text = "Score: " + self.enemyScore
        print("END OF GAME")
        print(userScore)
        print(enemyScore)
        if(Int(enemyScore)! > Int(userScore)!){
            winnerWinnerChickenDinner.text = "\(playerTwo.text!) is the Winner!"
            loserImage.image = UIImage(named: "loser.png")
        }
        else if (Int(userScore)! > Int(enemyScore)!){
            winnerWinnerChickenDinner.text = "\(playerOne.text!) is the Winner!"
            winnerImage.image = UIImage(named: "winner.png")
        }
        else {
            winnerWinnerChickenDinner.text = "Its a Tie!"
            winnerImage.image = UIImage(named: "tie.jpeg")
        }
    }
    
    func setPlayerScores(enemyScore: String, localScore: String) {
        self.enemyScore = enemyScore
        self.userScore = localScore
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backMultiplayer" {
            userScore = "0"
            enemyScore = "0"
        }
    }
}
