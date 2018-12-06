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
    @IBAction func menu(_ sender: UIButton) {
        performSegue(withIdentifier: "home", sender: self)
    }
    // Game Seed
    let rs = GKMersenneTwisterRandomSource()
    
    /* Store all the problem information and User Input to pass to the Settings View */
    var questionInfo = problemInfo()
    
//    var button = dropDownBtn()
    
    // Delegate Variables
    var score: scoreBoard?
    
    //var lvl: difficultyLevel?
    var SetLevel: String?
    var SetScore: String?
    
    // Drop-down Menu Button
    //var button = dropDownBtn()
    
    //    var gameUser = currentUser()
    
    @IBOutlet weak var scrollView: UIImageView!
    
    var loggedInUser:currentUser = currentUser()
    
    func setUser(user: currentUser) {
        self.loggedInUser = user
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "menuSeg" {
            let passToMenu = segue.destination as! MenuView
            
            //pass level and score
            passToMenu.passedScore = "\(currentScore)"
            passToMenu.passedLevel = SetLevel!
            dump(self)
            
            
            
            //passToMenu.showRecent = "0"
            score?.setScore(currentScore: "0")
            SetScore = "\(currentScore)"
            showRecent = SetScore!
            score?.setScore(currentScore: SetScore!)

            passToMenu.recentGame = true
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
    
    
    /* Audio for the coin sound (correct answer) */
    var coinPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        let currentDateTime = Date()
        currentDateTime.timeIntervalSinceReferenceDate
        self.view.addBackground()

        rs.seed =  UInt64(currentDateTime.timeIntervalSinceReferenceDate)
        print(currentDateTime.timeIntervalSinceReferenceDate)
        print("RS.SEED IS: ")
        print(rs.seed)
        super.viewDidLoad()
        
        loggedInUser.currentUsername =  UserDefaults.standard.string(forKey: "currentUsername")
        loggedInUser.currentUserscore = UserDefaults.standard.string(forKey: "currentUserscore")
        loggedInUser.currentLVL = UserDefaults.standard.string(forKey: "currentLVL")
        loggedInUser.currentUUID = UserDefaults.standard.string(forKey: "currentUUID")
        
        
        // Set background img
        scrollView.image = UIImage(named: "scrollProblems.jpg")
        
        // Iterate through buttons and change text
        questionInfoArrayGV.removeAll()
        generateProblem()
        startTimer()
        print("USERNAME IS: ")
        print(loggedInUser.currentUsername!)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var currentProblem: String?
    var num1: Int?
    var num2: Int?
    var correctAns: Int?
    
    func generateProblem(){
        SetLevel = UserDefaults.standard.string(forKey: "currentLVL")
        print("USERDEFAULT:" + SetLevel!)
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
        self.currentProblem = array[rd.nextInt()%2]
        return "\(self.num1!) \(self.currentProblem!) \(self.num2!)"
    }
    func randomMedProblem()->String{
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: 12)
        let array = ["+","-","x",]
        self.currentProblem=array.randomElement()!
        if self.currentProblem! != "x"{
            self.num1 = rd.nextInt(upperBound: 12) * 10 // 10*Int.random(in: 0...12)
        }
        else{
            self.num1 = rd.nextInt(upperBound: 12) * 10 // Int.random(in: 0...12)
        }
        //num2 cannot be 0 because may cause a divide by 0
        self.num2 = rd.nextInt(upperBound: 12) * 10 //Int.random(in: 0...12)
        return "\(self.num1!) \(self.currentProblem!) \(self.num2!)"
    }
    func randomHardProblem()->String{
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: 25)
        let array = ["+","-","x","/"]
        self.num1 = 10 * rd.nextInt(upperBound: 25)
        //num2 cannot be 0 because may cause a divide by 0
        self.num2 = 10 * rd.nextInt(upperBound: 25)
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
    var currentScore = 0
    var tempScore = 0
    @IBAction func boxTouched(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        let index = boxes.index(of: sender)!
        questionInfo.correctAnswer = "\(correctAns!)"
        questionInfo.userAnswer = boxes[index].titleLabel?.text
        if boxes[index].titleLabel?.text=="\(correctAns!)"{
            answerOutput.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.answerOutput.text = "Correct!"
                self.answerOutput.fadeIn()
            })
            //answerOutput.text = "Correct!"
            print("correct answer chosen")
            questionInfo.isCorrect = true
            currentScore += 1
            tempScore += 1
            if tempScore > 3 {
                currentScore += 1
            }
        }
        else{
            answerOutput.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.answerOutput.text = "Wrong!"
                self.answerOutput.fadeIn()
                self.tempScore = 0
            })
            //answerOutput.text = "Wrong!"
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
    
    var gameComplete = false
    
    func endTimer() {
        countdownTimer.invalidate()
        performSegue(withIdentifier: "menuSeg", sender: self)
        gameComplete = true
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.timerLbl.text = "00:20"
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
}
