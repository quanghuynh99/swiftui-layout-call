import SwiftUI

struct ContentView: View {
    @State private var isPresentCall: Bool = false
    @State var callType: CallType = .voiceCall

    var body: some View {
        NavigationView {
            VStack {
                Text("Call layout using SwiftUI")
                HStack {
                    NavigationLink(destination: CallView(callType: $callType), label: {
                        VStack {
                            Image(systemName: "phone.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.green)
                            Text("Voice Call")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    })
                    .simultaneousGesture(TapGesture().onEnded {
                        callType = .voiceCall
                    })

                    NavigationLink(destination: CallView(callType: $callType)) {
                        VStack {
                            Image(systemName: "video.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                            Text("Video Call")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        callType = .videoCall
                    })
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
