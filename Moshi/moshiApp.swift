// Copyright (c) Kyutai, all rights reserved.
// This source code is licensed under the license found in the
// LICENSE file in the root directory of this source tree.

import AVFoundation
import Foundation
import SwiftUI

func requestMicrophoneAccess() {
    switch AVCaptureDevice.authorizationStatus(for: .audio) {
    case .authorized:
        return
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            print("granted", granted)
        }
    case .denied:  // The user has previously denied access.
        return
    case .restricted:  // The user can't grant access due to restrictions.
        return
    case _:
        return
    }
}

func setDefaultToSpeaker() {
    #if os(iOS)
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            try audioSession.overrideOutputAudioPort(.speaker)
        } catch {
            print("failed to configure audio session: \(error.localizedDescription)")
        }
    #endif
}

@main
struct moshiApp: App {
    init() {
        requestMicrophoneAccess()
        setDefaultToSpeaker()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(DeviceStat())
        }
    }
}
