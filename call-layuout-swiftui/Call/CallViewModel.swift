import Combine
import Foundation
import SwiftUI

enum CallType {
    case voiceCall
    case videoCall
}

class CallViewModel: ObservableObject {
    @Published var elapsedTime: Int = 0
    @Published var hasSpeakerActive: Bool = false
    @Published var hasVideoActive: Bool = false
    @Published var hasMicrophoneActive: Bool = true
    @Binding var callType: CallType

    private var timer: Timer? = nil

    init(callType: Binding<CallType>) {
        self._callType = callType
        configureForCallType()
    }

    func setupCallType(with callType: CallType) {
        self.callType = callType
        configureForCallType()
    }

    private func configureForCallType() {
        hasSpeakerActive = callType == .videoCall
        hasVideoActive = callType == .videoCall
        hasMicrophoneActive = true
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func toggleSpeaker() {
        hasSpeakerActive.toggle()
        // actions..
    }

    func toggleVideo() {
        hasVideoActive.toggle()
        // actions..
    }

    func toggleMicrophone() {
        hasMicrophoneActive.toggle()
        // actions..
    }

    func formatTime() -> String {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
