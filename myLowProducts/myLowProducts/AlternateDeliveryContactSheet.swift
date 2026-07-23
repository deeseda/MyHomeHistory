import SwiftUI

struct AlternateDeliveryContactSheet: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasSeenAlternateContactSwipeHint") private var hasSeenSwipeHint = false
    @State private var contacts = AlternateDeliveryContact.samples
    @State private var selectedContactID = AlternateDeliveryContact.samples.first?.id
    @State private var hintedContactID: AlternateDeliveryContact.ID?
    @State private var hintOffset: CGFloat = 0

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(contacts) { contact in
                        contactRow(contact)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) { delete(contact) } label: { Label("Delete", systemImage: "trash.fill") }
                                Button {} label: { Label("Edit", systemImage: "pencil") }.tint(.indigo)
                            }
                    }
                }
                Section {
                    Button("Add New Contact", systemImage: "plus") { contacts.append(.placeholder) }
                }
                Section {
                    Text("This contact will also receive updates on your delivery. By providing the individual’s name and phone number, you agree that you have obtained the individual’s consent for Lowe’s to contact the number via automated means for your order and delivery. Msg & data rates may apply.")
                        .font(.footnote).foregroundStyle(.primary)
                        .listRowBackground(Color.clear).listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Alternate Delivery Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") { dismiss() }.labelStyle(.iconOnly)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") { dismiss() }
                        .labelStyle(.iconOnly).buttonStyle(.borderedProminent).buttonBorderShape(.circle)
                }
            }
            .task { await showSwipeHintIfNeeded() }
        }
    }

    private func contactRow(_ contact: AlternateDeliveryContact) -> some View {
        Button { selectedContactID = contact.id } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(contact.name).font(.body).foregroundStyle(.primary)
                    Text("\(contact.phone) · \(contact.email)").font(.caption).foregroundStyle(.secondary).lineLimit(1)
                }
                Spacer(minLength: 8)
                Image(systemName: selectedContactID == contact.id ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selectedContactID == contact.id ? Color.accentColor : .secondary).imageScale(.large)
            }
            .contentShape(Rectangle())
            .offset(x: hintedContactID == contact.id ? hintOffset : 0)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Double tap to select, or swipe left for Edit and Delete actions")
    }

    @MainActor private func showSwipeHintIfNeeded() async {
        guard !hasSeenSwipeHint, let contact = contacts.first else { return }
        hintedContactID = contact.id
        try? await Task.sleep(for: .milliseconds(700))
        guard !Task.isCancelled else { return }
        withAnimation(.easeOut(duration: 0.22)) { hintOffset = -20 }
        try? await Task.sleep(for: .milliseconds(300))
        guard !Task.isCancelled else { return }
        withAnimation(.spring(duration: 0.45, bounce: 0.22)) { hintOffset = 0 }
        hasSeenSwipeHint = true
    }

    private func delete(_ contact: AlternateDeliveryContact) {
        contacts.removeAll { $0.id == contact.id }
        hasSeenSwipeHint = true
        if selectedContactID == contact.id { selectedContactID = contacts.first?.id }
    }
}

private struct AlternateDeliveryContact: Identifiable {
    let id = UUID()
    var name: String
    var phone: String
    var email: String
    static let samples = [
        AlternateDeliveryContact(name: "Marcia Johnson", phone: "(704) 123-9876", email: "Marcia@gmail.com"),
        AlternateDeliveryContact(name: "Noreen Catron", phone: "(704) 123-9876", email: "Marcia@gmail.com"),
        AlternateDeliveryContact(name: "Kenneth Eaton", phone: "(704) 123-9876", email: "Marcia@gmail.com")
    ]
    static var placeholder: AlternateDeliveryContact {
        AlternateDeliveryContact(name: "New Contact", phone: "(704) 555-0123", email: "contact@example.com")
    }
}

#Preview { AlternateDeliveryContactSheet() }
