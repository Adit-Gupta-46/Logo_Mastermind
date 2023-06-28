//
//  ViewController.swift
//  Logo picker
//
//  Created by Adit Gupta on 12/23/21.
//  Copyright © 2021 Adit Gupta. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var Image: UIImageView!
    @IBOutlet var answerOne: UIButton!
    @IBOutlet var answerTwo: UIButton!
    @IBOutlet var answerThree: UIButton!
    @IBOutlet var answerFour: UIButton!
    @IBOutlet var quit: UIButton!
    @IBOutlet var displayCorrect: UILabel!
    @IBOutlet var displayIncorrect: UILabel!
    @IBOutlet var totalCorrect: UILabel!
    @IBOutlet var totalIncorrect: UILabel!
    @IBOutlet var timer: UILabel!
    
    var cachedImages = [UIImage]()
    
    let counterMaxConstant = 9
    let counterMinConstant = 3
    let counterChangeConstant = 0.2
    let maxNumberOfIncorrectConstant = 3
    let timeIntervalSubtractor = 0.01
    var timeInterval = 1.0
    var counterSubtractor = 0.0
    var counter = -1
    var looseStatus: String!
    var numberOfCorrect: Int!
    var numberOfIncorrect: Int!
    var correctKey: String!
    var myTimer : Timer!
    var player: AVAudioPlayer!
    var photoNameQueue = Queue()
    private var photoData = [String : String]() // Dictionary: keys --> name, values --> link
    
    // Main
    override func viewDidLoad() {
        super.viewDidLoad()
        myTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        readCSV();
        initialSetGame()
        resetGame()
    }
    
    func initialSetGame(){
        Image.backgroundColor = .white
        let answerHeight = answerOne.frame.height
        answerOne.titleLabel?.font = UIFont.systemFont(ofSize: answerHeight * 0.22)
        answerTwo.titleLabel?.font = UIFont.systemFont(ofSize: answerHeight * 0.22)
        answerThree.titleLabel?.font = UIFont.systemFont(ofSize: answerHeight * 0.22)
        answerFour.titleLabel?.font = UIFont.systemFont(ofSize: answerHeight * 0.22)
        quit.titleLabel?.font = UIFont.systemFont(ofSize: answerHeight * 0.22)
        
        let timerHeight = timer.frame.height
        timer.font = timer.font.withSize(timerHeight * 0.85)
        
        let scoreKeeperHeight = displayCorrect.frame.height
        totalCorrect.font = totalCorrect.font.withSize(scoreKeeperHeight * 0.85)
        totalIncorrect.font = totalIncorrect.font.withSize(scoreKeeperHeight * 0.85)
        displayCorrect.font = displayCorrect.font.withSize(scoreKeeperHeight * 0.75)
        displayIncorrect.font = displayIncorrect.font.withSize(scoreKeeperHeight * 0.75)
    }

    
    func resetGame(){
        counter = counterMaxConstant
        counterSubtractor = 0.0
        timeInterval = 1.0
        timer.text = "00:0\(counter)"
        Image.backgroundColor = .white
        numberOfCorrect = 0
        numberOfIncorrect = 0
        photoNameQueue.shuffle()
        cachedImages.removeAll()
        getRandomPhoto()
    }

    // Gets a new photo
    func getRandomPhoto(){
        displayCorrect.text = String(numberOfCorrect)
        displayIncorrect.text = String(numberOfIncorrect)
        correctKey = photoNameQueue.dequeue()
        photoNameQueue.enqueue(element: correctKey)
        
        if (cachedImages.count == 0){
            cachedImages.append(getImage(input: correctKey))
            cachedImages.append(getImage(input: photoNameQueue.items[0]))
            cachedImages.append(getImage(input: photoNameQueue.items[1]))
        }
        else{
            cachedImages.remove(at: 0)
            cachedImages.append(getImage(input: photoNameQueue.items[1]))
        }
        Image.image = cachedImages[0]

        // Image.image = getImage(input: correctKey)
        
        let incorrectKey1 = otherButtonNamePicker(comparable1: correctKey, comparable2: "", comparable3: "");
        let incorrectKey2 = otherButtonNamePicker(comparable1: correctKey, comparable2: incorrectKey1, comparable3: "");
        let incorrectKey3 = otherButtonNamePicker(comparable1: correctKey, comparable2: incorrectKey1, comparable3: incorrectKey2);

        var names = [String]()
        
        names.append(buttonNameProcessing(input: correctKey))
        names.append(buttonNameProcessing(input: incorrectKey1))
        names.append(buttonNameProcessing(input: incorrectKey2))
        names.append(buttonNameProcessing(input: incorrectKey3))
        names = names.shuffled()

        answerOne.setTitle(names[0], for: .normal)
        answerTwo.setTitle(names[1], for: .normal)
        answerThree.setTitle(names[2], for: .normal)
        answerFour.setTitle(names[3], for: .normal)
    }
    
    func getImage(input: String) -> UIImage {
        let urlString = photoData[input]
        let url = URL(string: urlString!)!
        let data = try? Data(contentsOf: url)
        let image = UIImage(data:data!)!
//        DispatchQueue.main.async {
//            if data != nil {
//                image = UIImage(data:data!)!
//            }else{
//                image = UIImage(named: "default.png")!
//            }
//        }
        return image
    }
    
    @IBAction func quitGame(_ sender: Any) {
        myTimer!.invalidate()
    }
    
    func gameOver() {
        myTimer!.invalidate()
        performSegue(withIdentifier: "goToLose", sender: self)
        resetGame()
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            timer.text = "00:0\(counter)"
            counter -= 1
        }
        else{
            looseStatus = "Time's Up"
            gameOver()
        }
    }
    
    func timerReset(){
        myTimer!.invalidate()
        if (Int(Double(counterMaxConstant) - counterSubtractor) >= counterMinConstant){
            counterSubtractor += counterChangeConstant
            counter = Int(Double(counterMaxConstant) - counterSubtractor)
        }
        else{
            counter = counterMaxConstant - (counterMaxConstant - counterMinConstant)
            timeInterval -= timeIntervalSubtractor
        }
        myTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timer.text = "00:0\(counter)"
    }
    
    func checkButtonAccuracy(button: UIButton){
//        let status = StartPageViewController().muteStatus
//        if (status == true){
//            print (5555)
//        }
        if (button.title(for: .normal) == buttonNameProcessing(input: correctKey)){
            playSound(inputFile: "correct", fileType: "wav")
            numberOfCorrect += 1
        }
        else{
            playSound(inputFile: "wrongAnswerSound", fileType: "wav")
            numberOfIncorrect += 1
        }
        
        timerReset()
        
        if (numberOfIncorrect == maxNumberOfIncorrectConstant){
            looseStatus = "You got \(maxNumberOfIncorrectConstant) wrong"
            gameOver()
        }
        else{
            getRandomPhoto()
        }
    }
    
    @IBAction func button1Clicked(_ sender: Any) {
        checkButtonAccuracy(button: answerOne)
    }
    
    @IBAction func button2Clicked(_ sender: Any) {
        checkButtonAccuracy(button: answerTwo)
    }
    
    @IBAction func button3Clicked(_ sender: Any) {
        checkButtonAccuracy(button: answerThree)
    }
    
    @IBAction func button4Clicked(_ sender: Any) {
        checkButtonAccuracy(button: answerFour)
    }
    
    func otherButtonNamePicker(comparable1: String, comparable2: String, comparable3: String) -> String {
        var answer = photoData.keys.randomElement()!
        while (answer == comparable1 || answer == comparable2 || answer == comparable3){
            answer = photoData.keys.randomElement()!
        }
        return (answer)
    }
    
    // Beautifies given string name for button
    private func buttonNameProcessing(input: String) -> String {
        var answer = input
        answer = String(answer.prefix(answer.count-4))
        answer = answer.replacingOccurrences(of: "-", with: " ")
        answer = answer.replacingOccurrences(of: "_", with: " ")
        answer = answer.capitalized
        answer = answer.replacingOccurrences(of: "Png", with: "")
        answer = answer.replacingOccurrences(of: "png", with: "")
        answer = answer.replacingOccurrences(of: ".Com", with: "")
        answer = answer.replacingOccurrences(of: "Logo", with: "")
        answer = answer.replacingOccurrences(of: "logo", with: "")
        answer = answer.replacingOccurrences(of: "Icon", with: "")
        answer = answer.replacingOccurrences(of: "Seek", with: "")
        answer = answer.replacingOccurrences(of: "Symbol", with: "")
        answer = answer.components(separatedBy: CharacterSet.decimalDigits).joined()
        answer = answer.capitalized
        return (answer)
    }
    
    // Gets CSVFile and returns unprocessed array of lines
    private func readCSV(){
        var myData : [String] = []
        
        let filePath = Bundle.main.path(forResource: "pics", ofType: "csv")!
        let fileUrl = URL(fileURLWithPath: filePath)

        do{
            let savedData = try String(contentsOf: fileUrl)
            myData = savedData.components(separatedBy: "\r")
        } catch {
            myData = ["Error"]
        }
        
        var finalData = [[String]]()
        
        for i in 2...myData.count-1 {
            var seperatedData : [String] = []
            seperatedData = (myData[i]).components(separatedBy: ",")
            finalData.append(seperatedData)
        }
        
        for i in 0...finalData.count-1 {
            photoData[String(finalData[i][0].suffix(finalData[i][0].count-1))] = finalData[i][9]
            photoNameQueue.enqueue(element: String(finalData[i][0].suffix(finalData[i][0].count-1)))
        }
    }
    
    func playSound(inputFile: String, fileType: String) {
        let url = Bundle.main.path(forResource: inputFile, ofType: fileType)
        try? player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
        player.play()
    }
    
    @IBAction func unwindToGame(segue: UIStoryboardSegue){}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToLose"){
            let destinationVC = segue.destination as! LoseViewController
            destinationVC.statusVar = looseStatus
        }
    }
    
    struct Queue{
        
        var items:[String] = []
        
        mutating func enqueue(element: String)
        {
            items.append(element)
        }
        
        mutating func shuffle(){
            items = items.shuffled()
        }
        
        mutating func dequeue() -> String?
        {
            
            if items.isEmpty {
                return nil
            }
            else{
                let tempElement = items.first
                items.remove(at: 0)
                return tempElement
            }
        }
        
    }
}


