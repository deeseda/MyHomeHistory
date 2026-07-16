//
//  MyHomeHistory.swift
//  myLowProducts
//
//  Created by Deese, Derrick on 7/15/26.
//

import SwiftUI
import SharedUI


struct MyHomeHistory: View {

    @Environment(\.dismiss) private var dismiss
    @State private var sortOption = PrototypeHistorySortOption.entryDate
    @State private var filterOption = PrototypeHistoryFilterOption.all

    var body: some View {
        content
            .navigationTitle("My Home History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    historyOptionsMenu
                }

            }
    }

    private var historyOptionsMenu: some View {
        Menu {
            Menu {
                ForEach(PrototypeHistorySortOption.allCases) { option in
                    Button {
                        sortOption = option
                    } label: {
                        selectedMenuLabel(option.title, isSelected: sortOption == option)
                    }
                }
            } label: {
                menuLabel(title: "Sort by", subtitle: sortOption.title, systemImage: "arrow.up.arrow.down")
            }

            Menu {
                ForEach(PrototypeHistoryFilterOption.allCases) { option in
                    Button {
                        filterOption = option
                    } label: {
                        selectedMenuLabel(option.title, isSelected: filterOption == option)
                    }
                }
            } label: {
                menuLabel(title: "Filter by", subtitle: filterOption.title, systemImage: "line.3.horizontal.decrease")
            }

            Button("Select Entries", systemImage: "checkmark.circle") {}

            Divider()

            ShareLink(item: "My Home History") {
                Label("Export", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "ellipsis")
        }
    }

    private func menuLabel(title: String, subtitle: String, systemImage: String) -> some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: systemImage)
        }
    }

    @ViewBuilder
    private func selectedMenuLabel(_ title: String, isSelected: Bool) -> some View {
        if isSelected {
            Label(title, systemImage: "checkmark")
        } else {
            Text(title)
        }
    }

    private var content: some View {
        ScrollView {

            HistoryCard(
                media: .single(Image("deck-1")),
                title: "Added LG French Door Refrigerator",
                subtitle: "Purchased at Central Charlotte Lowe's",
                badgeKind: .lowes,
                attachmentIcon: Image(systemName: "paperclip"),
                date: "Monday, Jul 6",
                buttonTitle: "Add to a Space"
            )

            HistoryCard(
                media: .multi(
                    images: [
                        Image("deck-1"),
                        Image("deck-2"),
                        Image("deck-3"),
                        Image("deck-4"),
                        Image("deck-5")
                    ],
                    remainingCount: 2
                ),
                title: "Back Deck Stained",
                subtitle: "Applied Behr Premium Semi-Transparent Cedar stain. Photos and receipts attached.",
                badgeKind: .diy,
                showsAddedByIndicator: true,
                date: "Friday, Jun 12"
            )

        }
    }

}

private enum PrototypeHistorySortOption: String, CaseIterable, Identifiable {
    case entryDate
    case category

    var id: Self { self }

    var title: String {
        switch self {
        case .entryDate: return "Entry Date"
        case .category: return "Category"
        }
    }
}

private enum PrototypeHistoryFilterOption: String, CaseIterable, Identifiable {
    case all
    case lowes
    case diy
    case pro
    case records
    case insights

    var id: Self { self }

    var title: String {
        switch self {
        case .all: return "All"
        case .lowes: return "Lowe's"
        case .diy: return "DIY"
        case .pro: return "Pro"
        case .records: return "County Records"
        case .insights: return "Home Insights"
        }
    }
}

#Preview {

    MyHomeHistory()

}
