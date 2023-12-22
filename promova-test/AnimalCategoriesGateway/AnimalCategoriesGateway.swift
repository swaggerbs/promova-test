//
//  AnimalCategoriesGateway.swift
//  promova-test
//

import Foundation
import Dependencies

struct AnimalCategoriesGateway {
  var fetch: () async throws -> String
}

extension AnimalCategoriesGateway: DependencyKey {
    static let liveValue = Self(
        fetch: {
            let (data, _) = try await URLSession.shared
                .data(from: .init(string: "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

extension DependencyValues {
    var animalCategories: AnimalCategoriesGateway {
        get { self[AnimalCategoriesGateway.self] }
        set { self[AnimalCategoriesGateway.self] = newValue }
    }
}

