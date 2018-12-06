//
//  MiscShared.swift
//  Project_Team6
//
//  Created by Team6 on 12/5/18.
//  Copyright © 2018 Team6. All rights reserved.
//

import Foundation
import AVFoundation

protocol audioControlDelegate {
    func setAudioControl(audioControl: AVAudioPlayer)
}

protocol userDelegate {
    func setUser(user: currentUser)
}

protocol problemDelegate {
    func problemInformation(problem: problemInfo)
}

struct QuestionLog {
    var Question: String?
    var Answer: String?
    var PossibleAnswers: [String]?
    
    init(){
    }
}

struct problemInfo {
    var problem: String?
    var isCorrect: Bool?
    var userAnswer: String?
    var correctAnswer: String?
    
    init(problem: String, isCorrect: Bool, userAnswer: String, correctAnswer: String) {
        self.problem = problem
        self.isCorrect = isCorrect
        self.userAnswer = userAnswer
        self.correctAnswer = correctAnswer
    }
    init(){
        /* Default Constructor */
    }
}

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
    var mute: Bool?
    init (){
    }
}

/* For later: Create music control instances in all VC and adjust audiosettings from there*/
struct SharedAudioControl {
    static var mute: Bool = false
    static var sharedAudioPlayer: AVAudioPlayer?
    //static var sharedAudioPlayer: AVAudioPlayer?
    static var currentlyPlaying = false//sharedAudioPlayer.isPlaying
    /*static func getSharedAudioPlayer() -> AVAudioPlayer {
     return self.sharedAudioPlayer
     }*/
    static func get() -> AVAudioPlayer
    {
        //SharedAudioControl.sharedAudioPlayer.get()
        if (SharedAudioControl.sharedAudioPlayer == nil)
        {
            do {
                SharedAudioControl.sharedAudioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Pirates", ofType: "mp3")!))
                SharedAudioControl.sharedAudioPlayer!.prepareToPlay()
                if (!SharedAudioControl.sharedAudioPlayer!.isPlaying && !SharedAudioControl.currentlyPlaying) {
                    SharedAudioControl.sharedAudioPlayer!.numberOfLoops = -1
                    SharedAudioControl.sharedAudioPlayer!.play()
                    SharedAudioControl.currentlyPlaying = true
                }
            } catch {
                print("Audio error")
            }
        }
        return SharedAudioControl.sharedAudioPlayer!
    }
}
