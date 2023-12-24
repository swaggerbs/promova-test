//
//  AnimalCategoryDetailsFeature.swift
//  promova-test
//

import Foundation
import ComposableArchitecture

@Reducer
struct AnimalCategoryDetailsFeature {
    struct State: Equatable {
        @BindingState var currentFactIndex: Int = 0
        var facts: [FactModel]
    }
    
    enum Action: BindableAction {
        case nextPage
        case previousPage
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .nextPage:
                let nextIndex = state.currentFactIndex + 1
                if nextIndex < state.facts.count {
                    state.currentFactIndex = nextIndex
                }
                return .none
            case .previousPage:
                let nextIndex = state.currentFactIndex - 1
                if nextIndex >= 0 {
                    state.currentFactIndex = nextIndex
                }
                return .none
            }
        }
    }
}
