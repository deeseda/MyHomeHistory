//
//  ProductCardGroup.swift
//  myLowProducts
//
//  Created by Deese, Derrick on 7/10/26.
//

import SwiftUI

struct ProductCardGroup: View {
    var body: some View {
        
        VStack {
            HStack(spacing: 8) {
                
                ProductCard(
                    imageName: "hammer",
                    dollars: "42",
                    cents: "98",
                    originalPrice: "$49.98",
                    recommendation: "Best overall for framing a backyard shed.",
                    brand: "Estwing",
                    name: "28-oz Steel Head Steel Handle Framing hammer",
                    rating: "4.7",
                    reviewCount: "1.2k"
                )
                
                ProductCard(
                    imageName: "hammer",
                    dollars: "42",
                    cents: "98",
                    originalPrice: "$49.98",
                    recommendation: "Best value if you’re staying under $30.",
                    brand: "Estwing",
                    name: "28-oz Steel Head Steel Handle Framing hammer",
                    rating: "4.7",
                    reviewCount: "1.2k"
                )

            }
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 8) {
                
                ProductCard(
                    imageName: "hammer",
                    dollars: "42",
                    cents: "98",
                    originalPrice: "$49.98",
                    recommendation: "Lighter, easier to swing for longer projects.",
                    brand: "Estwing",
                    name: "28-oz Steel Head Steel Handle Framing hammer",
                    rating: "4.7",
                    reviewCount: "1.2k"
                )
                
                ProductCard(
                    imageName: "hammer",
                    dollars: "42",
                    cents: "98",
                    originalPrice: "$49.98",
                    recommendation: "Best overall for framing a backyard shed.",
                    brand: "Klein Tools",
                    name: "28-oz Steel Head Steel Handle Framing hammer",
                    rating: "4.7",
                    reviewCount: "1.2k"
                )

            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
    }
}

#Preview {
    ProductCardGroup()
}
