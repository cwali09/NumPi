//
//  SettingsView.swift
//  Project_Team6
//
//  Created by Team6 on 10/29/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

class friendButton: UIButton
{
    var ID: String?
    var wasTapped: Bool = false
    var otherBtn: friendButton? //the other button
    
    init()
    {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


class SettingsView: UIViewController, UITableViewDelegate, UITableViewDataSource, userDelegate
{

    var requests:[[String:Any]]?
    var friends:[[String:Any]]?
    var delegate : userDelegate?
    
    var uname2 = String()
    var easy2 = String()
    var medium2 = String()
    var hard2 = String()
    
    
    func setUser(user: currentUser)
    {
        self.settingsUser = user
    }
    
    @IBAction func back(_ sender: UIButton)
    {
        performSegue(withIdentifier: "settingsToHome", sender: self)
    }
    
    var settingsUser = currentUser()
    
    @IBOutlet weak var EditUserText: UIButton!
    @IBOutlet weak var uNameLbl: UILabel!
    @IBOutlet weak var uNameTextField: UITextField!
    @IBAction func EditUser(_ sender: Any)
    {
        if !uNameLbl.isHidden
        {
            uNameLbl.isHidden = true
            uNameTextField.placeholder = "New Username"
            EditUserText.setTitle("Done", for: .normal)
            uNameTextField.becomeFirstResponder()
        }
        else
        {
            uNameLbl.isHidden=false
            EditUserText.setTitle("Edit UserName", for: .normal)
            if(uNameTextField.text != "" && uNameTextField.text!.isAlphanumeric)
            {
                ChangeUsername(newName: uNameTextField.text)
                
            } else {
                showToast(message : "No symbols!")
            }
            uNameTextField.text = ""
            uNameTextField.resignFirstResponder()
        }
    }
    
    

    @IBOutlet weak var addFriend: UITextField!
    @IBAction func SearchUser(_ sender: UIButton)
    {
        if(addFriend.text != "")
        {
            addFriend(friendName: addFriend.text)
        }
        else {
            showToast(message : "Cannot be Empty!")
        }
        addFriend.text  = ""

        
    }
    
    func addFriend(friendName: String?)
    {
        let todosEndpoint: String = "http://98.197.90.65:8000/addFriend"
        let newTodo = "uuid=\(String(describing: uid!))&&username=\(friendName!)"
        
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData
            { jsonString in
                DispatchQueue.main.async {
                    let dict = jsonString.toJSON() as? [String:AnyObject]
                    guard let rep = dict!["msg"] as? String else {
                        print("Could not get msg from addFriend response")
                        return
                    }
                    self.showToast(message : rep)
            }
        }
    }
    
    func ChangeUsername(newName: String?)
    {
        self.settingsUser.currentUsername = newName!
        
        let todosEndpoint: String = "http://98.197.90.65:8000/changeUsername"
        let newTodo = "uuid=\(String(describing: uid!))&&username=\(self.settingsUser.currentUsername!)"

        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData { jsonString in
            DispatchQueue.main.async
            {
                self.uNameLbl.text = self.settingsUser.currentUsername!
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.addBackground()
        getFriends()
        
        friendsTable.dataSource = self
        friendsTable.delegate = self
        
        settingsUser.currentUsername =  UserDefaults.standard.string(forKey: "currentUsername")
        settingsUser.currentUserscore = UserDefaults.standard.string(forKey: "currentUserscore")
        settingsUser.currentLVL = UserDefaults.standard.string(forKey: "currentLVL")
        settingsUser.currentUUID = UserDefaults.standard.string(forKey: "currentUUID")

        uNameLbl.text = self.settingsUser.currentUsername!

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    @IBAction func editNameFunc(_ sender: UIButton)
    {
        
    }
    override func viewDidAppear(_ animated: Bool)
    {

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "friendDetail" {
            let dvc = segue.destination as! FriendsView
            dvc.uname1 = uname2
            dvc.easy1 = easy2
            dvc.medium1 = medium2
            dvc.hard1 = hard2
        }
       
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    @IBOutlet weak var friendsTable: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sectionName.count
    }
    
    var sectionName = ["Friend Requests", "Friends List"]
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (section == 0 && self.requests?.count == 0)
        {
            return 0 //if empty section, no header
        }
        if (section == 1 && self.friends?.count == 0)
        {
            return 0//if empty section, no header
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if (section == 0 && self.requests?.count == 0)
        {
            return nil //if empty section, no header
        }
        if (section == 1 && self.friends?.count == 0)
        {
            return nil//if empty section, no header
        }
        let header = UILabel()
        let sectionWidth = (tableView.frame.width / 2) - 50
        header.text = sectionName[section]
        header.frame = CGRect(x: sectionWidth, y: 8, width: 200, height: 35)
        //header.textAlignment = .center
        header.textColor = UIColor.white
        header.font = UIFont(name: "K2D Medium", size: 18)
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let image = UIImageView(image: UIImage(named: "plank"))
        let tWidth = tableView.frame.width
        image.frame = CGRect(x: 0, y: 0, width: tWidth, height: 50)
        view.addSubview(image)
        view.addSubview(header)
        
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 0)
        {
            if (requests == nil)
            {
                return 0
            }
            else
            {
                return requests!.count
            }
        }
        else
        {
            if (friends == nil)
            {
                return 0
            }
            else
            {
                return friends!.count
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friends", for: indexPath)
        cell.isUserInteractionEnabled = true
        
        let friendsLabel = cell.viewWithTag(5) as! UILabel
        friendsLabel.text = "friend"
        if(indexPath.section == 0)
        {
            friendsLabel.text = (self.requests![indexPath.row]["username"] as! String)
        }
        if(indexPath.section == 1)
        {
            friendsLabel.text = (self.friends![indexPath.row]["username"] as! String)
        }

        let ac = cell.viewWithTag(6) as! friendButton
        let rej = cell.viewWithTag(7) as! friendButton
        
        if (indexPath.section == 0)
        {
            
            ac.addTarget(self, action: #selector(tapAccept), for: .touchUpInside)
            
            let acWidth = ac.frame.width
            let acHeight = ac.frame.height
            let acBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: acWidth, height: acHeight))
            acBackground.image = UIImage(named: "accept.jpg")
            acBackground.contentMode = UIView.ContentMode.scaleAspectFill
            ac.addSubview(acBackground)
            ac.sendSubviewToBack(acBackground)
            
            rej.addTarget(self, action: #selector(tapReject), for: .touchUpInside)
            let rejWidth = rej.frame.width
            let rejHeight = rej.frame.height
            let rejBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: rejWidth, height: rejHeight))
            rejBackground.image = UIImage(named: "reject.jpg")
            rejBackground.contentMode = UIView.ContentMode.scaleAspectFill
            rej.addSubview(rejBackground)
            rej.sendSubviewToBack(rejBackground)
            
            ac.ID = (self.requests![indexPath.row]["id"] as! String)
            rej.ID = (self.requests![indexPath.row]["id"] as! String)
            
            ac.isHidden = false
            rej.isHidden = false
            
            ac.otherBtn = rej //this allows us to ensure only one button is tapped, reducing error rates
            rej.otherBtn = ac
        }
        else
        {
            rej.ID = (self.friends![indexPath.row]["id"] as! String)
            ac.isHidden = true
            rej.isHidden = false
            
            rej.addTarget(self, action: #selector(tapReject), for: .touchUpInside)
            let rejWidth = rej.frame.width
            let rejHeight = rej.frame.height
            let rejBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: rejWidth, height: rejHeight))
            rejBackground.image = UIImage(named: "trashcan.jpg")
            rejBackground.contentMode = UIView.ContentMode.scaleAspectFill
            rej.addSubview(rejBackground)
            rej.sendSubviewToBack(rejBackground)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1)
        {
            uname2 = self.friends![indexPath.row]["username"] as! String
            getOneFriend(uname: self.friends![indexPath.row]["username"] as! String)
        }
    }
    
    @objc func tapReject(sender: friendButton!)
    {
        if (!sender.wasTapped)
        {
            if (sender.otherBtn != nil)
            {
                if ((sender.otherBtn?.wasTapped)!)
                {
                    sender.wasTapped = true //set this one to tapped as well
                    return //other button was tapped, exit the function
                }
                //return //other button was nil, not defined properly exit the function
            }
            
            if (sender.otherBtn != nil)
            {
                sender.otherBtn?.wasTapped = true //set both buttons to tapped state
            }
            sender.wasTapped = true
            if (sender.ID != nil)
            {
                doReject(id: sender.ID!)
            }
            else
            {
                print("id was nil")
            }
        }
    }
    
    @objc func tapAccept(sender: friendButton!)
    {
        if (!sender.wasTapped)
        {
            if (sender.otherBtn == nil)
            {
                return //other button was nil, not defined properly exit the function
            }
            if ((sender.otherBtn?.wasTapped)!)
            {
                sender.wasTapped = true //set this one to tapped as well
                return //other button was tapped, exit the function
            }
            if (sender.otherBtn != nil)
            {
                sender.otherBtn?.wasTapped = true //set both buttons to tapped state
            }
            sender.wasTapped = true
            if (sender.ID != nil)
            {
                doAccept(id: sender.ID!)
            }
            else
            {
                print("id was nil")
            }
        }
    }
    
    func doReject(id: String)
    {
        let todosEndpoint: String = "http://98.197.90.65:8000/rejectFriend"
        let newTodo = "id=\(id)"
        
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData
            { jsonString in
                DispatchQueue.main.async {
                    self.getFriends()
                }
        }
    }
    
    func doAccept(id: String)
    {
        let todosEndpoint: String = "http://98.197.90.65:8000/acceptFriend"
        let newTodo = "id=\(id)"
        
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData
            { jsonString in
                DispatchQueue.main.async {
                    self.getFriends()
            }
        }
    }
    
    func getOneFriend(uname: String)
    {
        let todosEndpoint: String = "http://98.197.90.65:8000/getTopScore"
        let newTodo = "username=\(uname)"
        
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData
            { jsonString in
                DispatchQueue.main.async {
                    let dict = jsonString.toJSON() as? [String:AnyObject]
                    guard let data = dict!["data"] as? [[String:AnyObject]] else {
                        print("Could not get individual detail")
                        return
                    }
                    
                    if(data[0]["easyCount"] as? Int == 1){
                        guard let easy = data[0]["easy"]!["score"]!! as? Int else {
                            print("could not get easy score")
                            return
                        }
                        self.easy2 = String(easy)
                    }
                    else {
                        self.easy2 = "0"
                    }
                    
                    if(data[0]["mediumCount"] as? Int == 1){
                        guard let medium = data[0]["medium"]!["score"]!! as? Int else {
                            print("could not get medium score")
                            return
                        }
                        self.medium2 = String(medium)
                    }
                    else {
                        self.medium2 = "0"
                    }
                    
                    if(data[0]["hardCount"] as? Int == 1){
                        guard let hard = data[0]["hard"]!["score"]!! as? Int else {
                            print("could not get easy score")
                            return
                        }
                        self.hard2 = String(hard)
                    }
                    else {
                        self.hard2 = "0"
                    }
                    self.performSegue(withIdentifier: "friendDetail", sender: self)
                }
        }
    }
    
    func getFriends()
    {
        let todosEndpoint: String = "http://98.197.90.65:8000/getFriends"
        let newTodo = "uuid=\(String(describing: uid!))"
        
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData { jsonString in
            let dict = jsonString.toJSON() as? [String:AnyObject]
            
            DispatchQueue.main.async {
                guard let data = dict!["data"] as? [[String: Any?]] else {
                    print("Could not get data as Data from JSON") //this will also call when friends are empty
                    return
                }
                
                guard let friends = data[0]["friends"] as? [[String: Any]] else {
                    print("Could not get friends as Data from JSON") //this will also call when friends are empty
                    return
                }
                
                self.friends = friends
                
                guard let requests = data[0]["requests"] as? [[String:Any]] else {
                    print("Could not get requests from data")
                    return
                }
                
                self.requests = requests
                self.friendsTable.reloadData()
                
                self.view.setNeedsDisplay()
            }
        }
    }
    
}

extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }


extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
