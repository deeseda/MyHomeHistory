//
//  HomeHistorySheet.swift
//  myLowProducts
//
//  Created by Cascade on 7/15/26.
//

import SwiftUI
import SharedUI

struct HomeHistorySheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showAddEntry = false
    @State private var displaySections: [Section]
    @State private var editingEntry: EditingHistoryEntry?
    @State private var photoGallery: HistoryPhotoGallery?
    @State private var searchText = ""
    @State private var isSearchPresented = false
    @State private var sortOption = HistorySortOption.entryDate
    @State private var filterOption = HistoryFilterOption.all
    @State private var isSelectingEntries = false

    struct Entry: Identifiable {
        let id: UUID
        var media: HistoryCard.Media?
        var title: String
        var subtitle: String
        var badgeKind: HistoryBadge.Kind
        var showsAddedByIndicator: Bool
        var attachmentIcon: Image?
        var dateLabel: String
        var buttonTitle: String?

        init(
            id: UUID = UUID(),
            media: HistoryCard.Media? = nil,
            title: String,
            subtitle: String,
            badgeKind: HistoryBadge.Kind,
            showsAddedByIndicator: Bool,
            attachmentIcon: Image?,
            dateLabel: String,
            buttonTitle: String?
        ) {
            self.id = id
            self.media = media
            self.title = title
            self.subtitle = subtitle
            self.badgeKind = badgeKind
            self.showsAddedByIndicator = showsAddedByIndicator
            self.attachmentIcon = attachmentIcon
            self.dateLabel = dateLabel
            self.buttonTitle = buttonTitle
        }
    }

    struct Section: Identifiable {
        let id: UUID
        var monthAnchor: Date
        var entries: [Entry]

        init(id: UUID = UUID(), monthAnchor: Date, entries: [Entry]) {
            self.id = id
            self.monthAnchor = monthAnchor
            self.entries = entries
        }
    }

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

    init(sections: [Section] = Self.sampleSections) {
        _displaySections = State(initialValue: sections)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                sectionList
            }
            .frame(maxWidth: .infinity)
            .background(AppColor.groupedBackground)
            .navigationTitle("My Home History")
            .navigationBarTitleDisplayMode(.large)
            .modifier(
                HistorySearchModifier(
                    searchText: $searchText,
                    isSearchPresented: $isSearchPresented
                )
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        isSearchPresented = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }

                    historyOptionsMenu
                }

                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }

                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showAddEntry = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .sheet(isPresented: $showAddEntry) {
            NewHistoryEntrySheet { entry, date in
                add(entry: entry, on: date)
            }
        }
        .sheet(item: $editingEntry) { editingEntry in
            NewHistoryEntrySheet(entry: editingEntry.entry, date: editingEntry.date) { entry, date in
                update(entry: entry, on: date)
            }
        }
        .sheet(item: $photoGallery) { gallery in
            HistoryPhotoGallerySheet(gallery: gallery)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: isSearchPresented) { _, presented in
            if !presented {
                searchText = ""
            }
        }
    }

    private var sectionList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                if visibleSections.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                        .padding(.top, 80)
                } else {
                    ForEach(visibleSections) { section in
                        VStack(alignment: .leading, spacing: 0) {
                            sectionHeader(for: section.monthAnchor)

                            VStack(spacing: 8) {
                                ForEach(section.entries) { entry in
                                    HistoryCard(
                                        media: entry.media,
                                        title: entry.title,
                                        subtitle: entry.subtitle,
                                        badgeKind: entry.badgeKind,
                                        showsAddedByIndicator: entry.showsAddedByIndicator,
                                        attachmentIcon: entry.attachmentIcon,
                                        date: entry.dateLabel,
                                        buttonTitle: entry.buttonTitle,
                                        mediaTapAction: { images, selectedIndex in
                                            photoGallery = HistoryPhotoGallery(
                                                images: images,
                                                selectedIndex: selectedIndex
                                            )
                                        }
                                    )
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button(role: .destructive) {
                                            delete(entry)
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }

                                        Button {
                                            editingEntry = EditingHistoryEntry(entry: entry, date: section.monthAnchor)
                                        } label: {
                                            Label("Edit", systemImage: "square.and.pencil")
                                        }
                                        .tint(.indigo)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 40)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
    }

    private func sectionHeader(for date: Date) -> some View {
        let title = sectionTitle(for: date)
        return Text(title)
            .font(AppFont.title2)
            .foregroundStyle(AppColor.labelPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 5)
            .padding(.bottom, 10)
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

    private func add(entry: Entry, on date: Date) {
        let monthAnchor = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? date

        if let sectionIndex = displaySections.firstIndex(where: { calendar.isDate($0.monthAnchor, equalTo: monthAnchor, toGranularity: .month) }) {
            displaySections[sectionIndex].entries.insert(entry, at: 0)
        } else {
            displaySections.append(Section(monthAnchor: monthAnchor, entries: [entry]))
        }
    }

    private func update(entry: Entry, on date: Date) {
        delete(entry)
        add(entry: entry, on: date)
    }

    private func delete(_ entry: Entry) {
        for sectionIndex in displaySections.indices {
            displaySections[sectionIndex].entries.removeAll { $0.id == entry.id }
        }

        displaySections.removeAll { $0.entries.isEmpty }
    }

    private var historyOptionsMenu: some View {
        Menu {
            Menu {
                ForEach(HistorySortOption.allCases) { option in
                    Button {
                        sortOption = option
                    } label: {
                        selectedMenuLabel(option.title, isSelected: sortOption == option)
                    }
                }
            } label: {
                menuLabel(
                    title: "Sort by",
                    subtitle: sortOption.title,
                    systemImage: "arrow.up.arrow.down"
                )
            }

            Menu {
                ForEach(HistoryFilterOption.allCases) { option in
                    Button {
                        filterOption = option
                    } label: {
                        selectedMenuLabel(option.title, isSelected: filterOption == option)
                    }
                }
            } label: {
                menuLabel(
                    title: "Filter by",
                    subtitle: filterOption.title,
                    systemImage: "line.3.horizontal.decrease"
                )
            }

            Button {
                isSelectingEntries.toggle()
            } label: {
                Label(
                    isSelectingEntries ? "Done Selecting" : "Select Entries",
                    systemImage: "checkmark.circle"
                )
            }

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

    private var visibleSections: [Section] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return sortedSections.compactMap { section in
            let entries = section.entries.filter { entry in
                guard filterOption.matches(entry) else { return false }
                guard !query.isEmpty else { return true }

                if let filter = SearchFilter(title: query) {
                    return filter.matches(entry)
                }

                return entry.title.localizedCaseInsensitiveContains(query)
                    || entry.subtitle.localizedCaseInsensitiveContains(query)
                    || entry.dateLabel.localizedCaseInsensitiveContains(query)
            }

            guard !entries.isEmpty else { return nil }
            return Section(id: section.id, monthAnchor: section.monthAnchor, entries: sorted(entries))
        }
    }

    private func sorted(_ entries: [Entry]) -> [Entry] {
        switch sortOption {
        case .entryDate:
            return entries
        case .category:
            return entries.sorted {
                $0.badgeKind.sortTitle.localizedCaseInsensitiveCompare($1.badgeKind.sortTitle) == .orderedAscending
            }
        }
    }
}

private enum HistorySortOption: String, CaseIterable, Identifiable {
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

private enum HistoryFilterOption: String, CaseIterable, Identifiable {
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

    func matches(_ entry: HomeHistorySheet.Entry) -> Bool {
        switch self {
        case .all: return true
        case .lowes: return entry.badgeKind == .lowes
        case .diy: return entry.badgeKind == .diy
        case .pro: return entry.badgeKind == .pro
        case .records: return entry.badgeKind == .records
        case .insights: return entry.badgeKind == .insights
        }
    }
}

private extension HistoryBadge.Kind {
    var sortTitle: String {
        switch self {
        case .lowes: return "Lowe's"
        case .diy: return "DIY"
        case .pro: return "Pro"
        case .records: return "County Records"
        case .insights: return "Home Insights"
        }
    }
}

private struct HistorySearchModifier: ViewModifier {
    @Binding var searchText: String
    @Binding var isSearchPresented: Bool

    func body(content: Content) -> some View {
        if isSearchPresented {
            content
                .searchable(
                    text: $searchText,
                    isPresented: $isSearchPresented,
                    placement: .toolbar,
                    prompt: "Search"
                )
                .searchSuggestions {
                    SwiftUI.Section("Suggested") {
                        ForEach(SearchFilter.allCases) { filter in
                            Label(filter.title, systemImage: filter.systemImage)
                                .searchCompletion(filter.title)
                        }
                    }
                }
        } else {
            content
        }
    }
}

private enum SearchFilter: String, CaseIterable, Identifiable {
    case textOnly
    case attachmentsOnly
    case photos

    var id: Self { self }

    var title: String {
        switch self {
        case .textOnly: return "Text Only"
        case .attachmentsOnly: return "Attachments Only"
        case .photos: return "Photos"
        }
    }

    var systemImage: String {
        switch self {
        case .textOnly: return "line.3.horizontal"
        case .attachmentsOnly: return "paperclip"
        case .photos: return "photo"
        }
    }

    init?(title: String) {
        let normalizedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let filter = Self.allCases.first(where: { $0.title.localizedCaseInsensitiveCompare(normalizedTitle) == .orderedSame }) else {
            return nil
        }

        self = filter
    }

    func matches(_ entry: HomeHistorySheet.Entry) -> Bool {
        switch self {
        case .textOnly:
            return entry.media == nil && entry.attachmentIcon == nil
        case .attachmentsOnly:
            return entry.attachmentIcon != nil
        case .photos:
            return entry.media != nil
        }
    }
}

private struct EditingHistoryEntry: Identifiable {
    var entry: HomeHistorySheet.Entry
    var date: Date

    var id: UUID { entry.id }
}

private struct HistoryPhotoGallery: Identifiable {
    let id = UUID()
    var images: [Image]
    var selectedIndex: Int
}

private struct HistoryPhotoGallerySheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selection: Int

    var gallery: HistoryPhotoGallery

    init(gallery: HistoryPhotoGallery) {
        self.gallery = gallery
        _selection = State(initialValue: gallery.selectedIndex)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView(selection: $selection) {
                    ForEach(Array(gallery.images.enumerated()), id: \.offset) { index, image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .padding(.horizontal, 16)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.groupedBackground)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: "My Home History photo") {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

// MARK: - Sample Data

extension HomeHistorySheet {
    private var sortedSections: [Section] {
        displaySections.sorted { $0.monthAnchor > $1.monthAnchor }
    }

    private static func makeDate(year: Int, month: Int, day: Int = 1) -> Date {
        Calendar(identifier: .gregorian).date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }

    private static var sampleSections: [Section] {
        let july = Section(
            monthAnchor: makeDate(year: 2026, month: 7),
            entries: [
                Entry(
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
                    subtitle: "Applied Behr Premium Semi-Transparent Cedar stain. Photos and receipt attached.",
                    badgeKind: .diy,
                    showsAddedByIndicator: true,
                    attachmentIcon: nil,
                    dateLabel: "Monday, Jun 8",
                    buttonTitle: nil
                )
            ]
        )

        let april = Section(
            monthAnchor: makeDate(year: 2026, month: 4),
            entries: [
                Entry(
                    title: "Annual Roof Inspection",
                    subtitle: "No damage found. Roof estimated to have 12–15 years of remaining life.",
                    badgeKind: .pro,
                    showsAddedByIndicator: true,
                    attachmentIcon: Image(systemName: "paperclip"),
                    dateLabel: "Wednesday, Apr 22",
                    buttonTitle: nil
                )
            ]
        )

        let august = Section(
            monthAnchor: makeDate(year: 2025, month: 8),
            entries: [
                Entry(
                    title: "Electrical Permit Closed",
                    subtitle: "200-amp electrical panel upgrade passed final inspection. Permit #ELE-2026-041872",
                    badgeKind: .records,
                    showsAddedByIndicator: false,
                    attachmentIcon: Image(systemName: "paperclip"),
                    dateLabel: "Saturday, Aug 9, 2025",
                    buttonTitle: nil
                ),
                Entry(
                    title: "Severe Hail Event",
                    subtitle: "National Weather Service recorded 1.25” hail within 1 mile of the property. Roof inspection recommended.",
                    badgeKind: .insights,
                    showsAddedByIndicator: false,
                    attachmentIcon: nil,
                    dateLabel: "Friday, Aug 1, 2025",
                    buttonTitle: nil
                )
            ]
        )

        let december = Section(
            monthAnchor: makeDate(year: 2024, month: 12),
            entries: [
                Entry(
                    media: .single(Image("deck-1")),
                    title: "Home Purchased",
                    subtitle: "Purchased for $432,000. Ownership transferred and deed recorded.",
                    badgeKind: .records,
                    showsAddedByIndicator: false,
                    attachmentIcon: Image(systemName: "paperclip"),
                    dateLabel: "Tuesday, Dec 3, 2024",
                    buttonTitle: nil
                )
            ]
        )

        return [july, june, april, august, december]
    }
}

private struct NewHistoryEntrySheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var subtitle = ""
    @State private var date = Date()
    @State private var source = Source.diy
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
        _source = State(initialValue: entry.map { Source(kind: $0.badgeKind) } ?? .diy)
        _includesAttachment = State(initialValue: entry?.attachmentIcon != nil)
        entryID = entry?.id ?? UUID()
        originalMedia = entry?.media
        originalButtonTitle = entry?.buttonTitle
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Entry") {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $subtitle, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section("Source") {
                    Picker("Source", selection: $source) {
                        ForEach(Source.allCases) { source in
                            Text(source.title).tag(source)
                        }
                    }

                    Toggle("Attachment", isOn: $includesAttachment)
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(
                            HomeHistorySheet.Entry(
                                id: entryID,
                                media: originalMedia,
                                title: title,
                                subtitle: subtitle,
                                badgeKind: source.badgeKind,
                                showsAddedByIndicator: source == .diy,
                                attachmentIcon: includesAttachment ? Image(systemName: "paperclip") : nil,
                                dateLabel: Self.dateFormatter.string(from: date),
                                buttonTitle: originalButtonTitle
                            ),
                            date
                        )
                        dismiss()
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
}

private extension NewHistoryEntrySheet {
    enum Source: String, CaseIterable, Identifiable {
        case diy
        case lowes
        case pro
        case records
        case insights

        var id: Self { self }

        var title: String {
            switch self {
            case .diy: return "DIY"
            case .lowes: return "Lowe's"
            case .pro: return "Pro"
            case .records: return "County Records"
            case .insights: return "Home Insights"
            }
        }

        init(kind: HistoryBadge.Kind) {
            switch kind {
            case .diy: self = .diy
            case .lowes: self = .lowes
            case .pro: self = .pro
            case .records: self = .records
            case .insights: self = .insights
            }
        }

        var badgeKind: HistoryBadge.Kind {
            switch self {
            case .diy: return .diy
            case .lowes: return .lowes
            case .pro: return .pro
            case .records: return .records
            case .insights: return .insights
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.white, AppColor.groupedBackgroundAccent], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

        HomeHistorySheet()
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
    }
}
