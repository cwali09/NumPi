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
    
    var recentGame = false
    
    var passedScore: String?
    var passedLevel: String?
    
    let uid = UIDevice.current.identifierForVendor?.uuidString
    var level: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func back(_ sender: UIButton) {
        performSegue(withIdentifier: "scoreBack", sender: self)
    }
    
    // Drop Down Menu Button
    // var button = dropDownBtn()
    var Questions = QuestionLog()
    var menuUser = currentUser()
    
    // Value sent through delegate
    var showHighest: String!
   
    
    // Logo Labes
    @IBOutlet weak var recentScore: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var easyScore: UILabel!
    @IBOutlet weak var medScore: UILabel!
    @IBOutlet weak var hardScore: UILabel!
    
    /* Audio Control */
    var audioControl = SharedAudioControl.sharedAudioPlayer

    func setAudioControl(audioControl: AVAudioPlayer) {
        self.audioControl = audioControl
    }
    
    func setUser(user: currentUser) {
        self.menuUser = user
    }
    @IBOutlet weak var playAgain: UIButton!
    @IBAction func playAgainBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "playAgainSeg", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuUser.currentUsername =  UserDefaults.standard.string(forKey: "currentUsername")
        menuUser.currentUserscore = UserDefaults.standard.string(forKey: "currentUserscore")
        menuUser.currentLVL = UserDefaults.standard.string(forKey: "currentLVL")
        menuUser.currentUUID = UserDefaults.standard.string(forKey: "currentUUID")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        print(menuUser.currentUsername!)
        
        // Set background img
        self.recentScore.text = "0"
        self.highScore.text = ""
        self.easyScore.text = "0"
        self.medScore.text = "0"
        self.hardScore.text = "0"
        
        if showRecent == nil {
            showRecent = ""
        }
        else {
            self.recentScore.text = showRecent
            if (self.recentScore.text == "") {
                self.recentScore.text = "0"
            }
        }
 
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if(recentGame == false){
            self.playAgain.isHidden = true
        }
        else if (recentGame == true){
            self.playAgain.isHidden = false
        }
        
        if (passedScore != nil && passedLevel != nil)
        {
            doAddHighscore(score: passedScore!, level: passedLevel!)
        }
        
        //****TODO****
        let hardcodedlevelforscore = "Easy" //This is used for when we visit the score screen directly, we need to figure out how to handle this
        
        if (passedLevel != nil)
        {
            getHighscore(level: passedLevel!, scoreLabel: self.highScore)
        }
        else
        {
            getHighscore(level: hardcodedlevelforscore, scoreLabel: self.highScore)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsToHome" {
            
        }
        if segue.identifier == "seg5" {

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
    
    func getHighscore(level: String, scoreLabel: UILabel)
    {
        scoreLabel.text = "Loading"
        let todosEndpoint: String = "http://98.197.90.65:8000/highscore"
        let newTodo = "type=score&&uuid=\(String(describing: uid!))&&level=\(level)&&limit=1"
        
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData { jsonString in
            let dict = jsonString.toJSON() as? [String:AnyObject]
            DispatchQueue.main.async {
                guard let uname = dict!["data"] as? [[String: Any]] else {
                    print("Could not get data as Data from JSON")
                    return
                }
                scoreLabel.text = "\(uname[0]["score"]!)"
                
                self.view.setNeedsDisplay()
            }
        }
    }
    
    
    func doAddHighscore(score: String, level: String)
    {
        let todosEndpoint: String = "http://98.197.90.65:8000/addHighscore"
        let newTodo = "score=\(score)&&uuid=\(String(describing: uid!))&&level=\(level)"
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData
            { jsonString in
            let dict = jsonString.toJSON() as? [String:AnyObject]
            DispatchQueue.main.async
            {
                guard (dict!["debug"] as? [String: String]) != nil else
                {
                    print("Could not get data as Data from JSON")
                    return
                }
            }
        }
    }
}
