//
//  AnimalCategoryDetailsView.swift
//  promova-test
//

import SwiftUI
import ComposableArchitecture

struct AnimalCategoryDetailsView: View {
    
    let store: StoreOf<AnimalCategoryDetailsFeature>
    @ObservedObject var viewStore: ViewStoreOf<AnimalCategoryDetailsFeature>

    init(store: StoreOf<AnimalCategoryDetailsFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        VStack {
            TabView(selection: viewStore.$currentFactIndex) {
                ForEach(0..<viewStore.facts.count, id: \.self) { i in
                    cardView(viewStore.facts[i])
                        .tag(i)
                }
                .padding(.all, betweenCardsPadding)
            }
            .padding(.top, 50)
            .frame(width: UIScreen.main.bounds.width, height: cardHeight)
            .tabViewStyle(.page(indexDisplayMode: .never))
            Spacer()
        }
        .navigationTitle("Category Details")
    }
    
    func cardView(_ fact: FactModel) -> some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
            VStack {
                AsyncImage(url: fact.imageUrl) { image in
                    image
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: imageWidth, height: imageHeight)
                      .clipped()
                } placeholder: {
                    Color.gray
                        .frame(height: imageHeight)
                }
                Text(fact.content)
                    .foregroundColor(Color.primary)
                Spacer()
                HStack {
                    Button {
                        store.send(.previousPage, animation: .default)
                    } label: {
                        Image(systemName: "arrowshape.backward.circle")
                    }
                    .font(.system(size: 50))
                    Spacer()
                    Button {
                        store.send(.nextPage, animation: .default)
                    } label: {
                        Image(systemName: "arrowshape.right.circle")
                    }
                    .font(.system(size: 50))
                }
            }
            .padding(.all, cardContentPadding)
        }
        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous))
    }
}

extension AnimalCategoryDetailsView {
    var cardWidth: CGFloat { UIScreen.main.bounds.width }
    var cardHeight: CGFloat { 600 }
    var cardCornerRadius: CGFloat { 10 }
    var cardContentPadding: CGFloat { 10 }
    var betweenCardsPadding: CGFloat { 10 }
    var imageHeight: CGFloat { cardHeight / 2 }
    var imageWidth: CGFloat { cardWidth - cardContentPadding * 2 }
}

#Preview {
    AnimalCategoryDetailsView(store: Store(initialState: AnimalCategoryDetailsFeature.State(facts: [])) {
        AnimalCategoryDetailsFeature()
    })
}
