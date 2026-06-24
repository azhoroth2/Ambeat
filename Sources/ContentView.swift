import SwiftUI

struct ContentView: View {
    @State private var audioEngine = AudioEngine()

    var body: some View {
        ZStack {
            // Minimalist solid black background
            Color.black
                .ignoresSafeArea()

            // Sound-Reactive Pixel Wave Visualizer
            TimelineView(.animation) { timelineContext in
                let time = timelineContext.date.timeIntervalSinceReferenceDate
                let level = audioEngine.currentLevel

                Canvas { context, size in
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)
                    let maxRadius = max(size.width, size.height) * 0.70
                    
                    // Pixel grid configuration
                    let pixelSize: CGFloat = 8.0
                    let gap: CGFloat = 4.0
                    let cellSize = pixelSize + gap
                    
                    // Wave propagation speed
                    let speed = 4.0
                    let wavePhaseOffset = time * speed
                    
                    // Calculate grid offset to center the pixels perfectly
                    let cols = Int(size.width / cellSize)
                    let rows = Int(size.height / cellSize)
                    let startX = (size.width - CGFloat(cols) * cellSize) / 2 + cellSize / 2
                    let startY = (size.height - CGFloat(rows) * cellSize) / 2 + cellSize / 2
                    
                    let levelScale = level * 3.5 // Reactivity boost
                    
                    for c in 0..<cols {
                        for r in 0..<rows {
                            let x = startX + CGFloat(c) * cellSize
                            let y = startY + CGFloat(r) * cellSize
                            
                            let dx = x - center.x
                            let dy = y - center.y
                            let distance = sqrt(dx*dx + dy*dy)
                            
                            // Normalized progress (0...1) from center
                            let progress = distance / maxRadius
                            let edgeFade = max(0.0, 1.0 - progress)
                            
                            // Ripple wave phase propagating outwards from center
                            let ripplePhase = distance * 0.035 - wavePhaseOffset
                            let ripple = 0.5 + 0.5 * sin(ripplePhase) // 0...1 oscillation
                            
                            // Wave intensity scales dramatically with sound
                            let waveIntensity = ripple * (0.15 + levelScale * 1.6)
                            
                            // Pixel scale: scales up on wave peak
                            let scale = 0.5 + ripple * 0.5 * (1.0 + levelScale * 0.4)
                            let currentPixelSize = pixelSize * scale
                            
                            // Opacity: background pixels are dim, wave is bright
                            let opacity = (0.04 + waveIntensity * 0.75) * edgeFade
                            
                            if opacity < 0.01 { continue }
                            
                            // Draw glow layer for active wave pixels (boxShadow emulation)
                            if waveIntensity > 0.18 {
                                let glowSize = currentPixelSize * 2.0
                                let glowRect = CGRect(
                                    x: x - glowSize / 2,
                                    y: y - glowSize / 2,
                                    width: glowSize,
                                    height: glowSize
                                )
                                context.fill(
                                    Path(glowRect),
                                    with: .color(.white.opacity(0.14 * waveIntensity * edgeFade))
                                )
                            }
                            
                            // Draw the solid pixel
                            let rect = CGRect(
                                x: x - currentPixelSize / 2,
                                y: y - currentPixelSize / 2,
                                width: currentPixelSize,
                                height: currentPixelSize
                            )
                            
                            context.fill(
                                Path(rect),
                                with: .color(.white.opacity(opacity))
                            )
                        }
                    }
                }
            }
            .ignoresSafeArea()
 
             // Play / Stop button in the absolute geometric center (size remains same)
             Button(action: {
                 withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                     audioEngine.toggle()
                 }
             }) {
                 HStack(spacing: 8) {
                     Image(systemName: audioEngine.isPlaying ? "stop.fill" : "play.fill")
                         .font(.system(size: 14, weight: .bold))
                         .contentTransition(.symbolEffect(.replace))
 
                     Text(audioEngine.isPlaying ? "Stop" : "Play")
                         .font(.system(size: 14, weight: .bold, design: .rounded))
                 }
                 .foregroundColor(audioEngine.isPlaying ? .black : .white)
                 .padding(.horizontal, 24)
                 .padding(.vertical, 12)
                 .background(
                     Group {
                         if audioEngine.isPlaying {
                             Capsule()
                                 .fill(Color.white)
                         } else {
                             Capsule()
                                 .strokeBorder(Color.white, lineWidth: 1.5)
                                 .background(Capsule().fill(Color.black)) // prevent showing pixel grid lines under transparent button text
                         }
                     }
                 )
             }
            .buttonStyle(.plain)
        }
        .frame(width: 400, height: 400)
    }
}

#Preview {
    ContentView()
}
