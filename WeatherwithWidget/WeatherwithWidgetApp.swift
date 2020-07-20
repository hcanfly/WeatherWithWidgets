//
//  WeatherwithWidgetApp.swift
//  WeatherwithWidget
//
//  Created by Gary on 6/28/20.
//

import SwiftUI

@main
struct WeatherwithWidgetApp: App {
    @ObservedObject var viewModel: ViewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
