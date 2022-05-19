//
//  ContentView.swift
//  BokehSwiftUI
//
//  Created by Cesar Mejia Valero on 5/18/22.
//

import SwiftUI

let durationConstant: Double = 20.0
let blueBackgroundColors: [Color] = [.yellow, .gray, .indigo, .green, .red, .orange, .white, .black, .brown, .mint, .pink, .purple]
let redBackgroundColors: [Color] = [.yellow, .gray, .indigo, .green, .teal, .blue, .white, .black, .brown, .mint, .pink, .purple, .cyan]

enum GradientBackground {
    case blue, red
    
    var colorList: [Color] {
        switch self {
        case .blue:
            return [.teal, .blue]
        case .red:
            return [.red, .orange]
        }
    }
}

struct ContentView: View {
    
    @State var isFirstTime = true
    @State var changeCirclePosition: Bool = false
    @State var gradientColors: GradientBackground = .blue
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                LinearGradient(colors: gradientColors.colorList, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .onTapGesture {
                        gradientColors = gradientColors == .blue ? .red : .blue
                    }
                ForEach(1...1, id: \.self) { _ in
                    BokehCircle(color: blueBackgroundColors.random(), backgroundColor: $gradientColors, changePosition: $changeCirclePosition)
                    BokehCircle(color: blueBackgroundColors.random(), backgroundColor: $gradientColors, changePosition: $changeCirclePosition)
                    BokehCircle(color: blueBackgroundColors.random(), backgroundColor: $gradientColors, changePosition: $changeCirclePosition)
                    BokehCircle(color: blueBackgroundColors.random(), backgroundColor: $gradientColors, changePosition: $changeCirclePosition)
                    BokehCircle(color: blueBackgroundColors.random(), backgroundColor: $gradientColors, changePosition: $changeCirclePosition)
                    BokehCircle(color: blueBackgroundColors.random(), backgroundColor: $gradientColors, changePosition: $changeCirclePosition)
                    BokehCircle(color: blueBackgroundColors.random(), backgroundColor: $gradientColors, changePosition: $changeCirclePosition)
                    BokehCircle(color: blueBackgroundColors.random(), backgroundColor: $gradientColors, changePosition: $changeCirclePosition)
                    BokehCircle(color: blueBackgroundColors.random(), backgroundColor: $gradientColors, changePosition: $changeCirclePosition)
                }
            }
            .onAppear(perform: changeAnimationValuesTimer)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func changeAnimationValuesTimer() {
        let duration = isFirstTime ? 0 : durationConstant
        DispatchQueue.main.asyncAfter(deadline: .now() + duration - 5) {
            isFirstTime = false
            changeCirclePosition.toggle()
            changeAnimationValuesTimer()
        }
    }
    
}

struct BokehCircle: View {
    @State var color: Color
    @Binding var backgroundColor: GradientBackground
    @Binding var changePosition: Bool
    
    static let halfWidth = Int(UIScreen.main.bounds.width / 2)
    static let halfHeight = Int(UIScreen.main.bounds.height / 2)
    
    @State var circlePosition = CGSize(width: Int.random(in: -halfWidth...halfWidth), height: Int.random(in: -halfHeight...halfHeight))
    @State var blurRadius = CGFloat(Int.random(in: 20...40))
    
    var body: some View {
        Circle()
            .fill(color)
            .blur(radius: blurRadius)
            .frame(width: UIScreen.main.bounds.width / 4, height: 270)
            .offset(circlePosition)
            .animation(.linear(duration: durationConstant), value: circlePosition)
            .animation(.easeInOut(duration: durationConstant), value: blurRadius)
            .onTapGesture {
                switchColor(backgroundColor: backgroundColor)
            }
            .onChange(of: changePosition) { _ in
                changeValues()
            }
            .onChange(of: backgroundColor) { backColor in
                switch backColor {
                case .blue:
                    if color == .blue || color == .cyan || color == .teal {
                        switchColor(backgroundColor: backColor)
                    }
                case .red:
                    if color == .red || color == .pink || color == .orange {
                        switchColor(backgroundColor: backColor)
                    }
                }
            }
    }
    
    private func switchColor(backgroundColor: GradientBackground) {
        switch backgroundColor {
        case .blue:
            color = blueBackgroundColors.differentRandomColor(currentColor: color)
        case .red:
            color = redBackgroundColors.differentRandomColor(currentColor: color)
        }
    }
    
    private func changeValues() {
            circlePosition = CGSize(width: Int.random(in: -BokehCircle.halfWidth...BokehCircle.halfWidth), height: Int.random(in: -BokehCircle.halfHeight...BokehCircle.halfHeight))
            blurRadius = CGFloat(Int.random(in: 20...40))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





extension Array where Element == Color {
    func random() -> Color {
        self[Int.random(in: 0..<self.count)]
    }
    
    func differentRandomColor(currentColor: Color) -> Color {
        let obtainedColor: Color = self.random()
        if currentColor == obtainedColor {
            return differentRandomColor(currentColor: currentColor)
        }
        return obtainedColor
    }
}
