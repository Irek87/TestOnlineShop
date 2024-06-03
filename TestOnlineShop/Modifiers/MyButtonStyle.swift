//
//  MyButtonStyle.swift
//  TestOnlineShop
//
//  Created by Reek i on 03.06.2024.
//

import SwiftUI

struct MyButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.bold())
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Color.red
                    .opacity(isEnabled ? 1 : 0.5)
                    .clipShape(.capsule)
                    .shadow(radius: configuration.isPressed ? 0 : 5)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
