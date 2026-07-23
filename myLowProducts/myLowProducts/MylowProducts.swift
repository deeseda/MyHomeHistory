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
            AlternateDeliveryContactDemo()
        }
    }
}
