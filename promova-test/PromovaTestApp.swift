//
//  PromovaTestApp.swift
//  promova-test
//

import SwiftUI
import ComposableArchitecture

@main
struct PromovaTestApp: App {
    var body: some Scene {
        WindowGroup {
            AnimalCategoriesView(
                store: Store(initialState: AnimalCategoriesFeature.State()) {
                    AnimalCategoriesFeature()
                }
            )
        }
    }
}
