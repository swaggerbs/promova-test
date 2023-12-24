//
//  AnimalCategoryView.swift
//  promova-test
//

import SwiftUI

struct AnimalCategoryView: View {
    
    let model: AnimalCategoryModel
    
    var body: some View {
        ZStack {
            HStack {
                AsyncImage(url: model.imageUrl) { image in
                    image
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: imageWidth, height: height - padding.top - padding.bottom)
                      .clipped()
                } placeholder: {
                    Color.gray
                }
                .frame(width: imageWidth)
                categoryInfo
                Spacer()
            }
            .padding(padding)
            if model.state == .comingSoon {
                Rectangle()
                    .foregroundColor(.black.opacity(0.2))
                HStack {
                    Image("ComingSoon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                }
            }
        }
        .frame(height: height)
    }
    
    @ViewBuilder
    private var categoryInfo: some View {
        VStack(alignment: .leading) {
            Text(model.name)
                .font(.title3)
                .foregroundStyle(.primary)
            Text(model.description)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .allowsTightening(true)
            Spacer()
            if model.state == .paid {
                Label(model.state.rawValue, systemImage: "lock.fill")
                    .padding(.leading, paidLabelPadding)
                    .labelStyle(CustomLabel(spacing: paidLabelSpacing))
                    .foregroundColor(.indigo)
            }
        }
        .padding(.leading)
    }
}

private struct CustomLabel: LabelStyle {
    var spacing: Double = 0.0
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.icon
            configuration.title
        }
    }
}

// MARK: - LayoutCalculations

private extension AnimalCategoryView {
    
    private var paidLabelSpacing: CGFloat { 4 }
    private var paidLabelPadding: CGFloat { -2 }
    private var imageWidth: CGFloat { 130 }
    private var padding: EdgeInsets { .init(
        top: 6,
        leading: 6,
        bottom: 6,
        trailing: 6)
    }
    private var height: CGFloat { 100 }
}

// MARK: - Preview

#Preview("Default") {
    let mockModel = AnimalCategoryModel(
        name: "Mock Category",
        description: "Pretty good mock Animal",
        state: .free,
        imageUrl: nil, 
        facts: []
    )
    return AnimalCategoryView(model: mockModel)
}

#Preview("Paid") {
    let mockPaidModel = AnimalCategoryModel(
        name: "Mock Category",
        description: "Pretty good mock Animal",
        state: .paid,
        imageUrl: nil, facts: []
    )
    return AnimalCategoryView(model: mockPaidModel)
}

#Preview("ComingSoon") {
    let mockPaidModel = AnimalCategoryModel(
        name: "Mock Category",
        description: "Pretty good mock Animal",
        state: .comingSoon,
        imageUrl: nil, 
        facts: []
    )
    return AnimalCategoryView(model: mockPaidModel)
}
