//
//  HistoryBadge.swift
//  myLowProducts
//
//  Created by Deese, Derrick on 7/15/26.
//

import SwiftUI
import SharedUI

struct HistoryBadge: View {
    enum Kind {
        case lowes
        case diy
        case pro
        case records
        case insights
    }

    let kind: Kind

    var body: some View {
        Label {
            Text(title)
        } icon: {
            icon
        }
        .font(AppFont.caption.weight(.semibold))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .foregroundStyle(foregroundColor)
        .background(backgroundColor)
        .clipShape(Capsule())
    }

    private var title: String {
        switch kind {
        case .lowes: return "Lowe's"
        case .diy: return "DIY"
        case .pro: return "Pro"
        case .records: return "County Records"
        case .insights: return "Home Insights"
        }
    }

    @ViewBuilder
    private var icon: some View {
        switch kind {
        case .lowes:
            Image("Lowes-Filled")
                .renderingMode(.template)
        case .diy:
            Image(systemName: "person.fill")
        case .pro:
            Image(systemName: "hammer.fill")
        case .records:
            Image(systemName: "house.fill")
        case .insights:
            Image(systemName: "sparkles")
        }
    }

    private var foregroundColor: Color {
        switch kind {
        case .lowes: return .blue
        case .diy: return .green
        case .pro: return .cyan
        case .records: return .brown
        case .insights: return .purple
        }
    }

    private var backgroundColor: Color {
        switch kind {
        case .lowes: return .blue.opacity(0.25)
        case .diy: return .green.opacity(0.25)
        case .pro: return .cyan.opacity(0.25)
        case .records: return .brown.opacity(0.25)
        case .insights: return .purple.opacity(0.25)
        }
    }
}

#Preview {
    HistoryBadge(kind: .diy)
    HistoryBadge(kind: .lowes)
}
