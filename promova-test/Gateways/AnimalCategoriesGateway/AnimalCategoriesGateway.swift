//
//  AnimalCategoriesGateway.swift
//  promova-test
//

import Foundation
import ComposableArchitecture

struct AnimalCategoriesGateway {
    var fetchCategories: () async throws -> IdentifiedArrayOf<AnimalCategoryModel>
}

extension AnimalCategoriesGateway: DependencyKey {
    static let liveValue = Self(
        fetchCategories: {
            return try await AnimalCategoriesAPI().fetch()
        }
    )
}

extension DependencyValues {
    var animalCategories: AnimalCategoriesGateway {
        get { self[AnimalCategoriesGateway.self] }
        set { self[AnimalCategoriesGateway.self] = newValue }
    }
}

