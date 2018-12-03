//
//  GameCenterStuff.swift
//  Project_Team6
//
//  Created by Krishna Marepalli on 12/3/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import Foundation
import GameKit
import UIKit

class GameCenterStuff
{
    
    /*
     THIS CLASS WILL HANDLE ALL THE GAMECENTER STUFF INCLUDING AUTHENTIFICATION, WHICH SHOULD BE CALLED EVERYTIME THE APP RETURNS TO FOREFRONT. (VIA OBSERVERS). IF PLAYER FAILS TO AUTHENTICATE SEND TO HOME SCREEN.
     
     SO FAR THIS CLASS IS USELESS!
     */
    
    var gameCenterEnabled: Bool = false
    
    
    
    
    class func enableGameCenter() -> Bool
    {
        return true
    }
    
    init() {
        gameCenterEnabled = GameCenterStuff.enableGameCenter()
        
    }
}
