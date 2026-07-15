//
//  MyHome.swift
//  myLowProducts
//
//  Created by Deese, Derrick on 7/15/26.
//

import SwiftUI
import SharedUI

struct MyHome: View {

    @State private var showHistory = false

    var body: some View {

        Button("My Home History") {

            showHistory = true

        }
        .buttonStyle(.borderedProminent)

        .sheet(isPresented: $showHistory) {

            MyHomeHistory()

        }

    }

}


#Preview {

    MyHome()

}
