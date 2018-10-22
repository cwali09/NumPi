//
//  GameView.swift
//  Project_Team6
//
//  Created by Team6 on 10/8/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import UIKit

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

protocol protoStartTimer {
    func start(timeBool: Bool)
}

class GameView: UIViewController {
    
    // Delegate Variables
    var score: scoreBoard?
    //var lvl: difficultyLevel?
    var setTrue = false
    var SetLevel: String?
    var SetScore: String?

    // Menu button -- Will need to change when drop down menu
        //  is updated
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "seg2" {
            let passScore = segue.destination as! MenuView
            passScore.showRecent = "0"
            score?.setScore(currentScore: "0")
            //passScore.showRecent = SetScore!  UNCOMMENT
            //score?.setScore(currentScore: SetScore!) UNCOMMENT
        }
    }
    
    // Temporary Home button till drop down is complete
        // Delete this function / connection after fixing menu
    @IBAction func tempHomeBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "home", sender: self)
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
        super.viewDidLoad()
        // Set background img
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        // Iterate through buttons and change text
        generateProblem()
        // Do any additional setup after loading the view.
        
    }
    
    var currentProblem: String?
    var num1: Int?
    var num2: Int?
    var correctAns: Int?
    func generateProblem(){
        if(self.SetLevel=="Easy"){
            self.problemScreen.text=randomEasyProblem()
        }
        else
            if(self.SetLevel=="Medium"){
                self.problemScreen.text=randomMedProblem()
            }
            else
                if(self.SetLevel=="Hard"){
                    self.problemScreen.text=randomHardProblem()
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
        boxes.shuffle()
        boxes.forEach {
            $0.setTitle("\(answerChoice!)", for: .normal)
            //for now this changes the rest of the answers
            answerChoice!+=1
        }
    }
    
    //function to make an easy problem with numbers between 0 to 20
    func randomEasyProblem()->String{
        let array = ["+","-","x"]
        self.num1 = Int.random(in: 0...20)
        //num2 cannot be 0 because may cause a divide by 0
        self.num2 = Int.random(in: 1...20)
        self.currentProblem=array.randomElement()!
        return "\(self.num1!) \(self.currentProblem!) \(self.num2!)"
    }
    func randomMedProblem()->String{
        let array = ["+","-","x",]
        self.num1 = Int.random(in: 50...100)
        
        //num2 cannot be 0 because may cause a divide by 0
        self.num2 = Int.random(in: 1...50)
        self.currentProblem=array.randomElement()!
        return "\(self.num1!) \(self.currentProblem!) \(self.num2!)"
    }
    func randomHardProblem()->String{
        let array = ["+","-","x"]
        self.num1 = Int.random(in: 100...1000)
        //num2 cannot be 0 because may cause a divide by 0
        self.num2 = Int.random(in: 100...1000)
        self.currentProblem=array.randomElement()!
        return "\(self.num1!) \(self.currentProblem!) \(self.num2!)"
    }
    var pointSystem = 0
    @IBAction func boxTouched(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        let index = boxes.index(of: sender)!
        //print(boxes[index].titleLabel!)
        if boxes[index].titleLabel?.text=="\(correctAns!)"{
            print("correct answer chosen")
            generateProblem()
            pointSystem += 1
        }
        else{
            print("Wrong Answer!")
            generateProblem()
        }
    }
    
     /*@IBAction func boxTouched(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = boxes.index(of: sender)!
        switch index {
        }
        default:
        <#code#>
    }*/
    
    var countdownTimer: Timer!
    var totalTime = 10
    
    func startTimer() {
       // while (setTrue == false){
            countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
      //  }
        
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
        performSegue(withIdentifier: "gameback", sender: self)
       
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.problemScreen.text = SetLevel!
        self.timerLbl.text = "01:00"
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpStart") as! PopUpView
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Set up the URL request
        let todosEndpoint: String = "http://98.197.90.65:8000/users"
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.httpMethod = "POST"
        let uid = UIDevice.current.identifierForVendor?.uuidString
        let newTodo = "username=swift&password=swift1234&score=50&uid=\(String(describing: uid!))"
        todosUrlRequest.httpBody = newTodo.data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The response is: " + receivedTodo.description)
                
                guard let todoID = receivedTodo["status"] as? Int else {
                    print("Could not get status as int from JSON")
                    return
                }
                print("The status is: \(todoID)")
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        
        startTimer()
        task.resume()
    }
}
