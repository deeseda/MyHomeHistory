//
//  HistoryCard.swift
//  myLowProducts
//
//  Created by Deese, Derrick on 7/15/26.
//

import SwiftUI
import SharedUI

struct HistoryCard: View {
    var image: Image?
    var title: String
    var subtitle: String
    var badgeKind: HistoryBadge.Kind
    var showsAddedByIndicator: Bool
    var attachmentIcon: Image?
    var date: String
    var buttonTitle: String?
    var buttonAction: (() -> Void)?

    init(
        image: Image? = nil,
        title: String,
        subtitle: String,
        badgeKind: HistoryBadge.Kind,
        showsAddedByIndicator: Bool = false,
        attachmentIcon: Image? = nil,
        date: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.badgeKind = badgeKind
        self.showsAddedByIndicator = showsAddedByIndicator
        self.attachmentIcon = attachmentIcon
        self.date = date
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let image {
                headerImage(image)
            }

            VStack(alignment: .leading, spacing: 12) {
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
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }

    // MARK: - Header Image

    @ViewBuilder
    private func headerImage(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }

    // MARK: - Title & Subtitle

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppFont.body.weight(.semibold))
                .foregroundStyle(AppColor.labelPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Text(subtitle)
                .font(AppFont.caption)
                .foregroundStyle(AppColor.labelPrimary)
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
            .foregroundStyle(AppColor.labelSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)

    }

    // MARK: - CTA

    private func callToAction(title: String) -> some View {
        Button {
            buttonAction?()
        } label: {
            Text(title)
                .font(AppFont.subheadline)
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
            image: Image("deck-1"),
            title: "Added LG French Door Refrigerator",
            subtitle: "Purchased at Central Charlotte Lowe's",
            badgeKind: .lowes,
            attachmentIcon: Image(systemName: "paperclip"),
            date: "Monday, Jul 6",
            buttonTitle: "Add to a Space"
        )
        .padding()

        HistoryCard(
            title: "Back Deck Stained",
            subtitle: "Applied Behr Premium Semi-Transparent Cedar stain. Photos and receipts attached.",
            badgeKind: .diy,
            showsAddedByIndicator: true,
            date: "Friday, Jun 12"
        )
        .padding(.horizontal)
    }
    .background(Color(.systemGroupedBackground))
}
