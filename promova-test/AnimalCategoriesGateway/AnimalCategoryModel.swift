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
    let state: CategoryState
    let imageUrl: URL?
}
