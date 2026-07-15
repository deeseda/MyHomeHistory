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

    var body: some View {

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

            HistoryCard(
                title: "Back Deck Stained",
                subtitle: "Applied Behr Premium Semi-Transparent Cedar stain. Photos and receipts attached.",
                badgeKind: .diy,
                showsAddedByIndicator: true,
                date: "Friday, Jun 12"
            )

        }

        .navigationTitle("My Home History")

        .navigationBarTitleDisplayMode(.inline)

        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }

            }

            ToolbarItemGroup(placement: .topBarTrailing) {

                Button {
                } label: {
                    Image(systemName: "magnifyingglass")
                }

                Button {
                } label: {
                    Image(systemName: "ellipsis")
                }

            }

        }

    }

}

#Preview {

    MyHomeHistory()

}
