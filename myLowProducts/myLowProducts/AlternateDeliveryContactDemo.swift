import SwiftUI

struct AlternateDeliveryContactDemo: View {
    @AppStorage("hasSeenAlternateContactSwipeHint") private var hasSeenSwipeHint = false
    @State private var isSheetPresented = false

    var body: some View {
        NavigationStack {
            ContentUnavailableView {
                Label("Swipe Actions", systemImage: "hand.draw")
            } description: {
                Text("Present Alternate Delivery Contact and swipe a contact to edit or delete it.")
            } actions: {
                Button("Demo Swipe Hint") {
                    hasSeenSwipeHint = false
                    isSheetPresented = true
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Interaction Demos")
        }
        .sheet(isPresented: $isSheetPresented) {
            AlternateDeliveryContactSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
        }
    }
}

#Preview { AlternateDeliveryContactDemo() }
