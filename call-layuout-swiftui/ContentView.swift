import SwiftUI

struct ContentView: View {
    @State private var isPresentCall: Bool = false
    @State var callType: CallType = .voiceCall

    var body: some View {
        VStack {
            Text("Call layout using SwiftUI")
            HStack {
                Button(action: {
                    callType = .voiceCall
                    isPresentCall = true
                }) {
                    VStack {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                        Text("Voice Call")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                }
                .padding()

                Button(action: {
                    callType = .videoCall
                    isPresentCall = true
                }) {
                    VStack {
                        Image(systemName: "video.fill")
                            .font(.system(size: 50))
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
            }
        }
//        .fullScreenCover(isPresented: $isPresentCall) {
//            CallView(isPresented: $isPresentCall, callType: $callType)
//        }
    }
}

#Preview {
    ContentView()
}
