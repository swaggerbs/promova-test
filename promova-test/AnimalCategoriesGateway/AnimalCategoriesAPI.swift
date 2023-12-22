//
//  AnimalCategoriesAPI.swift
//  promova-test
//

import Foundation

struct AnimalCategoryResult: Decodable {
    
    enum Status: String, Decodable {
        case paid, free
    }
    
    struct CategoryContent: Decodable {
        let fact: String
        let imageUrl: URL
    }
    
    let title: String
    let description: String
    let imageUrl: URL
    let order: Int
    let status: Status
    let content: CategoryContent?
}

struct AnimalCategoriesAPI {
    
    private let factory = AnimalCategoryFactory()
    
    func fetch() async throws -> [AnimalCategoryModel] {
        let url = URL(string: "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try! JSONDecoder().decode([AnimalCategoryResult].self, from: data)
        return result.map {
            factory.makeModel(from: $0)
        }
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
        if result.content == nil {
            state = .comingSoon
        }
        return AnimalCategoryModel(
            name: result.title,
            description: result.description,
            state: state,
            imageUrl: result.imageUrl
        )
    }
}
