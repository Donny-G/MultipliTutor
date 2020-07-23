//
//  ContentView.swift
//  multipliTutor
//
//  Created by DeNNiO   G on 12.05.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
//notch animation
import Combine
import RainbowBar


struct ContentView: View {
    //to make full background to all views - list have some color predefined
    init() {
        UITableView.appearance().backgroundColor = .clear // tableview background
        UITableViewCell.appearance().backgroundColor = .clear // cell background
    }
    
    //props + func for nothc animation
    private var animatedSignal = PassthroughSubject<Bool, Never>()
    @State private var animatedInnerState: Bool = false
    @State private var running = false
    func start() {
        self.animatedInnerState.toggle()
        self.animatedSignal.send(self.animatedInnerState)
        if self.animatedInnerState {
        self.running = true
        }
    }
        
    
    @State private var settingsOn = true
    @State private var gameStyle = 0
    @State private var gameStyles = ["NUMBER PAD", "FUNNY BUTTONS", "HOW MANY"]
    @State private var numberOfQuestions = 4
    @State private var questionsArray = [4, 8, 10, 15, 20]
    @State private var questionCounter = 0
    @State private var score = 0
    @State private var allScores = [Int]()
    @State private var title = "FUNNY NUMBERS"
    var amountOfQuestions: Int {
        return questionsArray[numberOfQuestions]
    }
    @State private var animals = ["bear", "lion", "monkey", "pig"]
    
    //NUMBER PAD GAME PROPERTIES
    @State private var answerField = ""
    @State private var theWholeQuestion = ""
    @State private var question = ""
    @State private var answerState = ""
    @State private var result = ""
    @State private var solutions = [String]()
    
    //FUNNY BUTTONS PROPERTIES
    @State private var randomNumber = Int.random(in: 0...2)
    @State private var numbers = ["1 * 1", "2 * 2", "3 * 3", "8 * 2", "5 * 5"].shuffled()
    @State private var resultFN = ""
    
    //HOW MUCH PROPERTIES
    @State private var amountHM = ["6", "3", "5"].shuffled()
    @State private var fromStepper = 0
    @State private var randomCard  = Int.random(in: 0...2)
    @State private var resultHM = ""
  
    //NUMBER PAD FUNCS
    func startNumberPadGame() {
    if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
        if let fileContent = try? String(contentsOf: fileURL) {
            //extra line break check
            let allQuestions = fileContent.components(separatedBy: "\n").filter { !$0.isEmpty
            }.shuffled()
                for (index, question) in allQuestions.enumerated() {
                    let parts = question.components(separatedBy: "=")
                        self.question = parts[0]
                            answerState = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                            theWholeQuestion = String( "\(parts[0]) = \(parts[1])")
                }
            }
        }
    }
    
    func numberPadCheck() {
        guard let answer = Int(answerField) else {return}
        if answer == Int(answerState) {
            result = "Correct, clever child"
            solutions.insert(theWholeQuestion, at: 0)
            solutions[0] = "\(theWholeQuestion) Correct"
            score += 1
        } else {
            result = "Wrong, please think again"
            solutions.insert(theWholeQuestion, at: 0)
            solutions[0] = "\(theWholeQuestion) Wrong"
        }
        
        questionCounter += 1
        if questionCounter == amountOfQuestions{
            result = "GAME OVER. Your score is \(score)"
        } else {
            startNumberPadGame()
        }
    }
    
    func newNumberPadGame() {
        answerField = ""
        theWholeQuestion = ""
        question = ""
        answerState = ""
        result = ""
        solutions = []
        startNumberPadGame()
    }
    
    //FUNNY BUTTONS FUNCS
    func newFunnyButtonsGame() {
        resultFN = ""
        nextQuestionFunnyButtons()
    }
    
    func nextQuestionFunnyButtons() {
        numbers.shuffle()
        randomNumber = Int.random(in: 0...2)
    }
    
    func checkFunnyButtons(number: Int) {
        if number == randomNumber {
            score += 1
            resultFN = "Correct, clever child"
        } else {
            resultFN = "Wrong, please think again"
        }
        
        questionCounter += 1
        if questionCounter == amountOfQuestions {
            resultFN = "GAME OVER. Your score is \(score)"
        } else {
            nextQuestionFunnyButtons()
        }
    }
    
    //HOW MUCH FUNCS
    func checkHM(){
        guard let check = Int(amountHM[randomCard]) else {return}
        if check == fromStepper {
            resultHM = "Correct, clever child"
            score += 1
        } else {
            resultHM = "Wrong, please think again"
        }
        
        questionCounter += 1
        if questionCounter == amountOfQuestions {
            resultHM = "GAME OVER. Your score is \(score)"
        } else {
            nextHM()
        }
    }
    
    func nextHM() {
        amountHM.shuffle()
        randomCard = Int.random(in: 0...2)
    }
    
    func newHMGame() {
        resultHM = ""
    }
    
    func titleNP() {
        title = "NUMBER PAD GAME"
    }
    func titleFB() {
        title = "FUNNY BUTTONS"
    }
    func titleHM() {
        title = "HOW MANY GAME"
    }
    func titleMain() {
        title = "NUMBERRY"
    }
    
    var body: some View {
        NavigationView {
          ZStack{
            LinearGradient(gradient: Gradient(colors: [.purple,.white, .yellow,.white, .yellow, .green]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        VStack {
            //create notch animation
            RainbowBar(waveEmitPeriod: 0.3, visibleWavesCount: 5, waveColors: [.orange,.red,.yellow,.pink], backgroundColor: .white, animated: animatedSignal) {
            self.running = true
            }
                .edgesIgnoringSafeArea(.all)
                //autostart
                .onAppear(perform: start)
            
            Toggle(isOn: $settingsOn) { Text("SETTINGS MODE")
                                            .font(.headline)
                                            .underline(true, color: .purple)
                                            .foregroundColor(.purple)
            }
                .frame(width: 300)
                .colorMultiply(.orange)
                .background(Color.yellow)
                .cornerRadius(50)
                .shadow(color: .black, radius: 1, x: 5, y: 5)
            
            
            //SETTINGS MODE
            if settingsOn {
                Form {
                Section(header: Text("Choose game style")){
                    Picker("Game Styles", selection: $gameStyle) {
                        ForEach(0 ..< gameStyles.count) {
                            Text(self.gameStyles[$0])
                        }
                    }
                        .pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(.yellow)
                        .background(Color.orange)
                        .cornerRadius(20)
                        .shadow(color: .black, radius: 1, x: 5, y: 5)
                }
                    .foregroundColor(.purple)
                   
                Section(header: Text("Number of questions")) {
                    Picker("Number of questions", selection: $numberOfQuestions) {
                        ForEach(0 ..< questionsArray.count) {
                            Text("\(self.questionsArray[$0])")
                        }
                    }
                        .pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(.yellow)
                        .background(Color.orange)
                        .cornerRadius(20)
                        .shadow(color: .black, radius: 1, x: 5, y: 5)
                }
                    .foregroundColor(.purple)
                    .onAppear(perform: newNumberPadGame)
                    .onAppear(perform: newFunnyButtonsGame)
                    .onAppear(perform: newHMGame)
                    .onAppear(perform: titleMain)
            }
                
                Spacer()
                
                Text("Total score: \(score)")
                    .font(.largeTitle)
                    .foregroundColor(.purple)
                            
                Image(animals.randomElement()!)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .shadow(color: .black, radius: 3, x: 5, y: 5)
                                    
                Button("NEW GAME SESSION") {
                    self.allScores.insert(self.score, at: 0)
                    self.score = 0
                }
            
                Form {
                    Section(header: Text("Previous results")) {
                        List {
                            ForEach(allScores, id: \.self) {
                                Text("Score: \($0)")
                            }
                        }   .listRowBackground(Color.green)
                            .foregroundColor(.white)
                    }
                        .foregroundColor(.purple)
                }
            
            } else if gameStyle == 0 {
                //NUMBER PAD GAME VIEW
                        Text("What is \(self.question)")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
            
                        TextField("Enter answer here", text: self.$answerField, onCommit: numberPadCheck)
                            .frame(width: 350, height: 100)
                            .background(Color.orange)
                            .cornerRadius(20)
                            .shadow(color: .black, radius: 1, x: 5, y: 5)
                                
                        Text(result)
                            .onAppear(perform: startNumberPadGame)
                            .onAppear(perform: titleNP)
                            .foregroundColor(.pink)
                
                        Form {
                            Section(header: Text("Questions")) {
                                List {
                                    ForEach(solutions, id: \.self) {
                                        Text($0)
                                    }
                                }   .listRowBackground(Color.green)
                                    .foregroundColor(.white)
                            }.foregroundColor(.purple)
                        }
                
                        Image(animals.randomElement()!)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .shadow(color: .black, radius: 3, x: 5, y: 5)
                        
            } else if gameStyle == 1 {
                //FUNNY BUTTONS GAME VIEW
                    Text("What is the result of multiplication")
                        .font(.title)
                        .foregroundColor(.purple)
                
                    Text(numbers[randomNumber])
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                
                    ForEach(0..<3, id: \.self){ id in
                        Button(action: {
                            self.checkFunnyButtons(number: id)
                        }) {
                            Image(self.numbers[id])
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .shadow(color: .black, radius: 3, x: 5, y: 5)
                            }
                    }
                
                        Text(resultFN)
                            .font(.title)
                            .foregroundColor(.white)
                
            } else if gameStyle == 2 {
                //HOW MUCH GAME VIEW
                Text("How many animals are on the picture ?")
                    .font(.largeTitle)
                    .foregroundColor(.purple)
                
                Image(amountHM[randomCard])
                    .resizable()
                    .frame(width: 260, height: 260)
                    .shadow(color: .black, radius: 3, x: 5, y: 5)
                    .onAppear(perform: titleHM)
                Form {
                    Section(header: Text("Use + or - to select correct answer, than submit")) {
                        Stepper(value: $fromStepper) {
                            Text("\(fromStepper)")
                        }
                            .foregroundColor(.pink)
                            .background(Color.yellow)
                            .font(.title)
                    }  .foregroundColor(.purple)
                    
                    Button("Submit") {
                        self.checkHM()
                    }
                    Text(resultHM)
                        .font(.title)
                        .foregroundColor(.white)
                    Spacer()
                        }   .shadow(color: .black, radius: 3, x: 5, y: 5)
                    }
                }
            }.navigationBarTitle(title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
