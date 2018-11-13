//
//  MenuView.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit
import AVFoundation

let uid = UIDevice.current.identifierForVendor?.uuidString

struct QuestionLog {
    var Question: String?
    var Answer: String?
    var PossibleAnswers: [String]?
    
    init(){
    }
}

/* Store all the values all questions */
var questionInfoArrayGV = [problemInfo]()
var showRecent: String!

class MenuView: UIViewController, UITableViewDelegate, UITableViewDataSource, userDelegate, audioControlDelegate {
    
    
    let uid = UIDevice.current.identifierForVendor?.uuidString
    var level: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // Drop Down Menu Button
    var button = dropDownBtn()
    var Questions = QuestionLog()
    var menuUser = currentUser()
    
    // Value sent through delegate
    var showHighest: String!
   
    
    // Logo Labes
    @IBOutlet weak var logoLbl: UIImageView!
    
    // Score Labels
    @IBOutlet weak var recentScore: UILabel!
    @IBOutlet weak var highScore: UILabel!
    
    /* Audio Control */
    var audioControl = SharedAudioControl.sharedAudioPlayer

    func setAudioControl(audioControl: AVAudioPlayer) {
        self.audioControl = audioControl
    }
    
    func setUser(user: currentUser) {
        self.menuUser = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        print(menuUser.currentUsername!)
        // Set background img
        self.recentScore.text = "0"
        self.highScore.text = ""
        if showRecent == nil {
            showRecent = ""
        }
        else {
            self.recentScore.text = showRecent //this line turns self.recentScore.text to "" for some reason
            if (self.recentScore.text == "") {
                self.recentScore.text = "0"
            }
        }
        //self.recentScore.text = showRecent
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.logoLbl.image = UIImage(named: "sqrtLogo.png")!
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
        print("_____________\n")
        print(self.menuUser)
        print("\n_______________")
        
        
        let todosEndpoint: String = "http://98.197.90.65:8000/highscore"
        let newTodo = "type=score&&uuid=\(String(describing: uid!))&&level=Easy"

        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData { jsonString in
            let dict = jsonString.toJSON() as? [String:AnyObject]
            print(jsonString)
            print("================================================")
            print(dict!["data"])
            
            DispatchQueue.main.async {
                guard let uname = dict!["data"] as? [[String: Any]] else {
                    print("Could not get data as Data from JSON")
                    return
                }
                print("=-=-==-=-=-=-==-")
                print(uname)
                print("=-=-==-=-=-=-==2323232323-")
                //var score = String(describing: uname["username"]!)
                if uname.isEmpty {
                    self.highScore.text = "0"
                }
                else {
                    if(self.menuUser.currentUserscore == ""){
                         self.highScore.text = "0"
                    }
                    else{
                        self.menuUser.currentUserscore = "\(uname[0]["score"]!)"
                        print(self.menuUser.currentUserscore!)
                    }
                    print("eeee")
                    self.showHighest = "\(uname[0]["score"]!)"
                    print(self.showHighest!)
                    self.highScore.text = "\(self.menuUser.currentUserscore!)"
                }
                
            }
        }
        
        if showHighest == nil {
            if showRecent == nil {
                showRecent = "0"
                showHighest = "0"
            }
            else{
                showHighest = showRecent
                if (level != nil && showRecent != nil){
                    // NEED TO PASS THIS TO STRUCT OR GLOBAL OR WHATEVER
                    let todosEndpoint: String = "http://98.197.90.65:8000/addHighscore"
                    let newTodo = "score=\(showRecent!)&&uuid=\(String(describing: uid!))&&level=\(level!)"
                    let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
                    pfd.forData { jsonString in
                        let dict = jsonString.toJSON() as? [String:AnyObject]
                        print(jsonString)
                        print("================================================")
                        print(dict!)
                        DispatchQueue.main.async {
                            guard let uname = dict!["debug"] as? [String: String] else {
                                print("Could not get data as Data from JSON")
                                return
                            }
                            self.highScore.text = "\(self.menuUser.currentUserscore!)"
                            print(uname)
                        }
                    }
                }
                
                //elf.highScore.text = "\(self.menuUser.currentUserscore!)"
                
            }
        }
        else {
            tempHigh = Int("\(self.menuUser.currentUserscore!)")!
            tempRecent = Int(showRecent!)!
            if(tempHigh > tempRecent){
                showHighest = showRecent
                
                self.highScore.text = "\(self.menuUser.currentUserscore!)"//showHighest
            }
            else {
                
                self.highScore.text = "\(self.menuUser.currentUserscore!)"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsToHome" {
            let passToView = segue.destination as! ViewController
            passToView.setUser(user: self.menuUser)
            passToView.setAudioControl(audioControl: self.audioControl)
//            passToView.loggedInUser = menuUser
        }
        if segue.identifier == "seg5" {
            let passToSettings = segue.destination as! SettingsView
            passToSettings.setUser(user: self.menuUser)
//            passToSettings.settingsUser = menuUser
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionInfoArrayGV.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.isUserInteractionEnabled = false
        
        /* Set cell properties */
        let lblProblem = cell.viewWithTag(1) as! UILabel
        let lblCorrectAnswer = cell.viewWithTag(2) as! UILabel
        let lblUserAnswer = cell.viewWithTag(3) as! UILabel
        
        lblProblem.text = questionInfoArrayGV[indexPath.row].problem
        lblCorrectAnswer.text = questionInfoArrayGV[indexPath.row].correctAnswer
        lblUserAnswer.text = questionInfoArrayGV[indexPath.row].userAnswer
        
        if (questionInfoArrayGV[indexPath.row].isCorrect!) {
            cell.backgroundColor = UIColor(red: 0.18, green: 0.8, blue: 0.44, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 0.96, green: 0.2, blue: 0.2, alpha: 1.0)
        }
        
        return cell
    }
}
