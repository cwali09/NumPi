//
//  ViewController.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

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

class ViewController: UIViewController, difficultyLevel, userDelegate {
    
    /* Create current User */
    var loggedInUser:currentUser = currentUser()
    
    /* Delegate to pass user data */
    var delegate : userDelegate?
    
    
    /* Store all the problem information and User Input to pass to the Settings View */
    var questionInfo = problemInfo()
    var questionInfoArray = [problemInfo]()
    
    
    /* Set this ViewController's user to the one passed in (From another ViewController) */
    func setUser(user: currentUser) {
        self.loggedInUser = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
