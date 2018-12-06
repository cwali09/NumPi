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
    
    var opponentLevel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StoreMatch.gkMatch.delegate = nil
        authenticatePlayer()
        self.view.addBackground()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func easy(_ sender: UIButton) {
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
    
    
    func startTapped() {
        let request = GKMatchRequest()
        request.maxPlayers = 2
        request.minPlayers = 2
        request.inviteMessage = "Lets Play NumPi!"
        if UserDefaults.standard.string(forKey: "currentLVL") == "Easy"{
            request.playerGroup=1
        }
        else if UserDefaults.standard.string(forKey: "currentLVL") == "Medium"{
            request.playerGroup=2
        }
        else{
            request.playerGroup=3
        }
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
        
        self.present(gameScreenVC, animated: true, completion: nil)
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
                print(GKLocalPlayer.local.unregisterAllListeners())
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
