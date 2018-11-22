//
//  SettingsView.swift
//  Project_Team6
//
//  Created by Team6 on 10/29/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

class SettingsView: UIViewController, UITableViewDelegate, UITableViewDataSource, userDelegate {


    var delegate : userDelegate?
    
    func setUser(user: currentUser) {
        self.settingsUser = user
    }
    
    @IBAction func back(_ sender: UIButton) {
        performSegue(withIdentifier: "settingsToHome", sender: self)
    }
    
    var settingsUser = currentUser()
    
    @IBOutlet weak var EditUserText: UIButton!
    @IBOutlet weak var uNameLbl: UILabel!
    @IBOutlet weak var uNameTextField: UITextField!
    @IBAction func EditUser(_ sender: Any) {
        if !uNameLbl.isHidden{
            uNameLbl.isHidden = true
            uNameTextField.placeholder = "New Username"
            EditUserText.setTitle("Done", for: .normal)
            uNameTextField.becomeFirstResponder()
        }
        else{
            uNameLbl.isHidden=false
            EditUserText.setTitle("Edit UserName", for: .normal)
            if(uNameTextField.text != ""){
                ChangeUsername(newName: uNameTextField.text)
                
            }
            uNameTextField.text = ""
            uNameTextField.resignFirstResponder()
        }
    }
    
    @IBAction func SearchUser(_ sender: UIButton) {
        
    }
    
    func SearchUsername(newName: String?){
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
            
            DispatchQueue.main.async {
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
    
    func ChangeUsername(newName: String?){
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
            DispatchQueue.main.async {
                self.uNameLbl.text = self.settingsUser.currentUsername!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    @IBAction func editNameFunc(_ sender: UIButton) {
        
    }
    override func viewDidAppear(_ animated: Bool) {

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    @IBOutlet weak var friendsTable: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
    
    var sectionName = ["Friend Requests", "Friends List"]
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friends", for: indexPath)
        cell.isUserInteractionEnabled = true
        
        let friendsLabel = cell.viewWithTag(5) as! UILabel
        friendsLabel.text = "friend"
        
        
        return cell
    }
    
}
