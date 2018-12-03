//
//  ViewController.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit

protocol audioControlDelegate {
    func setAudioControl(audioControl: AVAudioPlayer)
}

protocol userDelegate {
    func setUser(user: currentUser)
}

protocol problemDelegate {
    func problemInformation(problem: problemInfo)
}

struct problemInfo {
    var problem: String?
    var isCorrect: Bool?
    var userAnswer: String?
    var correctAnswer: String?
    
    init(problem: String, isCorrect: Bool, userAnswer: String, correctAnswer: String) {
        self.problem = problem
        self.isCorrect = isCorrect
        self.userAnswer = userAnswer
        self.correctAnswer = correctAnswer
    }
    init(){
        /* Default Constructor */
    }
}

class PostFOrData {
    let url: String
    let data: String
    init(str: String, post: String) {
        url = str
        data = post
    }
    func forData(completion:  @escaping (String) -> ()) {
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let postString : String = data
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let data = data, let jsonString = String(data: data, encoding: String.Encoding.utf8), error == nil {
                    completion(jsonString)
                } else {
                    print("error=\(error!.localizedDescription)")
                }
            }
            task.resume()
        }
    }
}

struct currentUser: Codable {
    var currentUsername: String?
    var currentUserscore: String?
    var currentUUID: String?
    var currentLVL: String?
    init (){
    }
}

/* For later: Create music control instances in all VC and adjust audiosettings from there*/
struct SharedAudioControl {
    static var sharedAudioPlayer = AVAudioPlayer()
    static var currentlyPlaying = false//sharedAudioPlayer.isPlaying
    static func getSharedAudioPlayer() -> AVAudioPlayer {
        return self.sharedAudioPlayer
    }
}


class ViewController: UIViewController, difficultyLevel, userDelegate, audioControlDelegate{
    var Score = UserDefaults.standard.string(forKey: "currentUserscore")
    /* Create current User */
    var loggedInUser:currentUser = currentUser()
    
    /* Delegate to pass user data */
    var delegate : userDelegate?
    
    
    /* Store all the problem information and User Input to pass to the Settings View */
    var questionInfo = problemInfo()
    var questionInfoArray = [problemInfo]()
    
    
    /* Music Player */
    var audioControl = SharedAudioControl.sharedAudioPlayer
    
    /* Set this ViewController's user to the one passed in (From another ViewController) */
    func setUser(user: currentUser) {
        self.loggedInUser = user
    }
    
    func setAudioControl(audioControl: AVAudioPlayer) {
        self.audioControl = audioControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticatePlayer()
        /* Set the audio player */
        /*do {
            self.audioControl = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "8-bit-sound-adventure", ofType: "mp3")!))

            self.audioControl.prepareToPlay()
            print("TESTING AUDIO IS PLAYING")
            print(self.audioControl.isPlaying)
            if (!self.audioControl.isPlaying && !SharedAudioControl.currentlyPlaying) {
                self.audioControl.numberOfLoops = -1
                self.audioControl.play()
                SharedAudioControl.currentlyPlaying = true
            }
        } catch {
            print(error)
        }*/
        
        // Set background img
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.logoLbl.image = UIImage(named: "logo.jpg")!
        // Do any additional setup after loading the view, typically from a nib.
        let todosEndpoint: String = "http://98.197.90.65:8000/register"
        let uid = UIDevice.current.identifierForVendor?.uuidString
        let newTodo = "uuid=\(String(describing: uid!))"
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData { jsonString in
            let dict = jsonString.toJSON() as? [String:AnyObject]
            print(jsonString)
            print("================================================")
            print(dict!)
            DispatchQueue.main.async {
                guard let uname = dict!["data"] as? [String: Any] else {
                    print("Could not get data as Data from JSON")
                    return
                }
                var name = String(describing: uname["username"]!)
                
                UserDefaults.standard.set(name, forKey: "currentUsername")
                UserDefaults.standard.set("0", forKey: "currentUserscore")
                UserDefaults.standard.set("", forKey: "currentLVL")
                UserDefaults.standard.set(uid, forKey: "currentUUID")
                //UserDefaults.standard.set("0", forKey: "easyScore")
                //UserDefaults.standard.set("0", forKey: "medScore")
                //UserDefaults.standard.set("0", forKey: "highScore")
                
                self.loggedInUser.currentUsername = name
                self.loggedInUser.currentUserscore = "0"
                self.loggedInUser.currentLVL = ""
                self.loggedInUser.currentUUID = uid
                //self.loggedInUser.currentUsername = name
            }
        }
    }
    // Delegate Functions and Variables
    var level:String?
    var lvl: difficultyLevel?
    
    
    
    func setLevel(choice: String){
        // set the different game levels
        level = choice
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //****TODO****
        // Goes to GameView 
        /*if segue.identifier == "seg1" {
            let passRequestedLevel = segue.destination as! GameView
            passRequestedLevel.SetLevel = level!
            lvl?.setLevel(choice: level!)
            
            let passUsertoGame = segue.destination as! GameView
            passUsertoGame.setUser(user: self.loggedInUser)
        }
        
        // Goes to Menu/Scores 
        if segue.identifier == "seg2" {
            // Passing the User's data 
            let passUserInfo = segue.destination as! MenuView
            passUserInfo.setUser(user: self.loggedInUser)
            passUserInfo.setAudioControl(audioControl: self.audioControl)
        }
        if segue.identifier == "seg7" {
            //let passToSettings = segue.destination as! SettingsView
            //passToSettings.settingsUser = loggedInUser
            let passToSettings = segue.destination as! SettingsView
            // We define a delegate variable in the Settings VC. Then, we use the function setUser() to set the SettingsVC user(settingsUser) to the one in the 
            // passToSettings.delegate?.setUser(user: self.loggedInUser)
            passToSettings.setUser(user: self.loggedInUser)
        }*/
    }
    
    // Set logo for menu
    @IBOutlet weak var logoLbl: UIImageView!
    
    // Set and choose different levels
    @IBAction func easyBtn(_ sender: UIButton) {
        //level = "Easy"
        UserDefaults.standard.set("Easy", forKey: "currentLVL")
        performSegue(withIdentifier: "seg1", sender: self)
    }
    @IBAction func medBtn(_ sender: UIButton) {
        //level = "Medium"
        UserDefaults.standard.set("Medium", forKey: "currentLVL")
        performSegue(withIdentifier: "seg1", sender: self)
    }
    @IBAction func hardBtn(_ sender: UIButton) {
        //level = "Hard"
        UserDefaults.standard.set("Hard", forKey: "currentLVL")
        performSegue(withIdentifier: "seg1", sender: self)
    }
    
    // Go to game menu
    @IBAction func menuBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "seg2", sender: self)
    }
    
    @IBAction func settingsWheel(_ sender: UIButton) {
        performSegue(withIdentifier: "seg7", sender: self)
    }
    
    @IBAction func leaderboardButton(_ sender: Any) {
        let GameCenterVC = GKGameCenterViewController()
        GameCenterVC.gameCenterDelegate = self as! GKGameCenterControllerDelegate
        //currentVC?.present(GameCenterVC, animated: true, completion: nil)
        
        self.present(GameCenterVC, animated: true, completion: nil)
        }
    
}

extension ViewController: GKGameCenterControllerDelegate
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

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return (navigation.visibleViewController?.topMostViewController())!
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
    
    
}


extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
