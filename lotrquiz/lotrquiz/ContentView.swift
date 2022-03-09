//
//  ContentView.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 4/3/22.
//

import SwiftUI
import Combine

struct Arc : InsettableShape {
    var startAngle: Angle
    var tickingAmount : Double
    var clockwise : Bool
    var insetAmount = 0.0
    
    var animatableData: Double {
        get { tickingAmount }
        set { tickingAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        let rotationAdjustment = Angle(degrees: 90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = .degrees(tickingAmount) - rotationAdjustment
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.midX, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
   
}

struct ContentView: View {
    var allQuestions : [Question] = Bundle.main.decode("questions.json")
    @State private var gameQuestions = ArraySlice<Question>()
    @State private var currentRound = 0
    @State private var score = 0
    @State private var answered = false
    @State private var selectedOption = ""
    @State private var options = [String]()
        
    @State private var tickingAmount = 0.0
    @State private var remaining = 30
    
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    
    var body: some View {
        VStack{
            ZStack{
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                Color(.black)
                    .opacity(0.75)
                    .ignoresSafeArea()
                if (gameQuestions != []){
                    VStack{
                        Text("THE LORD OF THE QUIZ")
                            .font(.custom("Aniron", size: 28, relativeTo: .title))
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                        ZStack{
                            Text(remaining, format: .number)
                                .font(.custom("Aniron", size: 32, relativeTo: .title))
                                .frame(maxWidth: 150, maxHeight: 150)
                            if(tickingAmount > 10.0){
                                Image("ringrule")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 150, maxHeight: 150)
                                    .colorMultiply(ringColor())
                                    .mask{
                                        Arc(startAngle: .degrees(0), tickingAmount: tickingAmount, clockwise: true)
                                            .strokeBorder(.red, style: StrokeStyle(lineWidth: 35, lineCap: .round, lineJoin: .round))
                                            .frame(maxWidth: 150, maxHeight: 150)
                                    }
                            }
                        }
                        Spacer()
                        VStack{
                            Spacer()
                            VStack(alignment: .center){
                                Text(gameQuestions[currentRound].question)
                                    .font(.custom("Aniron", size: 18, relativeTo: .headline))
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            ForEach(options, id: \.self){option in
                                Button{
                                    Task.init(priority: .high) {
                                        cancelTimer()
                                        await answerQuestion(option)
                                    }
                                } label: {
                                    Text(option)
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .foregroundColor(.white)
                                        .font(.custom("Aniron", size: 18, relativeTo: .headline))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .strokeBorder(resolveColor(option), lineWidth: 2)
                                        )
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .frame(maxHeight: .infinity)
                        
                    }
                    .frame(maxWidth: 550)
                    .padding(15)
                    .preferredColorScheme(.dark)
                    .onReceive(timer){ _ in
                        
                        if (remaining > 0 && !answered) {
                            withAnimation(.linear(duration: 1)){
                                tickingAmount += 12
                            }
                            remaining -= 1
                        } else {
                            cancelTimer()
                            Task.init(priority: .high) {
                                await answerQuestion("")
                            }
                        }
                        
                    }
                }
            }
            
           
        }
        .onAppear{
            gameQuestions = allQuestions.shuffled()[..<10]
            options = gameQuestions[currentRound].options.shuffled()
            instantiateTimer()
        }
    }
    
    func instantiateTimer() {
            self.timer = Timer.publish(every: 1, on: .main, in: .common)
            self.connectedTimer = self.timer.connect()
            return
        }
        
        func cancelTimer() {
            self.connectedTimer?.cancel()
            return
        }
    
    func answerQuestion(_ option: String) async {
        withAnimation{
            selectedOption = option
            answered = true
        }
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        remaining = 30
        currentRound += 1
        selectedOption = ""
        answered = false
        options = gameQuestions[currentRound].options
        tickingAmount = 0.0
        instantiateTimer()
        
    }
    
    func ringColor() -> Color {
        if(remaining > 20) {
            return .white
        } else if (remaining > 10) {
            return .orange
        }
        return .red
    }
    
    func resolveColor(_ option: String) -> Color {
        if(!answered){
            return Color(red: 168/255, green: 147/255, blue: 36/255, opacity: 0.6)
        }
        if(option == gameQuestions[currentRound].correctAnswer){
            return .green
        } else if (option != gameQuestions[currentRound].correctAnswer && option == selectedOption){
            return .red
        }
        return Color(red: 168/255, green: 147/255, blue: 36/255, opacity: 0.6)
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
