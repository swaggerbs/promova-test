//
//  AnimalCategoryItem.swift
//  promova-test
//

import Foundation
import SwiftUI

enum CategoryState: LocalizedStringKey {
    case free
    case paid = "Premium"
    case comingSoon
}

struct AnimalCategoryModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    var state: CategoryState
    let imageUrl: URL?
    let facts: [FactModel]
}

struct FactModel: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let imageUrl: URL
}
