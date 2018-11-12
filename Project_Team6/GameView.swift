//
//  GameView.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit
import GameKit

// Scoreboard Protocol used to set score on MenuView
// Sender GameView -> MenuView
protocol scoreBoard {
    func setScore(currentScore: String)
}

// Difficulty Protocol used to set level on GameView
// Sender ViewController -> GameView
protocol difficultyLevel {
    func setLevel(choice: String)
}

class GameView: UIViewController, userDelegate {
    // Game Seed
    let rs = GKMersenneTwisterRandomSource()
    
    /* Store all the problem information and User Input to pass to the Settings View */
    var questionInfo = problemInfo()
    
    // Delegate Variables
    var score: scoreBoard?
    
    //var lvl: difficultyLevel?
    var SetLevel: String?
    var SetScore: String?
    
    // Drop-down Menu Button
    var button = dropDownBtn()
    
    var gameUser = currentUser()
    
    @IBOutlet weak var scrollView: UIImageView!
    
    var loggedInUser:currentUser = currentUser()
    
    func setUser(user: currentUser) {
        self.loggedInUser = user
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "menuSeg" {
            let passToMenu = segue.destination as! MenuView
            //passToMenu.showRecent = "0"
            score?.setScore(currentScore: "0")
            SetScore = "\(pointSystem)"
            showRecent = SetScore!
            score?.setScore(currentScore: SetScore!)
            passToMenu.setUser(user: self.loggedInUser)
            passToMenu.level = SetLevel
        }
        if segue.identifier == "home" {
            let passToView = segue.destination as! ViewController
            passToView.setUser(user: self.loggedInUser)

        }
        if segue.identifier == "gameToSettings" {
            let passToSettings = segue.destination as! SettingsView
            passToSettings.setUser(user: self.loggedInUser)

        }
    }
    
    // Answser buttons -- Link these buttons to some sort of random variables
    // correct answer will need to be set in stone
    // Each button stored in boxes, Access by Index 1 - 6
    @IBOutlet var boxes : [UIButton]!
    
    // Show problems
    @IBOutlet weak var problemScreen: UILabel!
    
    // Show timer
    @IBOutlet weak var timerLbl: UILabel!
    
    override func viewDidLoad() {
        let currentDateTime = Date()
        //currentDateTime.timeIntervalSinceReferenceDate
        rs.seed =  UInt64(currentDateTime.timeIntervalSinceReferenceDate)
        super.viewDidLoad()
        // Set background img
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        scrollView.image = UIImage(named: "scrollProblems.jpg")
        // Iterate through buttons and change text
        questionInfoArrayGV.removeAll()
        generateProblem()
        startTimer()
        
        /*
         DROP DOWN MENU CONFIG
         */
        
        button = dropDownBtn.init(frame: CGRect(x: 120, y: 120, width: 120, height: 120))
        button.setTitle("Menu", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        //Add Button to the View Controller
        self.view.addSubview(button)
        
        //button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        /* This is to modify the left and right aspects of the button */
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        
        /* This is to modify the UP and DOWN aspects of the button */
        button.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        // button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Set the drop down menu's options
        button.dropView.dropDownOptions = ["Home", "Score", "Settings"]
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var currentProblem: String?
    var num1: Int?
    var num2: Int?
    var correctAns: Int?
    
    func generateProblem(){
        
        if(self.SetLevel=="Easy"){
            self.problemScreen.text=randomEasyProblem()
            questionInfo.problem = self.problemScreen.text
            
        }
        else
            if(self.SetLevel=="Medium"){
                self.problemScreen.text=randomMedProblem()
                questionInfo.problem = self.problemScreen.text
                
            }
            else
                if(self.SetLevel=="Hard"){
                    self.problemScreen.text=randomHardProblem()
                    questionInfo.problem = self.problemScreen.text
        }
        // Iterate through buttons and change text
        var answerChoice: Int?;
        if(currentProblem=="+"){
            answerChoice=num1!+num2!
            correctAns=num1!+num2!
        }
        else if(currentProblem=="-"){
            answerChoice=num1!-num2!
            correctAns=num1!-num2!
        }
        else if(currentProblem=="x"){
            answerChoice=num1!*num2!
            correctAns=num1!*num2!
        }
        else{
            answerChoice=num1!/num2!
            correctAns=answerChoice!
        }
        if self.SetLevel=="Hard"{
            answerChoice!-=30
        }
        else{
            answerChoice!-=3
        }
        boxes.shuffle()
        boxes.forEach {
            $0.setTitle("\(answerChoice!)", for: .normal)
            //for now this changes the rest of the answers
            if self.SetLevel == "Hard"{
                answerChoice!+=10
            }
            else{
                answerChoice!+=1
            }
        }
    }
    @IBOutlet weak var answerOutput: UILabel!
    
    //function to make an easy problem with numbers between 0 to 20
    //function to make an easy problem with numbers between 0 to 20
    func randomEasyProblem()->String{
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: 12)
        let array = ["+","-"]
        //self.num1 = Int.random(in: 0...12)
        self.num1 = rd.nextInt()
        //num2 cannot be 0 because may cause a divide by 0
        //self.num2 = Int.random(in: 0...12)
        self.num2 = rd.nextInt()
        //self.currentProblem=array.randomElement()!
        self.currentProblem = array[rd.nextInt()%2]
        return "\(self.num1!) \(self.currentProblem!) \(self.num2!)"
    }
    func randomMedProblem()->String{
        let array = ["+","-","x",]
        self.currentProblem=array.randomElement()!
        if self.currentProblem! != "x"{
            self.num1 = 10*Int.random(in: 0...12)
        }
        else{
            self.num1 = Int.random(in: 0...12)
        }
        //num2 cannot be 0 because may cause a divide by 0
        self.num2 = Int.random(in: 0...12)
        return "\(self.num1!) \(self.currentProblem!) \(self.num2!)"
    }
    func randomHardProblem()->String{
        let array = ["+","-","x","/"]
        self.num1 = (10*Int.random(in: 0...100))
        //num2 cannot be 0 because may cause a divide by 0
        self.num2 = (10*Int.random(in: 1...10))
        //print(self.num2!)
        if self.num1! != 0 && self.num1! < self.num2!{
            let temp = self.num1!
            self.num1! = self.num2!
            self.num2! = temp
        }
        self.currentProblem=array.randomElement()!
        if self.currentProblem! == "/"{
            self.num1! = self.num1!/self.num2!*self.num2!
            
        }
        return "\(self.num1!) \(self.currentProblem!) \(self.num2!)"
    }
    var pointSystem = 0
    @IBAction func boxTouched(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        let index = boxes.index(of: sender)!
        //print(boxes[index].titleLabel!)
        questionInfo.correctAnswer = "\(correctAns!)"
        questionInfo.userAnswer = boxes[index].titleLabel?.text
        if boxes[index].titleLabel?.text=="\(correctAns!)"{
            answerOutput.text = "Correct!"
            print("correct answer chosen")
            questionInfo.isCorrect = true
            pointSystem += 1
        }
        else{
            answerOutput.text = "Wrong!"
            print("Wrong Answer!")
            questionInfo.isCorrect = false
        }
        /* Push questionInfo object to array to pass into MenuView */
        questionInfoArrayGV.append(questionInfo)
        generateProblem()
    }
    
 
    
    var countdownTimer: Timer!
    var totalTime = 20
    
    @objc func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLbl.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        performSegue(withIdentifier: "menuSeg", sender: self)
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.problemScreen.text = SetLevel!
        self.timerLbl.text = "00:20"
        
        
        /*let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpStart") as! PopUpView
         self.addChild(popOverVC)
         popOverVC.view.frame = self.view.frame
         self.view.addSubview(popOverVC.view)
         popOverVC.didMove(toParent: self)*/
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Set up the URL request
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

