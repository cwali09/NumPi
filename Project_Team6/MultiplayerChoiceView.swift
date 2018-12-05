//
//  MultiplayerChoiceView.swift
//  Project_Team6
//
//  Created by Team6 on 12/4/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit
import GameKit
import MultipeerConnectivity

struct StoreMatch {
    static var gkMatch = GKMatch()
}

class MultiplayerChoiceView: UIViewController {
    
    @IBAction func easy(_ sender: UIButton) {
        //level = "Easy"
        UserDefaults.standard.set("Easy", forKey: "currentLVL")
        startTapped()
    }
    
    @IBAction func medium(_ sender: UIButton) {
        UserDefaults.standard.set("Medium", forKey: "currentLVL")
        startTapped()
    }
    
    @IBAction func hard(_ sender: UIButton) {
        UserDefaults.standard.set("Hard", forKey: "currentLVL")
        startTapped()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "MultiplayerGame" {
//            let passToMultiplayer = segue.destination as! MultiplayerGameView
//            if (currentMatch == nil)
//            {
//                print("CURRENT MATCH IS NIL!")
//            }
//            passToMultiplayer.match = currentMatch
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticatePlayer()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    func startTapped() {
        let request = GKMatchRequest()
        request.maxPlayers = 2
        request.minPlayers = 2
        request.inviteMessage = "Lets Play NumPi!"
        request.playerGroup = 1
        
        let mmvc = GKMatchmakerViewController(matchRequest: request)
        mmvc?.matchmakerDelegate = self
        present(mmvc!, animated: true, completion: nil)
    }

    func goToGame(match: GKMatch) {
        let gameScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "mainGame") as! MultiplayerGameView
        gameScreenVC.providesPresentationContextTransitionStyle = true
        gameScreenVC.definesPresentationContext = true
        gameScreenVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        gameScreenVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        StoreMatch.gkMatch = match
        
        print("PRINTING MATCH PLAYERS")
        print("I am: ")
        print(GKLocalPlayer.local.alias)
        print("Opponent is: ")
        print(StoreMatch.gkMatch.players[0].alias)
        print(StoreMatch.gkMatch.players.count)
        self.present(gameScreenVC, animated: true, completion: nil)
    }
}


extension MultiplayerChoiceView: GKGameCenterControllerDelegate
{
    
    func authenticatePlayer()
    {
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil
            {
                self.present(view!, animated: true, completion: nil)
            } else {
                print("AUTHENTICATED!")
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

extension MultiplayerChoiceView: GKMatchmakerViewControllerDelegate {
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        print("match was cancelled")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("didFailwithError: \(error.localizedDescription)")
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        print("Match found")
        if match.expectedPlayerCount == 0 {
            viewController.dismiss(animated: true, completion: {self.goToGame(match: match)})
            performSegue(withIdentifier: "MultiplayerGame", sender: self)
        }
    }
}
