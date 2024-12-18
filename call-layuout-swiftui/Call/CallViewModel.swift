import Combine
import Foundation
import SwiftUI

enum CallType {
    case voiceCall
    case videoCall
}

class UserEntity {
    let displayableName: String
    let avatar: URL?

    init(displayableName: String, avatar: URL?) {
        self.displayableName = displayableName
        self.avatar = avatar
    }
}

class CallViewModel: ObservableObject {
    @Published var elapsedTime: Int = 0
    @Published var hasSpeakerActive: Bool = false
    @Published var hasVideoActive: Bool = false
    @Published var hasMicrophoneActive: Bool = true
    @Binding var callType: CallType

    /*
     Mock data
     */
    @Published var caller: UserEntity = .init(
        displayableName: "Caller displayableName",
        avatar: URL(string: "https://images.pexels.com/photos/816608/pexels-photo-816608.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")
    )
    @Published var callee: UserEntity = .init(
        displayableName: "Callee displayableName",
        avatar: URL(string: "https://images3.boardingschoolreview.com/photo/593/IMG-Academy-6r5kz9j4u144kso44sw8800k0-1122.webp")
    )

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
        let hours = elapsedTime / 3600
        let minutes = (elapsedTime % 3600) / 60
        let seconds = elapsedTime % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
