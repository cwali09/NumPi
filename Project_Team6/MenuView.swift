//
//  MenuView.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

let uid = UIDevice.current.identifierForVendor?.uuidString

struct QuestionLog {
    var Question: String?
    var Answer: String?
    var PossibleAnswers: [String]?
    
    init(){
    }
}

class MenuView: UIViewController {
    
    let uid = UIDevice.current.identifierForVendor?.uuidString
    var level: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    // Drop Down Menu Button
    var button = dropDownBtn()
    var Questions = QuestionLog()
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
        
        /*tableView.beginUpdates()
    
        
        
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        tableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        tableView.insertRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
        tableView.insertRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
        
        tableView.endUpdates()*/
        
        //let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        //let lbl = cell?.viewWithTag(1) as! UILabel
        //lbl.text = "hello"
        
        print(menuUser.currentUsername!)
        // Set background img
        self.recentScore.text = "0"
        self.highScore.text = ""
        if showRecent == nil {
            showRecent = ""
        }
        else {
            self.recentScore.text = showRecent
        }
        
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
    
    /*override func viewDidAppear(_ animated: Bool) {
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
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        var tempHigh:Int
        var tempRecent: Int
        print("_____________\n")
        print(self.menuUser)
        print("\n_______________")
        
        //self.menuUser.currentUserscore = "0"
        
        let todosEndpoint: String = "http://98.197.90.65:8000/highscore"
        let newTodo = "type=score&&uuid=\(String(describing: uid!))&&level=Easy"
        print("dddd")
        print(newTodo)
        print("TODOTODOTODOTODOTODOTODOTODO")
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
                    //do nothing
                }
                else {
                    self.menuUser.currentUserscore = "\(uname[0]["score"]!)"
                    print(self.menuUser.currentUserscore!)
                    print("eeee")
                    self.showHighest = "\(uname[0]["score"]!)"
                    print(self.showHighest!)
                    self.highScore.text = "\(self.menuUser.currentUserscore!)"
                }
                
            }
        }
        
        if showHighest == nil {
            if showRecent == nil {
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
