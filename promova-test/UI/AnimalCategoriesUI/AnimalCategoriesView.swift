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
                            AnimalCategoryView(model: category)
                        }  
                    }
                }
                if viewStore.isLoading {
                    ProgressView()
                }
            }
            
        }
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
