//
//  ViewController.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

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
    /*init(userName: String, userScore: String, currentUUID: String, currentLVL: String) {
        self.currentUsername = userName
        self.currentUserscore = userScore
        self.currentUUID = currentUUID
        self.currentLVL = currentLVL
    }*/
}

class ViewController: UIViewController, difficultyLevel {
    
    /* Create current User */
    var loggedInUser = currentUser()
    
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
    
    @IBAction func settingsBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "seg7", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /* Goes to GameView */
        if segue.identifier == "seg1" {
            let passRequestedLevel = segue.destination as! GameView
            passRequestedLevel.SetLevel = level!
            lvl?.setLevel(choice: level!)
            let passUsertoGame = segue.destination as! GameView
            passUsertoGame.gameUser = loggedInUser
        }
        
        /* Goes to Menu/Scores */
        if segue.identifier == "seg2" {
            /* Passing the User's data */
            let passUserInfo = segue.destination as! MenuView
            passUserInfo.menuUser = loggedInUser
        }
        if segue.identifier == "seg7" {
            let passToSettings = segue.destination as! SettingsView
            passToSettings.settingsUser = loggedInUser
        }
    }
    
    // Set logo for menu
    @IBOutlet weak var logoLbl: UIImageView!
    
    // Set and choose different levels
    @IBAction func easyBtn(_ sender: UIButton) {
        level = "Easy"
        performSegue(withIdentifier: "seg1", sender: self)
    }
    @IBAction func medBtn(_ sender: UIButton) {
        level = "Medium"
        performSegue(withIdentifier: "seg1", sender: self)
    }
    @IBAction func hardBtn(_ sender: UIButton) {
        level = "Hard"
        performSegue(withIdentifier: "seg1", sender: self)
    }
    
    // Go to game menu
    @IBAction func menuBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "seg2", sender: self)
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


extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}


//
// DROP DOWN MENU
//
/* Define dropDownView class to hold all dropDown*/

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.darkGray
        self.backgroundColor = UIColor.darkGray
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(title: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

protocol dropDownProtocol {
    func dropDownPressed(title : String)
}

class dropDownBtn: UIButton, dropDownProtocol {

    
    func dropDownPressed(title: String) {
        if (title == "Home") {
            if let a = UIApplication.shared.topMostViewController() as? MenuView {
                UIApplication.shared.topMostViewController()?.performSegue(withIdentifier: "menuBack", sender: self)
            }
            if let a = UIApplication.shared.topMostViewController() as? GameView {
                UIApplication.shared.topMostViewController()?.performSegue(withIdentifier: "home", sender: self)
                print("We're in the Game View")
            }
            
            if let a = UIApplication.shared.topMostViewController() as? SettingsView {
                UIApplication.shared.topMostViewController()?.performSegue(withIdentifier: "settingsToHome", sender: self)
            }
        }
        
        if (title == "Score") {
            if let a = UIApplication.shared.topMostViewController() as? MenuView {
                print("We're in the Scores View")
            }
            if let a = UIApplication.shared.topMostViewController() as? GameView {
                UIApplication.shared.topMostViewController()?.performSegue(withIdentifier: "menuSeg", sender: self)
            }
            if let a = UIApplication.shared.topMostViewController() as? SettingsView {
                UIApplication.shared.topMostViewController()?.performSegue(withIdentifier: "seg6", sender: self)
            }
        }
        
        if (title == "Settings") {
            if let a = UIApplication.shared.topMostViewController() as? MenuView {
                UIApplication.shared.topMostViewController()?.performSegue(withIdentifier: "seg5", sender: self)
            }
            
            if let a = UIApplication.shared.topMostViewController() as? GameView {
                UIApplication.shared.topMostViewController()?.performSegue(withIdentifier: "gameToSettings", sender: self)
            }
            
            if let a = UIApplication.shared.topMostViewController() as? SettingsView {
                print("We're in the Settings View")
            }
        }
    }
    var dropView = dropDownView()
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkGray
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        // Reset the dropviews constraints
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
