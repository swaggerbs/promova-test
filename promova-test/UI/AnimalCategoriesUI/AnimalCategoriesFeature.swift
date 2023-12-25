//
//  AnimalCategoriesFeature.swift
//  promova-test
//

import Foundation
import ComposableArchitecture

@Reducer
struct AnimalCategoriesFeature {
    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        @PresentationState var advertAlert: AlertState<Action.AdvertAlert>?
        
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
        case alert(PresentationAction<Action.Alert>)
        case showAlert
        case advertAlert(PresentationAction<Action.AdvertAlert>)
        case showAdvertAlert
        case setAdvertWatchCompleted
        
        enum Alert {
            case okButtonTapped
        }
        
        enum AdvertAlert {
            case watchAdvertTapped
            case cancelTapped
        }
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
                switch category.state {
                case .free:
                    state.detailItem = .init(facts: category.facts)
                    return .none
                case .paid:
                    return .send(.showAdvertAlert)
                case .comingSoon:
                    state.selection = nil
                    return .send(.showAlert)
                }
            case .didItemTapped(.none):
                state.selection = nil
                return .none
            case .showAlert:
                state.alert = AlertState {
                    TextState("Coming Soon")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Ok")
                    }
                } message: {
                    TextState("We are working on this category. It will be available next update.")
                }
                return .none
            case .showAdvertAlert:
                state.advertAlert = AlertState {
                    TextState("Premium Category")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .watchAdvertTapped) {
                        TextState("Show Ad")
                    }
                } message: {
                    TextState("Watch an Ad to continue.")
                }
                return .none
            case .advertAlert(.presented(.watchAdvertTapped)):
                state.isLoading = true
                return .run { send in
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    await send(.setAdvertWatchCompleted)
                }
            case .setAdvertWatchCompleted:
                state.isLoading = false
                guard let id = state.selection?.id else {
                    return .none
                }
                state.categories[id: id]?.state = .free
                state.selection = nil
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$advertAlert, action: \.advertAlert)
        .ifLet(\.detailItem, action: \.detailItem) {
            AnimalCategoryDetailsFeature()
        }
    }
}
