//
//  ContentView.swift
//  promova-test
//

import ComposableArchitecture
import SwiftUI

struct AnimalCategoriesView: View {
    
    let store: StoreOf<AnimalCategoriesFeature>
    @ObservedObject var viewStore: ViewStoreOf<AnimalCategoriesFeature>

    init(store: StoreOf<AnimalCategoriesFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
        self.store.send(.fetchCategories)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewStore.categories, id: \.id) { category in
                        AnimalCategoryView(model: category)
                            .overlay {
                                NavigationLink(
                                    tag: category.id,
                                    selection: viewStore.binding(
                                        get: \.selection?.id,
                                        send: {
                                            .didItemTapped($0)
                                        }
                                    )
                                ) {
                                    IfLetStore(self.store.scope(state: \.detailItem, action: \.detailItem)) {
                                        AnimalCategoryDetailsView(store: $0)
                                    }
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        
                    }
                }
                if viewStore.isLoading {
                    Color(UIColor.systemBackground)
                    ProgressView()
                }
            }
        }
        .alert(
            store: store.scope(state: \.$alert, action: \.alert)
        )
        .alert(
            store: store.scope(state: \.$advertAlert, action: \.advertAlert)
        )
    }
    
    @ViewBuilder
    private func makeDetailsView(_ category: AnimalCategoryModel) -> some View {
        let store = Store(initialState: AnimalCategoryDetailsFeature.State(facts: category.facts)) {
            AnimalCategoryDetailsFeature()
        }
        AnimalCategoryDetailsView(store: store)
    }
}

#Preview {
    let store = Store(initialState: AnimalCategoriesFeature.State()) {
        AnimalCategoriesFeature()
    }
    return AnimalCategoriesView(store: store)
}
