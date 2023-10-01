//
//  LoadingView.swift
//  SwiftUI Examples
//
//  Created by Aynur Nasybullin on 30.09.2023.
//

import SwiftUI

struct LoadingView: View {
    @State private var startColor = Color.purple
    @State private var endColor = Color.clear
    
    @State private var circleFilling = 1.0
    
    @State private var angle = 0.0
    @State private var gradientAngle: Angle = .degrees(0)
    
    @State private var dots: CGFloat = 25
    
    private let duration: CGFloat = 2
    private let fullAngle: Double = 360
    private let lineWidth: CGFloat = 10
    private let frameSize: CGFloat = 128
    
    var body: some View {
        ZStack {
            Color("DarkGrayBg").ignoresSafeArea()
            
            VStack(spacing: 20) {
                circleLoading
                circleLoading2
                circleLoading3
            }
        }
        .onAppear {
            withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
                angle = fullAngle
            }
        }
    }
    
    var circleLoading: some View {
        Circle()
            .stroke(AngularGradient(gradient: .init(colors: [endColor, startColor]),
                                    center: .center),
                    style: StrokeStyle(lineWidth: lineWidth,
                                       lineCap: .round,
                                       dash: [390], dashPhase: -5))
            .frame(width: frameSize)
            .rotationEffect(.degrees(angle))
    }
    
    var circleLoading2: some View {
        Circle()
            .stroke(AngularGradient(gradient: .init(colors: [endColor, startColor]),
                                    center: .center),
                    style: StrokeStyle(lineWidth: lineWidth,
                                       lineCap: .round,
                                       dash: [0, CGFloat(128/8)], dashPhase: -5))
            .frame(width: frameSize)
            .rotationEffect(.degrees(angle))
    }
    
    var circleLoading3: some View {
        Circle()
            .stroke(AngularGradient(gradient: Gradient(colors: [.clear, .purple]),
                                    center: .center,
                                    startAngle: gradientAngle,
                                    endAngle: gradientAngle + .degrees(fullAngle)),
                    style: StrokeStyle(lineWidth: 10,
                                       lineCap: .round,
                                       dash: [0, CGFloat(128/8)], dashPhase: -10))
            .frame(width: frameSize)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: duration/dots, repeats: true) { timer in
                    gradientAngle += Angle(degrees: fullAngle / dots)
                }
            }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
