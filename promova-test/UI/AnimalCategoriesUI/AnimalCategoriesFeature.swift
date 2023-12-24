//
//  AnimalCategoriesFeature.swift
//  promova-test
//

import Foundation
import ComposableArchitecture

@Reducer
struct AnimalCategoriesFeature {
    struct State: Equatable {
        var categories: IdentifiedArrayOf<AnimalCategoryModel> = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case fetchCategories
        case categoriesFetched(IdentifiedArrayOf<AnimalCategoryModel>)
    }
    
    @Dependency(\.animalCategories) var gateway
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchCategories:
                state.isLoading = true
                return .run { send in
                    let result = try await gateway.fetchCategories()
                    await send(.categoriesFetched(result))
                }
            case let .categoriesFetched(categories):
                state.isLoading = false
                state.categories = categories
                return .none
            }
            
        }
    }
}
