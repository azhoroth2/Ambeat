import SwiftUI

struct ContentView: View {
    @State private var audioEngine = AudioEngine()

    var body: some View {
        ZStack {
            // Minimalist solid black background
            Color.black
                .ignoresSafeArea()

            // Subtle white pixel-art mandala
            Canvas { context, size in
                let centerX = size.width / 2.0
                let centerY = size.height / 2.0
                
                // Evaluate the positive quadrant and mirror to all 4 quadrants
                for dx in 0...100 {
                    for dy in 0...100 {
                        if isMandalaPixel(dx: dx, dy: dy) {
                            let points = [
                                CGPoint(x: centerX + Double(dx) * 2.0, y: centerY + Double(dy) * 2.0),
                                CGPoint(x: centerX - Double(dx) * 2.0, y: centerY + Double(dy) * 2.0),
                                CGPoint(x: centerX + Double(dx) * 2.0, y: centerY - Double(dy) * 2.0),
                                CGPoint(x: centerX - Double(dx) * 2.0, y: centerY - Double(dy) * 2.0)
                            ]
                            
                            for pt in points {
                                // Draw a 2x2 real pixel square (1x1 in the 200x200 grid)
                                let rect = CGRect(x: pt.x - 1.0, y: pt.y - 1.0, width: 2.0, height: 2.0)
                                context.fill(Path(rect), with: .color(.white.opacity(0.12)))
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()

            // Play / Stop button centered
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
                                .background(Capsule().fill(Color.black)) // prevent showing mandala lines under transparent button text
                        }
                    }
                )
            }
            .buttonStyle(.plain)
        }
        .frame(width: 400, height: 400)
    }

    /// Mathematical function defining if a cell in the 200x200 grid belongs to the mandala
    private func isMandalaPixel(dx: Int, dy: Int) -> Bool {
        let adx = abs(dx)
        let ady = abs(dy)
        let r = sqrt(Double(dx*dx + dy*dy))
        let ir = Int(round(r))
        let l1 = adx + ady

        // Center hub
        if ir < 5 {
            return false
        }
        
        // Concentric circles
        let circles = [10, 24, 40, 56, 72, 88]
        if circles.contains(ir) {
            return true
        }

        // Concentric diamonds
        let diamonds = [16, 32, 48, 64, 80, 96]
        if diamonds.contains(l1) {
            return true
        }

        // 8-Spoke radial lines (dotted pattern)
        if adx == ady || dx == 0 || dy == 0 {
            if ir > 8 && ir < 98 && (ir % 3 == 0) {
                return true
            }
        }
        
        // Circular sub-elements centered on the 45-degree axes and major axes (distance 50)
        let ax = 35
        let ay = 35
        let subCenters = [
            (ax, ay), (-ax, ay), (ax, -ay), (-ax, -ay),
            (50, 0), (-50, 0), (0, 50), (0, -50)
        ]
        for (cx, cy) in subCenters {
            let dist = sqrt(Double((dx - cx) * (dx - cx) + (dy - cy) * (dy - cy)))
            let idist = Int(round(dist))
            if idist == 12 {
                return true
            }
        }
        
        // Outer wavy border (16 lobes)
        let angle = atan2(Double(dy), Double(dx))
        let waveR = 95.0 + 3.0 * cos(angle * 16.0)
        if abs(r - waveR) < 0.6 {
            return true
        }

        return false
    }
}

#Preview {
    ContentView()
}
