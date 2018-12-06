//
//  ViewController.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation


class ViewController: UIViewController, difficultyLevel, userDelegate, audioControlDelegate {
    
    var level:String?
    var lvl: difficultyLevel?
    var loggedInUser:currentUser = currentUser()
    var delegate : userDelegate?
    var questionInfo = problemInfo()
    var questionInfoArray = [problemInfo]()
    var audioControl = SharedAudioControl.sharedAudioPlayer
    let muteimg = UIImage(named: "muteddoublenode.png")
    let musicimg = UIImage(named: "musicdoublenode.png")
    @IBOutlet weak var musicButtonImg: UIButton!
    @IBOutlet weak var logoLbl: UIImageView!
    
    func setLevel(choice: String){
        // set the different game levels
        level = choice
    }
    
    func setUser(user: currentUser) {
        self.loggedInUser = user
    }
    
    func setAudioControl(audioControl: AVAudioPlayer) {
        self.audioControl = audioControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground()

        if(!SharedAudioControl.mute){
            musicButtonImg.setImage(musicimg, for: UIControl.State.normal)
            SharedAudioControl.get().play()
            SharedAudioControl.currentlyPlaying = true
        }
        else{

            musicButtonImg.setImage(muteimg, for: UIControl.State.normal)
            SharedAudioControl.get().stop()
            SharedAudioControl.currentlyPlaying = false
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.logoLbl.image = UIImage(named: "logo.jpg")!
        // Do any additional setup after loading the view, typically from a nib.
        let todosEndpoint: String = "http://98.197.90.65:8000/register"
        let uid = UIDevice.current.identifierForVendor?.uuidString
        let newTodo = "uuid=\(String(describing: uid!))"
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData { jsonString in
            let dict = jsonString.toJSON() as? [String:AnyObject]
            DispatchQueue.main.async {
                guard let uname = dict!["data"] as? [String: Any] else {
                    print("Could not get data as Data from JSON")
                    return
                }
                let name = String(describing: uname["username"]!)
                
                UserDefaults.standard.set(name, forKey: "currentUsername")
                UserDefaults.standard.set("0", forKey: "currentUserscore")
                UserDefaults.standard.set("", forKey: "currentLVL")
                UserDefaults.standard.set(uid, forKey: "currentUUID")
                self.loggedInUser.currentUsername = name
                self.loggedInUser.currentUserscore = "0"
                self.loggedInUser.currentLVL = ""
                self.loggedInUser.currentUUID = uid
            }
        }
    }
    
    @IBAction func muteButton(_ sender: UIButton) {
        SharedAudioControl.mute = !SharedAudioControl.mute
        UserDefaults.standard.set(SharedAudioControl.mute, forKey: "mute")
        if(!SharedAudioControl.mute){
            musicButtonImg.setImage(musicimg, for: UIControl.State.normal)
            SharedAudioControl.get().play()
            SharedAudioControl.currentlyPlaying = true
        }
        else{
            
            musicButtonImg.setImage(muteimg, for: UIControl.State.normal)
            SharedAudioControl.get().stop()
            SharedAudioControl.currentlyPlaying = false
        }
    }
  
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

extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "background.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}
