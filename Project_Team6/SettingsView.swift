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
    @IBOutlet weak var uNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uNameLbl.text = settingsUser.currentUsername!
        
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
        creatorLbl.text = "Julian: ________ \nKrishna: ________ \nLeo: ________ \nRichard: ________ \nWali: ________ "
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

}
