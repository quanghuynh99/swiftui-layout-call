import AVFoundation
import AVKit
import SwiftUI

struct CallView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel: CallViewModel
    @Binding var callType: CallType

    // Position for drag&drop
    @State private var translation = CGSize.zero
    @State private var lastTranslation = CGSize.zero

    init(isPresented: Binding<Bool>, callType: Binding<CallType>) {
        self._isPresented = isPresented
        self._viewModel = StateObject(wrappedValue: CallViewModel(callType: callType))
        self._callType = callType
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Callee video
            AvatarView(
                user: viewModel.callee, callState: "Calling...", size: .full, hasVideoActive: $viewModel.hasVideoActive
            )

            VStack {
                // Timer
                Text("Time: \(viewModel.formatTime())")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.top, 50)
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
                .padding(.bottom, 50)
            }
            .onAppear {
                viewModel.setupCallType(with: callType)
                viewModel.startTimer()
            }
            .onDisappear { viewModel.stopTimer() }

            // Caller video
            if viewModel.hasVideoActive {
                AvatarView(user: viewModel.caller, callState: "Calling", size: .window, hasVideoActive: $viewModel.hasVideoActive)
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
                    .offset(
                        x: lastTranslation.width + translation.width,
                        y: lastTranslation.height + translation.height
                    )
                    .padding(.trailing, 30)
                    .padding(.top, 100)
                    .gesture(dragGesture)
            }
        }
        .ignoresSafeArea()
    }

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                translation = value.translation
            }
            .onEnded { value in
                lastTranslation.width += value.translation.width
                lastTranslation.height += value.translation.height
                translation = .zero
            }
    }
}
