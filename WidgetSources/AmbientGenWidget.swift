import WidgetKit
import SwiftUI
import AppIntents

struct SimpleEntry: TimelineEntry {
    let date: Date
    let isPlaying: Bool
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), isPlaying: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), isPlaying: WidgetStateBridge.getIsPlaying())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date(), isPlaying: WidgetStateBridge.getIsPlaying())
        let timeline = Timeline(entries: [entry], policy: .never) // Update on demand
        completion(timeline)
    }
}

struct AmbientGenWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            // Widget background
            Color.black
            
            // Stylized background glow / accent
            if entry.isPlaying {
                RadialGradient(
                    colors: [Color.white.opacity(0.12), Color.clear],
                    center: .center,
                    startRadius: 5,
                    endRadius: 75
                )
            }
            
            VStack(spacing: 8) {
                // Waveform visualization (simulated)
                HStack(spacing: 3) {
                    if entry.isPlaying {
                        ForEach(0..<9) { index in
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.white.opacity(0.85))
                                .frame(width: 3.5, height: waveHeight(for: index))
                        }
                    } else {
                        ForEach(0..<9) { index in
                            Circle()
                                .fill(Color.white.opacity(0.20))
                                .frame(width: 3.5, height: 3.5)
                        }
                    }
                }
                .frame(height: 36)
                .animation(.spring(response: 0.35, dampingFraction: 0.65), value: entry.isPlaying)
                
                // Play / Stop button
                Button(intent: TogglePlaybackIntent()) {
                    Image(systemName: entry.isPlaying ? "stop.fill" : "play.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(entry.isPlaying ? .black : .white)
                        .frame(width: 34, height: 34)
                        .background(
                            Group {
                                if entry.isPlaying {
                                    Circle().fill(Color.white)
                                } else {
                                    Circle()
                                        .strokeBorder(Color.white, lineWidth: 1.5)
                                        .background(Circle().fill(Color.black))
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(12)
        }
    }
    
    // Generates a mock wave pattern height
    private func waveHeight(for index: Int) -> CGFloat {
        let values: [CGFloat] = [10, 22, 16, 28, 20, 26, 12, 18, 8]
        return values[index % values.count]
    }
}

@main
struct AmbientGenWidget: Widget {
    let kind: String = "AmbientGenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AmbientGenWidgetEntryView(entry: entry)
                .containerBackground(.black, for: .widget)
        }
        .configurationDisplayName("AmbientGen")
        .description("Control your ambient soundscape from your desktop.")
        .supportedFamilies([.systemSmall])
    }
}
