import SwiftUI
import SharedUI

struct MyHome: View {
    private enum Tab { case shop, cart, wallet, account, search }
    @State private var showHistory = false
    @State private var selectedTab = Tab.account

    var body: some View {
        TabView(selection: $selectedTab) {
            tabPlaceholder(title: "Shop", systemImage: "house.fill").tabItem { Label("Shop", systemImage: "house.fill") }.tag(Tab.shop)
            tabPlaceholder(title: "Cart", systemImage: "cart.fill").tabItem { Label("Cart", systemImage: "cart.fill") }.tag(Tab.cart)
            tabPlaceholder(title: "Wallet", systemImage: "qrcode").tabItem { Label("Wallet", systemImage: "qrcode") }.tag(Tab.wallet)
            accountTab.tabItem { Label("Account", systemImage: "person.circle.fill") }.tag(Tab.account)
            tabPlaceholder(title: "Search", systemImage: "magnifyingglass").tabItem { Label("Search", systemImage: "magnifyingglass") }.tag(Tab.search)
        }
        .sheet(isPresented: $showHistory) {
            HomeHistorySheet().presentationDetents([.large]).presentationDragIndicator(.visible)
        }
    }

    private var accountTab: some View {
        ZStack {
            AppColor.groupedBackground.ignoresSafeArea()
            Button("My Home History") { showHistory = true }.buttonStyle(.borderedProminent)
        }
    }

    private func tabPlaceholder(title: String, systemImage: String) -> some View {
        ZStack {
            AppColor.groupedBackground.ignoresSafeArea()
            ContentUnavailableView(title, systemImage: systemImage)
        }
    }
}

#Preview { MyHome() }
