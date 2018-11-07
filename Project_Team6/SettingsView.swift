//
//  SettingsView.swift
//  Project_Team6
//
//  Created by Team6 on 10/29/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

class SettingsView: UIViewController {
    
    /* Drop down menu button */
    var button = dropDownBtn()
    
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
            //change username here
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uNameLbl.text = self.settingsUser.currentUsername!
        
        /*
         DROP DOWN MENU CONFIG
         */
        
        button = dropDownBtn.init(frame: CGRect(x: 120, y: 120, width: 120, height: 120))
        button.setTitle("Menu", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        //Add Button to the View Controller
        self.view.addSubview(button)
        
        //button Constraints
        print(self.view.centerXAnchor)
        //button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        // button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Set the drop down menu's options
        button.dropView.dropDownOptions = ["Home", "Score", "Settings"]
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    @IBOutlet weak var creatorLbl: UILabel!
    
    @IBAction func editNameFunc(_ sender: UIButton) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        creatorLbl.text = "Iptihar: Front End \nJulian: Back End / Database \nKrishna: User Interface \nLeo: Question Engine \nRichard: Back End / Front End \nWali: Back End "
        creatorLbl.sizeToFit()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seg6" {
            let passToMenu = segue.destination as! MenuView
            passToMenu.menuUser = settingsUser
        }
        if segue.identifier == "settingsToHome" {
            let passToHome = segue.destination as! ViewController
            passToHome.loggedInUser = settingsUser
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
