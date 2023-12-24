//
//  AnimalCategoryDetailsView.swift
//  promova-test
//

import SwiftUI
import ComposableArchitecture

struct AnimalCategoryDetailsView: View {
    
    let store: StoreOf<AnimalCategoryDetailsFeature>
    @ObservedObject var viewStore: ViewStoreOf<AnimalCategoryDetailsFeature>

    @State private var isSharePresented: Bool = false
    
    init(store: StoreOf<AnimalCategoryDetailsFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        VStack {
            TabView(selection: viewStore.$currentFactIndex) {
                ForEach(viewStore.facts.indices, id: \.self) { i in
                    cardView(viewStore.facts[i])
                        .tag(i)
                }
                .padding(.all, betweenCardsPadding)
            }
            .padding(.top, cardTopPadding)
            .frame(width: UIScreen.main.bounds.width, height: cardHeight)
            .tabViewStyle(.page(indexDisplayMode: .never))
            Spacer()
        }
        .navigationTitle("Category Details")
        .sheet(isPresented: $isSharePresented, onDismiss: {
            isSharePresented = false
        }, content: {
            ActivityView(activityItems: [viewStore.currentFact.content, viewStore.currentFact.imageUrl])
        })
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
                bottomToolbar
            }
            .padding(.all, cardContentPadding)
        }
        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous))
    }
    
    @ViewBuilder
    var bottomToolbar: some View {
        HStack {
            Button {
                store.send(.previousPage, animation: .default)
            } label: {
                Image(systemName: "arrowshape.backward.circle")
            }
            .font(.system(size: toolbarIconsFont))
            Spacer()
            Button {
                isSharePresented = true
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .font(.system(size: toolbarIconsFont))
            Spacer()
            Button {
                store.send(.nextPage, animation: .default)
            } label: {
                Image(systemName: "arrowshape.right.circle")
            }
            .font(.system(size: toolbarIconsFont))
        }
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
    var cardTopPadding: CGFloat { 50 }
    var toolbarIconsFont: CGFloat { 50 }
}

#Preview {
    AnimalCategoryDetailsView(store: Store(initialState: AnimalCategoryDetailsFeature.State(facts: [])) {
        AnimalCategoryDetailsFeature()
    })
}
