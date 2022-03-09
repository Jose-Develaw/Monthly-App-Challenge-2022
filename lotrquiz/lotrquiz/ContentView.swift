//
//  ContentView.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 4/3/22.
//

import SwiftUI

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
    
    
    var body: some View {
        NavigationView{
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
                        ZStack{
                            Text(remaining, format: .number)
                                .font(.title)
                                .frame(maxWidth: 165, maxHeight: 165)
                            if(tickingAmount > 10.0){
                                Image("ringrule")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 165, maxHeight: 165)
                                    .colorMultiply(ringColor())
                                    .mask{
                                        Arc(startAngle: .degrees(0), tickingAmount: tickingAmount, clockwise: true)
                                            .strokeBorder(.red, style: StrokeStyle(lineWidth: 35, lineCap: .round, lineJoin: .round))
                                            .frame(maxWidth: 165, maxHeight: 165)
                                    }
                            }
                        }
                        
                        VStack(alignment: .center){
                            Text(gameQuestions[currentRound].question)
                                .font(.custom("anirb___", size: 36))
                        }
                        .padding()
                        ForEach(options, id: \.self){option in
                            Button{
                                Task.init(priority: .high) {
                                    await answerQuestion(option)
                                }
                            } label: {
                                Text(option)
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(resolveColor(option), lineWidth: 2)
                                    )
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .navigationTitle("El señor de los anillos")
                    .font(.custom("anirb___.ttf", size: 36))
                    .frame(maxWidth: 550)
                    .preferredColorScheme(.dark)
                }
            }
            
           
        }
        .onAppear{
            gameQuestions = allQuestions.shuffled()[..<10]
            options = gameQuestions[currentRound].options.shuffled()
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                withAnimation(.linear(duration: 1)){
                    if (remaining > 0 && !answered) {
                        tickingAmount += 12
                        remaining -= 1
                    } else {
                        Task.init(priority: .high) {
                            await answerQuestion("")
                        }
                    }
                    
                }
            }
        }
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
