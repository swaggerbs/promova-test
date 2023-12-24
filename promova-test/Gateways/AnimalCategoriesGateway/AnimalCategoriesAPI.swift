//
//  AnimalCategoriesAPI.swift
//  promova-test
//

import Foundation
import ComposableArchitecture

struct AnimalCategoryResult: Decodable {
    
    enum Status: String, Decodable {
        case paid, free
    }
    
    struct CategoryContent: Decodable {
        let fact: String
        let image: URL
    }
    
    let title: String
    let description: String
    let image: URL
    let order: Int
    let status: Status
    let content: [CategoryContent]?
}

struct AnimalCategoriesAPI {
    
    private let factory = AnimalCategoryFactory()
    
    func fetch() async throws -> IdentifiedArrayOf<AnimalCategoryModel> {
        let url = URL(string: "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try! JSONDecoder().decode([AnimalCategoryResult].self, from: data)
        let sorted = result.sorted { $0.order > $1.order }
        let models = sorted.map { factory.makeModel(from: $0) }
        return IdentifiedArrayOf<AnimalCategoryModel>(uniqueElements: models, id: \.id)
    }
    
}


struct AnimalCategoryFactory {
    
    func makeModel(from result: AnimalCategoryResult) -> AnimalCategoryModel {
        var state: CategoryState
        switch result.status {
        case .paid:
            state = .paid
        case .free:
            state = .free
        }
        var factModels: [FactModel] = []
        if let content = result.content {
            factModels = content.map {
                makeFactModel(from: $0)
            }
        } else {
            state = .comingSoon
        }
        return AnimalCategoryModel(
            name: result.title,
            description: result.description,
            state: state,
            imageUrl: result.image, 
            facts: factModels
        )
    }
    
    private func makeFactModel(from result: AnimalCategoryResult.CategoryContent) -> FactModel {
        FactModel(content: result.fact, imageUrl: result.image)
    }
}
