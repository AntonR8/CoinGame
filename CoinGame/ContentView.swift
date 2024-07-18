//
//  ContentView.swift
//  CoinGame
//
//  Created by Антон Разгуляев on 18.07.2024.
//

import SwiftUI

struct ContentView: View {
    // MARK: СВОЙСТВА
    @State var selection = "игра"
    let game = ["орел","решка"]
    @State var randomResult = ""
    @State var results = ["man":0, "mac":0]
    @State var history: [[String:Int]] = []
    @State var button1Text = "Начать новую игру"
    @State var board = "Текущий счет 0:0"
    @State var message = ""
    @State var roundCount = 0
    @State var button1disabled = false
    @State var buttons2disabled = true
    @State var button1color = Color.black
    @State var buttonEagleColor = Color.gray
    @State var buttonTailsColor = Color.gray

    // MARK: BODY
    var body: some View {
        TabView(selection: $selection,
                content: { // START: TabView
            ZStack { // START: ZStack
                // фон
                Color.yellow.ignoresSafeArea()

                // передний план
                VStack { // START: VStack
                    Text(board)
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                    Text("Номер броска")
                    Spacer()
                    Text(message)
                        .font(.largeTitle)
                    Spacer()
                    Button(action: { // START: Кнопка начала новой игры и броска монетки
                        randomResult = game.randomElement()!
                        button1disabled = true
                        button1color = .yellow
                        button1Text = ""
                        roundCount += 1
                        buttons2disabled = false
                        buttonEagleColor = Color.blue
                        buttonTailsColor = Color.red
                        message = "орел или решка?"
                        board = "Текущий счет \(results["man"]!):\(results["mac"]!)"
                    },
                           label: {
                        Text(button1Text)
                            .frame(width: 300, height: 100)
                            .background(button1color)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .font(.title)
                    }) // END: Кнопка начала новой игры и броска монетки
                    .disabled(button1disabled)
                    Spacer()
                    HStack {
                        Button(action: { // START: Кнопка "Орел"
                            displayMessage()
                            score(answer: "орел")
                            buttonsDisable(answer: "орел")
                            startNewGame()
                        },
                               label: {
                            Text("Орел")
                                .frame(width: 150, height: 50)
                                .background(buttonEagleColor)
                                .cornerRadius(20)
                                .foregroundColor(.white)
                        }) // END: Кнопка "Орел"
                        .disabled(buttons2disabled)
                        Button(action: { // START: Кнопка "Решка"
                            displayMessage()
                            score(answer: "решка")
                            buttonsDisable(answer: "решка")
                            startNewGame()
                        },
                               label: {
                            Text("Решка")
                                .frame(width: 150, height: 50)
                                .background(buttonEagleColor)
                                .cornerRadius(20)
                                .foregroundColor(.white)
                        }) // END: Кнопка "Решка"
                        .disabled(buttons2disabled)
                    }
                } // END: ZStack
            }
            .tabItem { Text("Игра") }
            .tag("Игра")

            ZStack{ // START: ZStack
                // фон
                Color.black.ignoresSafeArea()

                // передний план
                ScrollView(showsIndicators: false) { // START: ScrollView
                    VStack { // START: VStack
                        ForEach(history, id: \.self) { i in
                            if i["man"]! > i["mac"]! {
                                Text("Вы победили: \(i["man"]!):\(i["mac"]!)")
                                    .frame(width: 300, height: 100)
                                    .background(.yellow)
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                            }
                            else {
                                Text("Вы проиграли: \(i["man"]!):\(i["mac"]!)")
                                    .frame(width: 300, height: 100)
                                    .background(.yellow)
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                            }
                        }
                    } // END: VStack
                } // END: ScrollView
            } // END: ZStack
            .tabItem { Text("Результаты") }
            .tag("Результаты")
        }) // END: TabView
    }

    // MARK: ФУНКЦИИ
    /// Эта функция выводит на экран сообщении о том, какая сторона выпала у монеты
    func displayMessage() {
        if randomResult == "орел" {
            message = "Выпал орел!"
        }
        if randomResult == "решка" {
            message = "Выпала решка!"
        }
    }
    
    /// Эта функция сравнивает параметр answer, задаваемый в зависимости от нажимаемой кнопки, с параметром randomResult (результатом броска монеты) и в зависимости от совпадения (угадал пользователь, что выпадет или нет) добавляет в словарь, хранящий текущий счет игры (results), очко пользователю или компьютеру
    /// - Parameter answer: задаётся в зависимости от нажимаемой кнопки, может быть только "орел" или "решка"
    func score(answer: String) {
        if answer == randomResult {results["man"]!+=1}
        else {results["mac"]!+=1}
    }

    func buttonsDisable(answer: String) {
        buttons2disabled = true
        if answer == "решка"{
            buttonEagleColor = .gray
            buttonTailsColor = .gray.opacity(0.1)
        }
        else {
            buttonEagleColor = .gray.opacity(0.1)
            buttonTailsColor = .gray
        }
        button1disabled = false
        button1color = .black
    }

    func startNewGame() {
        if roundCount < 5 {
            button1Text = "Бросить монетку"
            board = "Текущий счет \(results["man"]!):\(results["mac"]!)"
        }
        else {
            history.append(results)
            button1Text = "Начать новую игру"
            if results["man"]! > results["mac"]! {
                board = "Вы победили \(results["man"]!):\(results["mac"]!)"
            }
            else {
                board = "Вы проиграли \(results["mac"]!):\(results["man"]!)"
            }
            roundCount = 0
            results = ["man":0, "mac":0]
        }
    }
}

// MARK: ПРЕДВАРИТЕЛЬНЫЙ ПРОСМОТР
#Preview {
    ContentView()
}
