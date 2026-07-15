//
//  HomeHistorySheet.swift
//  myLowProducts
//
//  Created by Cascade on 7/15/26.
//

import SwiftUI
import SharedUI

struct HomeHistorySheet: View {
    struct Entry: Identifiable {
        let id = UUID()
        var image: Image?
        var title: String
        var subtitle: String
        var badgeKind: HistoryBadge.Kind
        var showsAddedByIndicator: Bool
        var attachmentIcon: Image?
        var dateLabel: String
        var buttonTitle: String?
    }

    struct Section: Identifiable {
        let id = UUID()
        var monthAnchor: Date
        var entries: [Entry]
    }

    private let sheetCornerRadius: CGFloat = 38
    private let calendar = Calendar(identifier: .gregorian)

    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.setLocalizedDateFormatFromTemplate("LLLL")
        return formatter
    }()
    private static let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.setLocalizedDateFormatFromTemplate("LLLL yyyy")
        return formatter
    }()

    var sections: [Section]

    init(sections: [Section] = Self.sampleSections) {
        self.sections = sections
    }

    var body: some View {
        VStack(spacing: 0) {
            grabber
            toolbar
            header
            sectionList
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(.systemGray6)
                .clipShape(RoundedRectangle(cornerRadius: sheetCornerRadius, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: sheetCornerRadius, style: .continuous)
                .strokeBorder(Color.black.opacity(0.02))
        )
        .shadow(color: Color.black.opacity(0.18), radius: 30, x: 0, y: 15)
    }

    private var grabber: some View {
        Capsule(style: .continuous)
            .fill(Color.white.opacity(0.8))
            .frame(width: 38, height: 4)
            .padding(.top, 12)
    }

    private var toolbar: some View {
        HStack {
            toolbarButton(systemName: "chevron.backward")
            Spacer()
            HStack(spacing: 12) {
                toolbarButton(systemName: "magnifyingglass")
                toolbarButton(systemName: "ellipsis")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    private func toolbarButton(systemName: String) -> some View {
        Button {}
        label: {
            Image(systemName: systemName)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppColor.labelPrimary)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.12), radius: 15, x: 0, y: 10)
                )
        }
        .buttonStyle(.plain)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("My Home History")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(AppColor.labelPrimary)
                .tracking(0.4)

            Text("The complete history of your home.")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(AppColor.labelSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private var sectionList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                ForEach(sortedSections) { section in
                    VStack(alignment: .leading, spacing: 8) {
                        sectionHeader(for: section.monthAnchor)

                        VStack(spacing: 12) {
                            ForEach(section.entries) { entry in
                                HistoryCard(
                                    image: entry.image,
                                    title: entry.title,
                                    subtitle: entry.subtitle,
                                    badgeKind: entry.badgeKind,
                                    showsAddedByIndicator: entry.showsAddedByIndicator,
                                    attachmentIcon: entry.attachmentIcon,
                                    date: entry.dateLabel,
                                    buttonTitle: entry.buttonTitle
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
    }

    private func sectionHeader(for date: Date) -> some View {
        let title = sectionTitle(for: date)
        return Text(title)
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(AppColor.labelPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func sectionTitle(for date: Date) -> String {
        let sectionYear = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: Date())
        if sectionYear == currentYear {
            return Self.monthFormatter.string(from: date)
        } else {
            return Self.monthYearFormatter.string(from: date)
        }
    }
}

// MARK: - Sample Data

extension HomeHistorySheet {
    private var sortedSections: [Section] {
        sections.sorted { $0.monthAnchor > $1.monthAnchor }
    }

    private static func makeDate(year: Int, month: Int, day: Int = 1) -> Date {
        Calendar(identifier: .gregorian).date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }

    private static var sampleSections: [Section] {
        let july = Section(
            monthAnchor: makeDate(year: 2026, month: 7),
            entries: [
                Entry(
                    image: Image("deck-1"),
                    title: "Added LG French Door Refrigerator",
                    subtitle: "Purchased at Central Charlotte Lowe's",
                    badgeKind: .lowes,
                    showsAddedByIndicator: false,
                    attachmentIcon: Image(systemName: "paperclip"),
                    dateLabel: "Monday, Jul 6",
                    buttonTitle: "Add to a Space"
                )
            ]
        )

        let june = Section(
            monthAnchor: makeDate(year: 2026, month: 6),
            entries: [
                Entry(
                    title: "HomeCare+ Visit Completed",
                    subtitle: "Completed by Phillip K.",
                    badgeKind: .lowes,
                    showsAddedByIndicator: false,
                    attachmentIcon: nil,
                    dateLabel: "Friday, Jun 12",
                    buttonTitle: nil
                ),
                Entry(
                    image: Image("deck-1"),
                    title: "Back Deck Stained",
                    subtitle: "Applied Behr Premium Semi-Transparent Cedar stain. Photos and receipt attached.",
                    badgeKind: .diy,
                    showsAddedByIndicator: true,
                    attachmentIcon: nil,
                    dateLabel: "Friday, Jun 12",
                    buttonTitle: nil
                )
            ]
        )

        let january = Section(
            monthAnchor: makeDate(year: 2026, month: 1),
            entries: [
                Entry(
                    title: "Annual Roof Inspection",
                    subtitle: "No damage found. Roof estimated to have 12–15 years of remaining life.",
                    badgeKind: .pro,
                    showsAddedByIndicator: false,
                    attachmentIcon: nil,
                    dateLabel: "Friday, Jan 23",
                    buttonTitle: nil
                )
            ]
        )

        let november = Section(
            monthAnchor: makeDate(year: 2025, month: 11),
            entries: [
                Entry(
                    title: "Replaced upstairs HVAC",
                    subtitle: "High-efficiency Lennox unit installed by Blue Ridge Heating.",
                    badgeKind: .pro,
                    showsAddedByIndicator: false,
                    attachmentIcon: Image(systemName: "paperclip"),
                    dateLabel: "Tuesday, Nov 18, 2025",
                    buttonTitle: nil
                )
            ]
        )

        let august = Section(
            monthAnchor: makeDate(year: 2025, month: 8),
            entries: [
                Entry(
                    title: "Inspection Report",
                    subtitle: "Uploaded inspection report with recommended fixes.",
                    badgeKind: .records,
                    showsAddedByIndicator: false,
                    attachmentIcon: Image(systemName: "paperclip"),
                    dateLabel: "Friday, Aug 1, 2025",
                    buttonTitle: nil
                )
            ]
        )

        return [july, june, january, november, august]
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.white, Color(.systemGray5)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

        HomeHistorySheet()
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
    }
}
