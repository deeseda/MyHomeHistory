//
//  NewHistoryEntrySheet.swift
//  myLowProducts
//
//  Created by Deese, Derrick on 7/16/26.
//

import SwiftUI
import SharedUI

struct NewHistoryEntrySheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var subtitle = ""
    @State private var date = Date()
    @State private var category = Category.diy
    @State private var includesAttachment = false

    private let entryID: UUID
    private let originalMedia: HistoryCard.Media?
    private let originalButtonTitle: String?

    var onSave: (HomeHistorySheet.Entry, Date) -> Void

    init(
        entry: HomeHistorySheet.Entry? = nil,
        date: Date = Date(),
        onSave: @escaping (HomeHistorySheet.Entry, Date) -> Void
    ) {
        _title = State(initialValue: entry?.title ?? "")
        _subtitle = State(initialValue: entry?.subtitle ?? "")
        _date = State(initialValue: date)
        _category = State(initialValue: entry.map { Category(kind: $0.badgeKind) } ?? .diy)
        _includesAttachment = State(initialValue: entry?.attachmentIcon != nil)
        entryID = entry?.id ?? UUID()
        originalMedia = entry?.media
        originalButtonTitle = entry?.buttonTitle
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $subtitle, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                    
                    
                Section {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases) { category in
                            Text(category.title).tag(category)
                        }
                    }
                }
                    

                
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                            Button { } label: {
                                Image(systemName: "plus")
                            }
                            Button { } label: {
                                Image(systemName: "photo")
                            }
                            Button { } label: {
                                Image(systemName: "camera")
                            }
                            Button { } label: {
                                Image(systemName: "paperclip")
                            }

                        }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onSave(
                            HomeHistorySheet.Entry(
                                id: entryID,
                                media: originalMedia,
                                title: title,
                                subtitle: subtitle,
                                badgeKind: category.badgeKind,
                                showsAddedByIndicator: category == .diy,
                                attachmentIcon: includesAttachment ? Image(systemName: "paperclip") : nil,
                                dateLabel: Self.dateFormatter.string(from: date),
                                buttonTitle: originalButtonTitle
                            ),
                            date
                        )
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d")
        return formatter
    }()

    enum Category: String, CaseIterable, Identifiable {
        case diy
        case lowes
        case pro
        case records

        var id: Self { self }

        var title: String {
            switch self {
            case .diy: return "DIY"
            case .lowes: return "Lowe's"
            case .pro: return "Pro"
            case .records: return "County Records"
            }
        }

        init(kind: HistoryBadge.Kind) {
            switch kind {
            case .diy: self = .diy
            case .lowes: self = .lowes
            case .pro: self = .pro
            case .records: self = .records
            case .insights: self = .diy
            }
        }

        var badgeKind: HistoryBadge.Kind {
            switch self {
            case .diy: return .diy
            case .lowes: return .lowes
            case .pro: return .pro
            case .records: return .records
            }
        }
    }
}

#Preview {
    NewHistoryEntrySheet { _, _ in }
}
