import AVKit
import Foundation
import SwiftUI

enum AvatarSize: String {
    case full
    case window

    var rawValue: CGSize {
        switch self {
        case .full:
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        case .window:
            return CGSize(width: 112, height: 156)
        }
    }
}

struct AvatarView: View {
    @State var user: UserEntity
    @State var callState: String
    @State var size: AvatarSize
    @Binding var hasVideoActive: Bool

    // Mock data
    private let player: AVPlayer = {
        guard let url = URL(string: "https://www.w3schools.com/html/mov_bbb.mp4") else { fatalError("Invalid video URL") }
        let player = AVPlayer(url: url)
        player.play()
        player.isMuted = true
        return player
    }()

    var body: some View {
        ZStack {
            // Background Video - Active
            if hasVideoActive {
                VideoPlayerView(player: player)
            }

            // Background Video - Inactive
            // Background Image
            if !hasVideoActive {
                AsyncImage(url: user.avatar, content: { image in
                    image.resizable()
                }, placeholder: {
                    ProgressView()
                })
                .blur(radius: 50)
                .frame(width: size.rawValue.width, height: size.rawValue.height)
                .cornerRadius(14)
                .clipShape(.rect(cornerRadius: 15))
                .background(.ultraThinMaterial)

                // Avatar/ display name/ call state
                VStack {
                    AsyncImage(url: user.avatar, content: { image in
                        image.resizable()
                    }, placeholder: {
                        ProgressView()
                    })
                    .frame(width: 56, height: 56)
                    .clipShape(.circle)

                    if size == .full {
                        Text(user.displayableName)
                            .font(Font.system(size: 20, weight: .bold))
                        Text(callState)
                            .font(Font.system(size: 14))
                    }
                }
            }
        }
    }
}

// MARK: Test trach videoViewController

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)

        // Observe frame changes
        view.addObserver(context.coordinator, forKeyPath: "bounds", options: [.new], context: nil)
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer else { return }
        playerLayer.frame = uiView.bounds
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "bounds", let view = object as? UIView {
                view.layer.sublayers?.forEach { layer in
                    if let playerLayer = layer as? AVPlayerLayer {
                        playerLayer.frame = view.bounds
                    }
                }
            }
        }
    }
}
