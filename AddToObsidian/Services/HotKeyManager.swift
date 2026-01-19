import Foundation
import Carbon

class HotKeyManager {
    static let shared = HotKeyManager()

    private var hotKeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?
    private var callback: (() -> Void)?

    // Key code for 'O' key
    private let keyCode: UInt32 = 0x1F

    // Modifiers: Control + Option + Command
    private let modifiers: UInt32 = UInt32(cmdKey | optionKey | controlKey)

    private init() {}

    func register(callback: @escaping () -> Void) {
        self.callback = callback

        // Unregister any existing hotkey
        unregister()

        // Create hotkey ID
        var hotKeyID = EventHotKeyID()
        hotKeyID.signature = OSType(0x41544F42) // "ATOB" - AddToObsidian
        hotKeyID.id = 1

        // Install event handler
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))

        let handlerResult = InstallEventHandler(
            GetApplicationEventTarget(),
            { (_, event, userData) -> OSStatus in
                guard let userData = userData else { return OSStatus(eventNotHandledErr) }
                let manager = Unmanaged<HotKeyManager>.fromOpaque(userData).takeUnretainedValue()
                manager.handleHotKey()
                return noErr
            },
            1,
            &eventType,
            Unmanaged.passUnretained(self).toOpaque(),
            &eventHandler
        )

        guard handlerResult == noErr else {
            print("Failed to install event handler: \(handlerResult)")
            return
        }

        // Register the hotkey
        let registerResult = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        if registerResult != noErr {
            print("Failed to register hotkey: \(registerResult)")
        } else {
            print("Hotkey registered: Control + Option + Cmd + O")
        }
    }

    func unregister() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }

        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
    }

    private func handleHotKey() {
        DispatchQueue.main.async { [weak self] in
            self?.callback?()
        }
    }

    deinit {
        unregister()
    }
}
