//
//  ProductCard.swift
//  myLowProducts
//
//  Created by Deese, Derrick on 7/9/26.
//

import SwiftUI
import SharedUI


struct ProductCard: View {

    var imageName: String?
    var dollars: String
    var cents: String
    var originalPrice: String
    var recommendation: String
    var brand: String
    var name: String
    var rating: String
    var reviewCount: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            thumbnail

            VStack(alignment: .leading, spacing: 4) {
                priceRow
                Mylow
                productName
                ratingRow
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(8)
        .background(AppColor.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .topTrailing) {
            addToCartButton
        }
        .frame(maxWidth: .infinity)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)

    }

    // MARK: - Thumbnail

    private var thumbnail: some View {
        Group {
            if let imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "hammer.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(AppColor.labelSecondary)
            }
        }
        .frame(width: 100, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Price

    private var priceRow: some View {
        HStack(alignment: .bottom, spacing: 4) {
            HStack(alignment: .top, spacing: 1) {
                Text("$")
                    .font(AppFont.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColor.labelPrimary)
                    .padding(.top, 4)
                    .padding(.bottom, 2)
                Text(dollars)
                    .font(AppFont.displayTitle)
                    .tracking(0.36)
                    .foregroundStyle(AppColor.labelPrimary)
                Text(cents)
                    .font(AppFont.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColor.labelPrimary)
                    .padding(.top, 4)
                    .padding(.bottom, 2)
            }

            Text(originalPrice)
                .font(AppFont.caption)
                .strikethrough()
                .foregroundStyle(AppColor.labelSecondary)
                .padding(.vertical, 4)
        }
    }

    // MARK: - Mylow Ribbon

    private var Mylow: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(Image(systemName: "sparkles")) \(recommendation)")
                .font(AppFont.caption.weight(.semibold))
                .foregroundStyle(AppColor.brandBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Product name

    private var productName: some View {
        Text("\(Text(brand).font(AppFont.caption.weight(.semibold))) \(name)")
            .font(AppFont.caption)
            .foregroundStyle(AppColor.labelPrimary)
            .lineLimit(2)
    }

    // MARK: - Rating

    private var ratingRow: some View {
        HStack(spacing: 2) {
            Text(rating)
                .font(AppFont.caption)
                .foregroundStyle(AppColor.labelPrimary)
            Image(systemName: "star.fill")
                .font(.system(size: 9))
                .foregroundStyle(Color(red: 1.0, green: 0.788, blue: 0.286)) // #FFC949
            Text("(\(reviewCount))")
                .font(AppFont.caption)
                .foregroundStyle(AppColor.labelSecondary)
        }
        .frame(height: 16)
    }

    // MARK: - Add to cart

    private var addToCartButton: some View {
        Button {
            // Add to cart action.
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 18))
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(AppColor.brandGreen, in: Circle())
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 2, y: 4)
        }
        .buttonStyle(.plain)
        .padding(8)
    }
}

#Preview {
    ProductCard(
        imageName: "hammer",
        dollars: "42",
        cents: "98",
        originalPrice: "$49.98",
        recommendation: "Best overall for framing a backyard shed.",
        brand: "Estwing",
        name: "28.0 -oz Steel Head Steel Handle Framing hammer",
        rating: "4.7",
        reviewCount: "1.2k"
    )
    .padding()
}
