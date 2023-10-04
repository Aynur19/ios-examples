//
//  CircleWaveView.swift
//  SwiftUI Examples
//
//  Created by Aynur Nasybullin on 02.10.2023.
//

import SwiftUI

class CircleWaveViewModel: Identifiable, ObservableObject {
    let id = UUID().uuidString
    let color: Color
    let position: CGPoint
    let duration: CGFloat
    let opacity: Double
    
    @Published var radius: CGFloat = 0
    let maxRadius: CGFloat
    
    init(
        color: Color = .blue,
        position: CGPoint = .init(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY),
        duration: CGFloat = 2,
        radius: CGFloat = 100,
        opacity: Double = 0.5
    ) {
        self.color = color
        self.position = position
        self.duration = duration
        self.maxRadius = radius
        self.opacity = opacity
    }
    
    func update() {
        radius = maxRadius
    }
}

struct CircleWaveView: View {
    @State private var circleWaves: [CircleWaveViewModel] = []
    @State private var timer: Timer?
    
    private let colors: [Color]
    
    private let position: CGPoint
    private let positionRange: (min: CGPoint, max: CGPoint)
    private let isRandomPosition: Bool
    
    private let generationDuration: Double
    
    private let liveCycleDuration: Double
    private let liveCycleDurationRange: (min: Double, max: Double)
    private let isRandomLiveCycleDuration: Bool
    
    private let radius: CGFloat
    private let radiusRange: (min: CGFloat, max: CGFloat)
    private let isRandomRadius: Bool
    
    private let opacity: Double
    private let opacityRange: (min: Double, max: Double)
    private let isRandomOpacity: Bool
    
    private let blureRadius: CGFloat
    private let isBlured: Bool
    
    init(
        colors: [Color] = [.red, .green, .blue],
        position: CGPoint = .init(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY),
        positionRange: (min: CGPoint, max: CGPoint) = (min: .zero,
                                                       max: .init(x: UIScreen.main.bounds.width,
                                                                  y: UIScreen.main.bounds.height)),
        isRandomPosition: Bool = true,
        
        generationDuration: Double = 2,
        
        liveCycleDuration: Double = 4,
        liveCycleDurationRange: (min: Double, max: Double) = (min: 3, max: 5),
        isRandomLiveCycleDuration: Bool = true,
        
        radius: CGFloat = 100,
        radiusRange: (min: CGFloat, max: CGFloat) = (min: 50, max: 150),
        isRandomRadius: Bool = true,
        
        opacity: Double = 0.5,
        opacityRange: (min: Double, max: Double) = (min: 0.0, max: 1.0),
        isRandomOpacity: Bool = true,
        
        blureRadius: CGFloat = 10,
        isBlured: Bool = false
    ) {
        self.colors = colors
        
        self.position = position
        self.positionRange = positionRange
        self.isRandomPosition = isRandomPosition
        
        self.generationDuration = generationDuration
    
        self.liveCycleDuration = liveCycleDuration
        self.liveCycleDurationRange = liveCycleDurationRange
        self.isRandomLiveCycleDuration = isRandomLiveCycleDuration
        
        self.radius = radius
        self.radiusRange = radiusRange
        self.isRandomRadius = isRandomRadius
        
        self.opacity = opacity
        self.opacityRange = opacityRange
        self.isRandomOpacity = isRandomOpacity
        
        self.blureRadius = blureRadius
        self.isBlured = isBlured
    }
    
    var body: some View {
        ZStack {
            ForEach(circleWaves) { circleWave in
                Circle()
                    .fill(RadialGradient(colors: [Color.clear, circleWave.color.opacity(circleWave.opacity), Color.clear],
                                         center: .center,
                                         startRadius: 0,
                                         endRadius: circleWave.radius))
                    .position(circleWave.position)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + circleWave.duration) {
                            removeCircleWave(circleWave)
                        }
                    }
                    .blur(radius: getBlureRadius())
                    .animation(.linear(duration: circleWave.duration), value: circleWave.radius)
                    .onAppear {
                        circleWave.update()
                    }
            }
        }
        .onAppear {
            startTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            addCircleWave()
        }
    }
    
    private func addCircleWave() {
        let circleWave = CircleWaveViewModel(
            color: colors.randomElement() ?? .white,
            position: getPosition(),
            duration: getDuration(),
            radius: getRadius(),
            opacity: getOpacity()
        )
        
        circleWaves.append(circleWave)
    }
    
    private func getPosition() -> CGPoint {
        return isRandomPosition
        ? .init(x: CGFloat.random(in: positionRange.min.x...positionRange.max.x),
                y: CGFloat.random(in: positionRange.min.y...positionRange.max.y))
        : position
    }
    
    private func getDuration() -> Double {
        return isRandomLiveCycleDuration
        ? Double.random(in: liveCycleDurationRange.min...liveCycleDurationRange.max)
        : liveCycleDuration
    }
    
    private func getRadius() -> CGFloat {
        return isRandomRadius
        ? CGFloat.random(in: radiusRange.min...radiusRange.max)
        : radius
    }
    
    private func getOpacity() -> Double {
        return isRandomOpacity
        ? Double.random(in: opacityRange.min...opacityRange.max)
        : opacity
    }
    
    private func getBlureRadius() -> CGFloat {
        return isBlured ? blureRadius : 0
    }
    
    private func removeCircleWave(_ circleWave: CircleWaveViewModel) {
        if let idx = circleWaves.firstIndex(where: { $0.id == circleWave.id }) {
            _ = circleWaves.remove(at: idx)
        }
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CircleWaveView()
        }
    }
}
