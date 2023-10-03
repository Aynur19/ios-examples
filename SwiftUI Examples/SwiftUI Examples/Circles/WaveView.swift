//
//  WaveView.swift
//  SwiftUI Examples
//
//  Created by Aynur Nasybullin on 02.10.2023.
//

import SwiftUI

struct WaveView: View {
    @State private var color: Color
    @State private var position: CGPoint
    @State private var opacity: Double
    @State private var startRadius: CGFloat = 0
    @State private var endRadius: CGFloat = 0
    @State private var duration: CGFloat
    @State private var blure: CGFloat = 0
    
    private let blureRadius: CGFloat
    private let radiusRange: (min: CGFloat, max: CGFloat)
    private let isRandomPosition: Bool
    private let isRandomRadius: Bool
    private let isRepeat: Bool
    private let isAutoReverse: Bool
    
    init(
        color: Color,
        position: CGPoint,
        duration: CGFloat,
        opacity: Double,
        blureRadius: CGFloat,
        radiusRange: (min: CGFloat, max: CGFloat),
        isRandomPosition: Bool = true,
        isRandomRadius: Bool = true,
        isRandomDuration: Bool = true,
        isRepeat: Bool = true,
        isAutoReverse: Bool = false
    ) {
        self.radiusRange = radiusRange
        
        self.color = color
        self.position = position
        self.opacity = opacity
        self.duration = duration
        self.blureRadius = blureRadius
        
        self.isRandomPosition = isRandomPosition
        self.isRandomRadius = isRandomRadius
        self.isRepeat = isRepeat
        self.isAutoReverse = isAutoReverse
    }
    
    
    var body: some View {
        Circle()
            .fill(RadialGradient(colors: [Color.clear, color.opacity(opacity), Color.clear],
                                 center: .center,
                                 startRadius: startRadius,
                                 endRadius: endRadius))
            .position(position)
            .blur(radius: blure)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: duration, repeats: isRepeat) { _ in
                    if isRandomPosition {
                        withAnimation(nil) {
                            startRadius = 0
                            endRadius = 0
                        }
                        
                        randPosition()
                        
                        withAnimation(.easeInOut(duration: duration)
                            .repeatForever(autoreverses: isAutoReverse)) {
                                isRandomRadius ? randRadius() : staticRadius()
                                blure = blureRadius
                            }
                    } else {
                        withAnimation(.easeInOut(duration: duration)
                            .repeatForever(autoreverses: isAutoReverse)) {
                                isRandomRadius ? randRadius() : staticRadius()
                                blure = blureRadius
                            }
                    }
                }
            }
    }
    
    private func randPosition() {
        position.x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
        position.y = CGFloat.random(in: 0...UIScreen.main.bounds.height)
    }
    
    private func staticRadius() {
        startRadius = radiusRange.max * 0.1
        endRadius = radiusRange.max
    }
    
    private func randRadius() {
        startRadius = CGFloat.random(in: radiusRange.min...radiusRange.max) * 0.1
        endRadius = CGFloat.random(in: radiusRange.min...radiusRange.max)
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            WaveView(
                color: .purple,
                position: .init(x: 100, y: 100),
                duration: 3,
                opacity: 0.5,
                blureRadius: 20,
                radiusRange: (min: 50, max: 100)
            )
        }
    }
}
