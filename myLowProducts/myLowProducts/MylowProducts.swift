//
//  MylowProducts.swift
//  MyApp
//
//  Created by Deese, Derrick on 7/9/26.
//

import SwiftUI
import SharedUI

@main
struct MyLowProductsApp: App {
    init() {
        FontRegistrar.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            HistoryCard(
                title: "Back Deck Stained",
                subtitle: "Applied Behr Premium Semi-Transparent Cedar stain. Photos and receipts attached.",
                badgeKind: .diy,
                showsAddedByIndicator: true,
                date: "Friday, Jun 12"
            )
        }
    }
}
