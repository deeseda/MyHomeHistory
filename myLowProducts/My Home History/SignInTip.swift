import SwiftUI
import SharedUI
import TipKit

@available(iOS 17.0, *)
struct RewardsPromoTip: Tip {
    var title: Text {
        Text("Members get more at Lowe’s.")
    }
    
    var message: Text?
    { Text("You could be earning up to 925 points.")
    }

}

@available(iOS 17.0, *)
struct RewardsPromoTipViewStyle: TipViewStyle {
    let onDismiss: () -> Void
    let onSignIn: () -> Void

    func makeBody(configuration: Configuration) -> some View {
        RewardsPromoBannerCard(
            title: configuration.title,
            message: configuration.message,
            onDismiss: onDismiss,
            onSignIn: onSignIn
        )
    }
}

struct RewardsPromoBannerCard: View {
    let title: Text?
    let message: Text?
    let onDismiss: () -> Void
    let onSignIn: () -> Void

    private let pms286 = Color(red: 0 / 255, green: 51 / 255, blue: 161 / 255)
    private let pms285 = Color(red: 0 / 255, green: 113 / 255, blue: 206 / 255)
    private let pms299 = Color(red: 0 / 255, green: 163 / 255, blue: 224 / 255)
    private let pms291 = Color(red: 155 / 255, green: 203 / 255, blue: 235 / 255)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: pms286, location: 0.00),
                            .init(color: pms285, location: 0.35),
                            .init(color: pms299, location: 0.80),
                            .init(color: pms291, location: 1.00)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top, spacing: 12) {
                    Image("MLR")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 24)
                        .accessibilityHidden(true)
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 2) {
                        if let title {
                            title
                                .font(AppFont.headline)
                                .foregroundStyle(.white)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let message {
                            message
                                .font(AppFont.subheadline)
                                .foregroundStyle(.white)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    Spacer(minLength: 0)
                }

                HStack(spacing: 16) {
                    Button(action: onDismiss) {
                        Text("Dismiss")
                            .font(AppFont.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(AppColor.backgroundPrimary)
                            .foregroundStyle(AppColor.brandBlue)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)

                    Button(action: onSignIn) {
                        Text("Sign in")
                            .font(AppFont.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(AppColor.brandBlue)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .frame(height: 136)
        .padding(.horizontal, 16)
    }
}

@available(iOS 17.0, *)
struct RewardsPromoPreviewHost: View {
    var body: some View {
        VStack(spacing: 24) {
            RewardsPromoBannerCard(
                title: Text("Members get more at Lowe’s."),
                message: Text("You could be earning up to 925 points."),
                onDismiss: {},
                onSignIn: {}
            )

            TipView(RewardsPromoTip())
                .tipViewStyle(
                    RewardsPromoTipViewStyle(
                        onDismiss: {},
                        onSignIn: {}
                    )
                )
        }
        .padding(.vertical, 24)
        .background(AppColor.borderSecondary)
    }
}

@available(iOS 17.0, *)
#Preview("Rewards Promo Banner") {
    RewardsPromoPreviewHost()
}
