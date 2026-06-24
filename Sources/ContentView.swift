import SwiftUI

struct ContentView: View {
    @State private var audioEngine = AudioEngine()

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hue: 0.72, saturation: 0.35, brightness: 0.12),
                    Color(hue: 0.75, saturation: 0.45, brightness: 0.08),
                    Color(hue: 0.80, saturation: 0.30, brightness: 0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                // Title & Icon
                VStack(spacing: 8) {
                    Text("🎧")
                        .font(.system(size: 36))
                        .shadow(color: Color.cyan.opacity(0.3), radius: 10)

                    Text("AmbientGen")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("8 Hz Alpha Binaural Beat + Lo-Fi Pad")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.45))
                }

                // Play / Stop button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        audioEngine.toggle()
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: audioEngine.isPlaying ? "stop.fill" : "play.fill")
                            .font(.system(size: 15, weight: .bold))
                            .contentTransition(.symbolEffect(.replace))

                        Text(audioEngine.isPlaying ? "Stop" : "Play")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(
                                audioEngine.isPlaying
                                    ? AnyShapeStyle(Color(hue: 0.0, saturation: 0.5, brightness: 0.45))
                                    : AnyShapeStyle(
                                        LinearGradient(
                                            colors: [
                                                Color(hue: 0.55, saturation: 0.6, brightness: 0.5),
                                                Color(hue: 0.6, saturation: 0.7, brightness: 0.4)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    )
                    .shadow(
                        color: audioEngine.isPlaying
                            ? Color.red.opacity(0.2)
                            : Color.cyan.opacity(0.25),
                        radius: 14, y: 5
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(24)
        }
        .frame(width: 360, height: 260)
    }
}

#Preview {
    ContentView()
}
