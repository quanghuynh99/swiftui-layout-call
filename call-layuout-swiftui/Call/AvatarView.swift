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

    var body: some View {
        ZStack {
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
            .frame(width: size.rawValue.width, height: size.rawValue.height)
            .background(Color.clear)
            .padding()
        }
    }
}
