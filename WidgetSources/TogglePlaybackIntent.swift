import AppIntents
import Foundation

public struct TogglePlaybackIntent: AppIntent {
    public static var title: LocalizedStringResource = "Toggle Playback"
    public static var description = IntentDescription("Toggles play/stop state of AmbientGen.")

    public init() {}

    public func perform() async throws -> some IntentResult {
        // Toggle the playing status in App Group defaults
        let currentlyPlaying = WidgetStateBridge.getIsPlaying()
        WidgetStateBridge.setIsPlaying(!currentlyPlaying)
        
        // Post a Distributed Notification to the main app to handle the state toggle
        DistributedNotificationCenter.default().postNotificationName(
            NSNotification.Name("com.ambigen.AmbientGen.toggle"),
            object: nil,
            userInfo: nil,
            deliverImmediately: true
        )
        
        return .result()
    }
}
