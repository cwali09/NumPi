//
//  MultiplayerGameView.swift
//  Project_Team6
//
//  Created by Team6 on 12/4/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit
import GameKit
import MultipeerConnectivity

class MultiplayerGameView: UIViewController {
    
    @IBOutlet var boxes : [UIButton]!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet weak var answerOutput: UILabel!
    @IBOutlet weak var scrollView: UIImageView!
    let rs = GKMersenneTwisterRandomSource()
    var timerCountdown: Timer!
    var gameComplete = false
    var totalTime = 20
    var questionData = problemInfo()
    var currentProblem: String?
    var currentScore = 0
    var tempScore = 0
    var num1: Int?
    var num2: Int?
    var correctAns: Int?
    var SetLevel: String?
    var match: GKMatch?
    @IBOutlet weak var RightOrWrong: UILabel!
    var currentMatch:GKMatch = StoreMatch.gkMatch
    var enemyScore = 0
    var loggedInUser:currentUser = currentUser()
    var coinPlayer = AVAudioPlayer()
    
    func setUser(user: currentUser) {
        self.loggedInUser = user
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let turnLog = "\(currentScore)"
        let turnData = turnLog.data(using: .utf8)
        sendData(turnLog: turnData!)
        
        print("------------------------")
        print(turnData!)
        print("------------------------")
        
        self.view.addBackground()
        
        if(StoreMatch.gkMatch.players.count != 0){
            playerOneLabel.text = GKLocalPlayer.local.alias
            playerTwoLabel.text = StoreMatch.gkMatch.players[0].alias
        }
        
        if match != nil{
            match!.delegate = self
        }
        
        StoreMatch.gkMatch.delegate = self
        
        let currentDateTime = Date()
        rs.seed =  UInt64(currentDateTime.timeIntervalSinceReferenceDate)
        super.viewDidLoad()
        
        loggedInUser.currentUsername =  UserDefaults.standard.string(forKey: "currentUsername")
        loggedInUser.currentUserscore = UserDefaults.standard.string(forKey: "currentUserscore")
        loggedInUser.currentLVL = UserDefaults.standard.string(forKey: "currentLVL")
        loggedInUser.currentUUID = UserDefaults.standard.string(forKey: "currentUUID")
        
        // Set background img
        scrollView.image = UIImage(named: "scrollProblems.jpg")
        /* Set up the Coin audio player */
        do {
            self.coinPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "correctAnswer", ofType: "mp3")!))
            self.coinPlayer.prepareToPlay()
        } catch {
            print(error)
        }
        
        // Iterate through buttons and change text
        questionInfoArrayGV.removeAll()
        generateProblem()
        startTimer()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.timerLabel.text = "00:20"
        
        super.viewDidLoad()
    }
    
    func sendData(turnLog: Data) {
        do {
            if GKLocalPlayer.local.isAuthenticated {
                try StoreMatch.gkMatch.sendData(toAllPlayers: turnLog, with: .reliable)
                print("SENDING HERE")
            }
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func receiveData(turnLog: Data, player: GKPlayer) {
        let receivedString = NSString(data: turnLog as Data, encoding: String.Encoding.utf8.rawValue)
        let tempString = receivedString! as String
        self.enemyScore = Int(tempString)!
        print(receivedString!)
        print(enemyScore)
        print("RECEIVING HERE")
    }
    
    func generateProblem(){
        SetLevel = UserDefaults.standard.string(forKey: "currentLVL")
        if(self.SetLevel=="Easy"){
            self.answerOutput.text = randomEasyProblem()
            questionData.problem = self.answerOutput.text
            
        }
        else
            if(self.SetLevel=="Medium"){
                self.answerOutput.text = randomMedProblem()
                questionData.problem = self.answerOutput.text
                
            }
            else
                if(self.SetLevel=="Hard"){
                    self.answerOutput.text = randomHardProblem()
                    questionData.problem = self.answerOutput.text
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
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: 12)
        let array = ["+","-","x",]
        self.currentProblem = array[rd.nextInt(upperBound: 3)]
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
        if self.num1! != 0 && self.num1! < self.num2!{
            let temp = self.num1!
            self.num1! = self.num2!
            self.num2! = temp
        }
        self.currentProblem = array[rd.nextInt(upperBound: 4)]
        if self.currentProblem! == "/"{
            self.num1! = self.num1!/self.num2!*self.num2!
            
        }
        return "\(self.num1!) \(self.currentProblem!) \(self.num2!)"
    }

    @IBAction func boxTouched(_ sender: UIButton) {
        let index = boxes.index(of: sender)!
        questionData.correctAnswer = "\(correctAns!)"
        questionData.userAnswer = boxes[index].titleLabel?.text
        if boxes[index].titleLabel?.text=="\(correctAns!)"{
            RightOrWrong.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.RightOrWrong.text = "Correct!"
                self.RightOrWrong.fadeIn()
            })
            
            /* Coin player plays when answer is correct */
            if(!SharedAudioControl.mute){
                self.coinPlayer.play()
            }else{
                self.coinPlayer.pause()
            }
            
            questionData.isCorrect = true
            currentScore += 1
            tempScore += 1
            if tempScore > 3 {
                currentScore += 1
            }
        }
        else{
            RightOrWrong.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.RightOrWrong.text = "Wrong!"
                self.RightOrWrong.fadeIn()
            })
            questionData.isCorrect = false
            tempScore = 0
        }
        
        questionInfoArrayGV.append(questionData)
        
        let turnLog = "\(currentScore)"
        print("SENDING: \(turnLog)")
        let turnData = turnLog.data(using: .utf8)
        sendData(turnLog: turnData!)
        print("------------------------")
        var a:String = String(decoding: turnData!, as: UTF8.self)
        print(a)
        print("------------------------")
        generateProblem()
    }
    
    @objc func startTimer() {
        timerCountdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
            self.view.setNeedsDisplay()
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        timerCountdown.invalidate()
        for box in boxes {
            box.isEnabled = false
        }
        performSegue(withIdentifier: "scoreBoard", sender: self)
        gameComplete = true
        self.removeFromParent()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "scoreBoard") {
            let tmp = segue.destination as! MultiplayerScoringView
            tmp.setPlayerScores(enemyScore: "\(self.enemyScore)", localScore: "\(self.currentScore)")
        }
    }
}

extension MultiplayerGameView: GKMatchDelegate {
    
    // The match received data sent from the player.
    @available(iOS 8.0, *)
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        print ("RECEIVED DATA 8.0")
        receiveData(turnLog: data, player: player)
    }
    
    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        print("RECEIVED DATA 9.0")
        receiveData(turnLog: data, player: player)
    }
    
    // The player state changed (eg. connected or disconnected)
    @available(iOS 4.1, *)
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        
        if match.expectedPlayerCount == 0 {
            print("READY STEADY CAPTAIN!")
            print("Players in Match: \(match.players.count)")
        } else {
            print ("PLAYERS ARE MISSING!")
            print("Players in Match: \(match.players.count)")
        }
    }
    
    
    // The match was unable to be established with any players due to an error.
    @available(iOS 4.1, *)
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        print("FAILED")
    }
    
    
    // This method is called when the match is interrupted; if it returns YES, a new invite will be sent to attempt reconnection. This is supported only for 1v1 games
    @available(iOS 8.0, *)
    func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
        return true
    }
}

