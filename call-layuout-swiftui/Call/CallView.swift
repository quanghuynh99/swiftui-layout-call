import AVFoundation
import AVKit
import SwiftUI

struct CallView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel: CallViewModel
    @Binding var callType: CallType

    init(isPresented: Binding<Bool>, callType: Binding<CallType>) {
        self._isPresented = isPresented
        self._viewModel = StateObject(wrappedValue: CallViewModel(callType: callType))
        self._callType = callType
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                // Title
                Text(callType == .voiceCall ? "Voice Call" : "Video Call")
                    .font(.largeTitle)
                    .bold()
                // Timer
                Text("Time: \(viewModel.formatTime())")
                    .font(.title3)
                    .foregroundColor(.gray)
                Spacer()

                // Bottom bar buttons
                HStack {
                    Spacer()
                    Button(action: {
                        // Actions
                        viewModel.toggleSpeaker()
                    }) {
                        VStack {
                            Image(systemName: viewModel.hasSpeakerActive ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                .frame(width: 50, height: 50)
                                .background(viewModel.hasSpeakerActive ? Color.white : Color.gray)
                                .tint(Color.black)
                                .cornerRadius(25)
                                .padding(0)
                            Text(viewModel.hasSpeakerActive ? "Out" : "In")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .frame(maxWidth: 70)

                    Spacer()
                    Button(action: {
                        // Actions
                        viewModel.toggleVideo()
                    }) {
                        VStack {
                            Image(systemName: viewModel.hasVideoActive ? "video.fill" : "video.slash.fill")
                                .frame(width: 50, height: 50)
                                .background(viewModel.hasVideoActive ? Color.white : Color.gray)
                                .tint(Color.black)
                                .cornerRadius(25)
                                .padding(0)
                            Text("Camera")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .frame(maxWidth: 70)

                    Spacer()
                    Button(action: {
                        // Actions
                        viewModel.toggleMicrophone()
                    }) {
                        VStack {
                            Image(systemName: viewModel.hasMicrophoneActive ? "mic.fill" : "mic.slash.fill")
                                .frame(width: 50, height: 50)
                                .background(viewModel.hasMicrophoneActive ? Color.white : Color.gray)
                                .tint(Color.black)
                                .cornerRadius(25)
                                .padding(0)
                            Text(viewModel.hasMicrophoneActive ? "Mute" : "Unmute")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .frame(maxWidth: 70)

                    Spacer()
                    Button(action: {
                        // End call
                        isPresented = false
                    }) {
                        VStack {
                            Image(systemName: "phone.down.fill")
                                .frame(width: 50, height: 50)
                                .background(Color.red)
                                .tint(Color.white)
                                .cornerRadius(25)
                                .padding(0)
                            Text("End call")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .frame(maxWidth: 70)
                    Spacer()
                }
            }
            .background(
                callType == .voiceCall ? Color.green.opacity(0.2) : Color.blue.opacity(0.2)
            )
            .onAppear {
                viewModel.setupCallType(with: callType)
                viewModel.startTimer()
            }
            .onDisappear { viewModel.stopTimer() }

            // Video Node
            if callType == .videoCall {
                VideoPlayerView()
                    .frame(width: 100, height: 150)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.trailing, 30)
                    .padding(.top, 70)
            }
        }
    }
}

struct VideoPlayerView: View {
    var body: some View {
        VStack {
            //
        }
    }
}
