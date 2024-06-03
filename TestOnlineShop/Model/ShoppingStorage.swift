//
//  ShoppingStorage.swift
//  TestOnlineShop
//
//  Created by Reek i on 03.06.2024.
//

import Foundation

final class ShoppingStorage: ObservableObject {
    @Published var order = [ProductTypes: Int]()

    func getNumber() -> Int {
        order.values.reduce(0, +)
    }

    func getTotalPrice() -> Int {
        var result = 0

        order.forEach { key, value in
            switch key {
            case .course:
                result += key.price
            case .stuff:
                result += key.price * (order[key] ?? 0)
            }
        }

        return result
    }
}

enum ProductTypes: String, Equatable, Identifiable {
    case course, stuff

    var id: String {
        self.rawValue
    }

    var imageName: String {
        switch self {
        case .course:
            "book"
        case .stuff:
            "course"
        }
    }

    var price: Int {
        switch self {
        case .course:
            100
        case .stuff:
            10
        }
    }
}
