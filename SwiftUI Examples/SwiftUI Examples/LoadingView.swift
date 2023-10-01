//
//  LoadingView.swift
//  SwiftUI Examples
//
//  Created by Aynur Nasybullin on 30.09.2023.
//

import SwiftUI

struct LoadingView: View {
    @State private var circleFilling = 1.0
    
    @State private var isAnimating = false
    @State private var angle = 0.0
    @State private var color = Color.purple
    
    var body: some View {
        ZStack {
            Color("DarkGrayBg").ignoresSafeArea()
            
            VStack {
                circleLoading
            }
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                angle = 360
            }
        }
    }
    
    var circleLoading: some View {
        Circle()
            .stroke(AngularGradient(gradient: .init(colors: [color.opacity(0.0), color]),
                                    center: .center),
                    style: StrokeStyle(lineWidth: 6, lineCap: .butt))
            .frame(width: 48)
            .rotationEffect(.degrees(angle))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
