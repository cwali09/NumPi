//
//  SettingsView.swift
//  Project_Team6
//
//  Created by Team6 on 10/29/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

//****TODO****
//need art for accept/reject buttons
//green checkmark and red x? Doesnt fit the theme though

class friendButton: UIButton
{
    var ID: String?
    var wasTapped: Bool = false
    var otherBtn: friendButton? //the other button
    
    //init(ID: String)
    init()
    {
        //self.ID = ID
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


class SettingsView: UIViewController, UITableViewDelegate, UITableViewDataSource, userDelegate
{

    var requests:[[String:Any]]?
    var friends:[String]?
    var delegate : userDelegate?
    
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
            if(uNameTextField.text != "")
            {
                ChangeUsername(newName: uNameTextField.text)
                
            }
            uNameTextField.text = ""
            uNameTextField.resignFirstResponder()
        }
    }
    
    @IBAction func SearchUser(_ sender: UIButton)
    {
        
    }
    
    func SearchUsername(newName: String?)
    {
        print(newName!)
        self.settingsUser.currentUsername = newName!
        
        let todosEndpoint: String = "http://98.197.90.65:8000/changeUsername"
        let newTodo = "uuid=\(String(describing: uid!))&&username=\(self.settingsUser.currentUsername!)"
        print("search user name")
        print(newTodo)
        print("after search user")
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData { jsonString in
            //let dict = jsonString.toJSON() as? [String:AnyObject]
            print(jsonString)
            print("================================================")
            //print(dict["data"]!)
            
            DispatchQueue.main.async
                {
                //guard let uname = dict!["data"] as? [String: String] else {
                //   print("Could not get data as Data from JSON")
                //    return
                //}
                //                print("=-=-==-=-=-=-==-")
                //                print(uname)
                //                print("=-=-==-=-=-=-==2323232323-")
                self.uNameLbl.text = self.settingsUser.currentUsername!
            }
        }
    }
    
    func ChangeUsername(newName: String?)
    {
        print(newName!)
        self.settingsUser.currentUsername = newName!
        
        let todosEndpoint: String = "http://98.197.90.65:8000/changeUsername"
        let newTodo = "uuid=\(String(describing: uid!))&&username=\(self.settingsUser.currentUsername!)"
        print("dfdfd")
        print(newTodo)
        print("TODOTODOTODOTODOTODOTODOTODO343")
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData { jsonString in
            print(jsonString)
            print("================================================")
            DispatchQueue.main.async
            {
                self.uNameLbl.text = self.settingsUser.currentUsername!
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        header.text = sectionName[section]
        header.frame = CGRect(x: 115, y: 8, width: 200, height: 35)
        //header.textAlignment = .center
        header.textColor = UIColor.white
        header.font = UIFont(name: "K2D Medium", size: 18)
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let image = UIImageView(image: UIImage(named: "plank"))
        image.frame = CGRect(x: 0, y: 0, width: 350, height: 50)
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
        dump(indexPath)
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
            friendsLabel.text = self.friends![indexPath.row]
        }
        
        
        
        
        
        //****TODO****
        // for some reason this is triggering when section is 1
        if (indexPath.section == 0)
        {
            let ac = cell.viewWithTag(6) as! friendButton
            ac.addTarget(self, action: #selector(tapAccept), for: .touchUpInside)
            let rej = cell.viewWithTag(7) as! friendButton
            rej.addTarget(self, action: #selector(tapReject), for: .touchUpInside)
            
            dump(indexPath)
            ac.ID = self.requests![indexPath.row]["id"] as! String
            rej.ID = self.requests![indexPath.row]["id"] as! String
            
            ac.isHidden = false
            rej.isHidden = false
            
            ac.otherBtn = rej //this allows us to ensure only one button is tapped, reducing error rates
            rej.otherBtn = ac
        }
        
        
        
        //button.addTarget(self, action:"action_button", forControlEvents:.TouchUpInside)

        
        
        return cell
    }
    
    
    
    @objc func tapReject(sender: friendButton!)
    {
        //dump(sender)
        //print("A")
        if (!sender.wasTapped)
        {
            //print("B")
            
            if (sender.otherBtn == nil)
            {
                return //other button was nil, not defined properly exit the function
            }
            if ((sender.otherBtn?.wasTapped)!)
            {
                sender.wasTapped = true //set this one to tapped as well
                return //other button was tapped, exit the function
            }
            //print("D")
            if (sender.otherBtn != nil)
            {
                //print("E")
                sender.otherBtn?.wasTapped = true //set both buttons to tapped state
            }
            //print("F")
            sender.wasTapped = true
            print("reject tapped")
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
            //print("B")
            
            if (sender.otherBtn == nil)
            {
                return //other button was nil, not defined properly exit the function
            }
            if ((sender.otherBtn?.wasTapped)!)
            {
                sender.wasTapped = true //set this one to tapped as well
                return //other button was tapped, exit the function
            }
            //print("D")
            if (sender.otherBtn != nil)
            {
                //print("E")
                sender.otherBtn?.wasTapped = true //set both buttons to tapped state
            }
            //print("F")
            sender.wasTapped = true
            print("accept tapped")
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
        print("doing reject")
        let todosEndpoint: String = "http://98.197.90.65:8000/rejectFriend"
        let newTodo = "id=\(id)"
        
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData
            { jsonString in
            print("posted")
                DispatchQueue.main.async {
                    print("done")
                    self.getFriends()
                }
        }
    }
    
    func doAccept(id: String)
    {
        print("doing accept")
        let todosEndpoint: String = "http://98.197.90.65:8000/acceptFriend"
        let newTodo = "id=\(id)"
        
        let pfd = PostFOrData(str: todosEndpoint, post: newTodo)
        pfd.forData
            { jsonString in
                print("posted")
                DispatchQueue.main.async {
                    print("done")
                    self.getFriends()
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
            //print(jsonString)
            //print("================================================")
            //print(dict!["data"])
            
            DispatchQueue.main.async {
                print("------dict------")
                dump(dict)
                print("---------------------")
                guard let data = dict!["data"] as? [[String: Any?]] else {
                    print("Could not get data as Data from JSON") //this will also call when friends are empty
                    return
                }
                
                print("------data------")
                dump(data)
                print("---------------------")
                
                
                guard let friends = data[0]["friends"] as? [String] else {
                    print("Could not get data as frirends from data")
                    return
                }
                
                self.friends = friends
                
                print("------friends------")
                dump(friends)
                print("---------------------")
                
                
                guard let requests = data[0]["requests"] as? [[String:Any]] else {
                    print("Could not get requests from data")
                    return
                }
                
                self.requests = requests
                self.friendsTable.reloadData()
                
                print("------requests------")
                dump(requests)
                print("---------------------")
                
                
                
                
                
                //scoreLabel.text = "\(uname[0]["score"]!)"
                
                /*print("------uname------")
                 dump(uname[0]["score"]!)
                 print("---------------------")*/
                
                
                //****TODO****
                self.view.setNeedsDisplay() //this doesnt work, maybe it's just my simulator. We need to fix this
                
            }
        }
    }
    
}
