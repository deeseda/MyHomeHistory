//
//  HistoryCard.swift
//  myLowProducts
//
//  Created by Deese, Derrick on 7/15/26.
//

import SwiftUI
import SharedUI

struct HistoryCard: View {
    enum Media {
        case single(Image)
        case multi(images: [Image], remainingCount: Int? = nil)
    }

    var media: Media?
    var title: String
    var subtitle: String
    var badgeKind: HistoryBadge.Kind
    var showsAddedByIndicator: Bool
    var attachmentIcon: Image?
    var date: String
    var buttonTitle: String?
    var buttonAction: (() -> Void)?
    var mediaTapAction: (([Image], Int) -> Void)?

    init(
        image: Image? = nil,
        media: Media? = nil,
        title: String,
        subtitle: String,
        badgeKind: HistoryBadge.Kind,
        showsAddedByIndicator: Bool = false,
        attachmentIcon: Image? = nil,
        date: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil,
        mediaTapAction: (([Image], Int) -> Void)? = nil
    ) {
        self.media = media ?? image.map(Media.single)
        self.title = title
        self.subtitle = subtitle
        self.badgeKind = badgeKind
        self.showsAddedByIndicator = showsAddedByIndicator
        self.attachmentIcon = attachmentIcon
        self.date = date
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        self.mediaTapAction = mediaTapAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let media {
                headerMedia(media)
            }

            VStack(alignment: .leading, spacing: 8) {
                titleBlock
                metaRow
                divider
                dateLabel
            }

            if let buttonTitle {
                callToAction(title: buttonTitle)
            }
        }
        .padding(16)
        .background(AppColor.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    // MARK: - Header Media

    @ViewBuilder
    private func headerMedia(_ media: Media) -> some View {
        if let mediaTapAction {
            Button {
                mediaTapAction(media.images, 0)
            } label: {
                headerMediaContent(media)
            }
            .buttonStyle(.plain)
        } else {
            headerMediaContent(media)
        }
    }

    @ViewBuilder
    private func headerMediaContent(_ media: Media) -> some View {
        switch media {
        case .single(let image):
            mediaImage(image)
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

        case .multi(let images, let remainingCount):
            mediaGrid(images: images, remainingCount: remainingCount)
        }
    }

    private func mediaImage(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
    }

    private func mediaGrid(images: [Image], remainingCount: Int?) -> some View {
        let gridImages = Array(images.prefix(5))

        return GeometryReader { proxy in
            let height: CGFloat = 120
            let leftWidth = (proxy.size.width - 2) / 2
            let rightWidth = leftWidth
            let tileWidth = (rightWidth - 2) / 2
            let tileHeight = (height - 2) / 2

            HStack(spacing: 2) {
                if let firstImage = gridImages.first {
                    fixedMediaImage(firstImage, width: leftWidth, height: height)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 4,
                                bottomLeadingRadius: 4,
                                bottomTrailingRadius: 2,
                                topTrailingRadius: 2,
                                style: .continuous
                            )
                        )
                }

                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        gridTile(
                            at: 1,
                            in: gridImages,
                            width: tileWidth,
                            height: tileHeight
                        )
                        gridTile(
                            at: 2,
                            in: gridImages,
                            width: tileWidth,
                            height: tileHeight,
                            corners: .topTrailing
                        )
                    }

                    HStack(spacing: 2) {
                        gridTile(
                            at: 3,
                            in: gridImages,
                            width: tileWidth,
                            height: tileHeight
                        )
                        gridTile(
                            at: 4,
                            in: gridImages,
                            width: tileWidth,
                            height: tileHeight,
                            corners: .bottomTrailing
                        )
                            .overlay(alignment: .bottomTrailing) {
                                if let remainingCount, remainingCount > 0 {
                                    remainingBadge(count: remainingCount)
                                        .padding(2)
                                }
                            }
                    }
                }
                .frame(width: rightWidth, height: height)
            }
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    @ViewBuilder
    private func gridTile(
        at index: Int,
        in images: [Image],
        width: CGFloat,
        height: CGFloat,
        corners: GridTileCorners = []
    ) -> some View {
        if images.indices.contains(index) {
            fixedMediaImage(images[index], width: width, height: height)
                .clipShape(tileShape(for: corners))
        } else {
            Rectangle()
                .fill(AppColor.groupedBackgroundElevated)
                .frame(width: width, height: height)
                .clipShape(tileShape(for: corners))
        }
    }

    private func fixedMediaImage(_ image: Image, width: CGFloat, height: CGFloat) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
    }

    private func remainingBadge(count: Int) -> some View {
        Text("+\(count)")
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.white.opacity(0.3), in: tileShape(for: .bottomTrailing))
            .shadow(color: .black.opacity(0.02), radius: 10, x: 2, y: 4)
    }

    private func tileShape(for corners: GridTileCorners) -> UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: 2,
            bottomLeadingRadius: 2,
            bottomTrailingRadius: corners.contains(.bottomTrailing) ? 4 : 2,
            topTrailingRadius: corners.contains(.topTrailing) ? 4 : 2,
            style: .continuous
        )
    }

    // MARK: - Title & Subtitle

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppFont.callout)
                .fontWeight(.semibold)
                .foregroundStyle(AppColor.labelPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Text(subtitle)
                .font(AppFont.caption)
                .foregroundStyle(AppColor.labelSecondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }

    // MARK: - Meta Row

    private var metaRow: some View {
        HStack(alignment: .center) {
            HStack(spacing: 12) {
                HistoryBadge(kind: badgeKind)

                if showsAddedByIndicator {
                    addedBySection()
                }
            }

            Spacer(minLength: 8)

            if let attachmentIcon {
                attachmentIcon
                    .renderingMode(.template)
                    .font(.system(size: 14))
                    .foregroundStyle(AppColor.labelSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func addedBySection() -> some View {
        HStack(spacing: 4) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(AppColor.labelSecondary)

            Text("Added by you")
                .font(AppFont.caption)
                .foregroundStyle(AppColor.labelSecondary)
        }
    }

    // MARK: - Divider

    private var divider: some View {
        Rectangle()
            .fill(AppColor.borderSecondary)
            .frame(height: 0.5)
    }

    // MARK: - Date

    private var dateLabel: some View {
        Text(date)
            .font(AppFont.caption)
            .fontWeight(.semibold)
            .foregroundStyle(AppColor.labelPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)

    }

    // MARK: - CTA

    private func callToAction(title: String) -> some View {
        Button {
            buttonAction?()
        } label: {
            Text(title)
                .font(AppFont.subheadlineEmphasized)
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .background(
            Capsule(style: .continuous)
                .fill(Color(red: 0.463, green: 0.463, blue: 0.5).opacity(0.12))
        )
        .padding(.top, 4)
    }
}

#Preview {
    ScrollView {
        HistoryCard(
            title: "Added LG French Door Refrigerator",
            subtitle: "Purchased at Central Charlotte Lowe's",
            badgeKind: .lowes,
            attachmentIcon: Image(systemName: "paperclip"),
            date: "Monday, Jul 6",
            buttonTitle: "Add to a Space"
        )
        .padding()

        HistoryCard(
            image: Image("deck-1"),
            title: "Back Deck Stained",
            subtitle: "Applied Behr Premium Semi-Transparent Cedar stain. Photos and receipts attached.",
            badgeKind: .diy,
            showsAddedByIndicator: true,
            date: "Friday, Jun 12"
        )
        .padding(.horizontal)
    }
    .background(AppColor.groupedBackground)
}

private struct GridTileCorners: OptionSet {
    let rawValue: Int

    static let topTrailing = GridTileCorners(rawValue: 1 << 0)
    static let bottomTrailing = GridTileCorners(rawValue: 1 << 1)
}

private extension HistoryCard.Media {
    var images: [Image] {
        switch self {
        case .single(let image):
            return [image]
        case .multi(let images, _):
            return images
        }
    }
}
