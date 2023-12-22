//
//  ContentView.swift
//  promova-test
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AnimalCategoryFeature {
    struct State: Equatable {
        var categories: IdentifiedArrayOf<AnimalCategoryModel>
    }
    
    struct Action: Equatable {
    }
    
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}

struct AnimalCategoriesView: View {
    
    private static let mockPaidModel = AnimalCategoryModel(
        name: "Mock Category",
        description: "Pretty good mock Animal",
        state: .comingSoon,
        imageUrl: URL(string: "https://images6.alphacoders.com/337/337780.jpg")
    )
    
    var body: some View {
        List {
            AnimalCategoryView(model: Self.mockPaidModel)
                .frame(height: 100)
                .listRowInsets(EdgeInsets())
        }
    }
}

#Preview {
    AnimalCategoriesView()
}
