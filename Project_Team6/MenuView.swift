//
//  MenuView.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

let uid = UIDevice.current.identifierForVendor?.uuidString

class MenuView: UIViewController {
    // Drop Down Menu Button
    var button = dropDownBtn()
    
    var menuUser = currentUser()
    
    // Value sent through delegate
    var showHighest: String!
    var showRecent: String!
    
    // Logo Labes
    @IBOutlet weak var logoLbl: UIImageView!
    
    // Score Labels
    @IBOutlet weak var recentScore: UILabel!
    @IBOutlet weak var highScore: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(menuUser.currentUsername!)
        // Set background img
        self.recentScore.text = "0"
        self.highScore.text = "0"
        if showRecent == nil {
            showRecent = "0"
        }
        else {
            self.recentScore.text = showRecent
        }
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.logoLbl.image = UIImage(named: "AppIcon.jpg")!
        // Do any additional setup after loading the view.
        
        
        /*
         DROP DOWN MENU CONFIG
        */
        
        button = dropDownBtn.init(frame: CGRect(x: 120, y: 120, width: 120, height: 120))
        button.setTitle("Menu", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        //Add Button to the View Controller
        self.view.addSubview(button)
        
        /* Change below to move left and right */
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        
        /* Change below to move Up and Down */
        button.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Set the drop down menu's options
        button.dropView.dropDownOptions = ["Home", "Score", "Settings"]
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var tempHigh:Int
        var tempRecent: Int
        
        if showHighest == nil {
            if showRecent == nil {
                showHighest = "0"
            }
            else{
                showHighest = showRecent
                
                // NEED TO PASS THIS TO STRUCT OR GLOBAL OR WHATEVER
                self.highScore.text = showHighest
            }
        }
        else {
            tempHigh = Int(showHighest!)!
            tempRecent = Int(showRecent!)!
            if(tempHigh > tempRecent){
                showHighest = showRecent
                
                // NEED TO PASS THIS TO STRUCT OR GLOBAL OR WHATEVER
                self.highScore.text = showHighest
            }
            else {
                
                // NEED TO PASS THIS TO STRUCT OR GLOBAL OR WHATEVER
                self.highScore.text = self.highScore.text
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsToHome" {
            let passToView = segue.destination as! ViewController
            passToView.loggedInUser = menuUser
        }
        if segue.identifier == "seg5" {
            let passToSettings = segue.destination as! SettingsView
            passToSettings.settingsUser = menuUser
        }
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
