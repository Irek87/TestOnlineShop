//
//  NetworkManager.swift
//  TestOnlineShop
//
//  Created by Reek i on 03.06.2024.
//

import Foundation

final class NetworkManager {
    static var shared = NetworkManager()

    private init() {}

    func pay() async throws {
        try await Task.sleep(for: .seconds(1))

        // random result of our request
        if Bool.random() {
            throw URLError(.cancelled)
        }
    }
}
