import Foundation

public struct WidgetStateBridge {
    private static let appGroup = "group.com.ambigen.AmbientGen"
    private static let playingKey = "isPlaying"

    public static func getIsPlaying() -> Bool {
        guard let defaults = UserDefaults(suiteName: appGroup) else {
            return false
        }
        return defaults.bool(forKey: playingKey)
    }

    public static func setIsPlaying(_ isPlaying: Bool) {
        guard let defaults = UserDefaults(suiteName: appGroup) else {
            return
        }
        defaults.set(isPlaying, forKey: playingKey)
    }
}
