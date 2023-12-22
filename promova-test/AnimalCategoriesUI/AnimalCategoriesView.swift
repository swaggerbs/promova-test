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
    }

    
    var body: some View {
        ZStack {
            List {
                
                ForEach(viewStore.categories, id: \.id) {
                    AnimalCategoryView(model: $0)
                        .listRowInsets(EdgeInsets())
                }
            }
            .onAppear {
                store.send(.fetchCategories)
            }
            if viewStore.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    let store = Store(initialState: AnimalCategoriesFeature.State()) {
        AnimalCategoriesFeature()
    }
    return AnimalCategoriesView(store: store)
}
