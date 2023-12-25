//
//  AnimalCategoriesFeature.swift
//  promova-test
//

import Foundation
import ComposableArchitecture

@Reducer
struct AnimalCategoriesFeature {
    struct State: Equatable {
        var detailItem: AnimalCategoryDetailsFeature.State?
        var selection: AnimalCategoryModel?
        var categories: IdentifiedArrayOf<AnimalCategoryModel> = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case fetchCategories
        case categoriesFetched(IdentifiedArrayOf<AnimalCategoryModel>)
        case detailItem(AnimalCategoryDetailsFeature.Action)
        case didItemTapped(UUID?)
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
            case let .didItemTapped(.some(id)):
                guard let category = state.categories[id: id] else {
                    return .none
                }
                state.selection = category
                state.detailItem = .init(facts: category.facts)
                return .none
            case .didItemTapped(.none):
                state.selection = nil
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.detailItem, action: \.detailItem) {
            AnimalCategoryDetailsFeature()
        }
    }
}
