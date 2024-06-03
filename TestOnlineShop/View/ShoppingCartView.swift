//
//  ShoppingCartView.swift
//  TestOnlineShop
//
//  Created by Reek i on 03.06.2024.
//

import SwiftUI

struct ShoppingCartView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var shoppingStorage: ShoppingStorage
    @State private var isInProgress: Bool = false
    @State private var isError: Bool = false
    @State private var isSuccess: Bool = false

    var body: some View {
        VStack {
            header
            items
            HStack {
                Text("Total")
                    .font(.title3.bold())

                Spacer()

                Text(shoppingStorage.getTotalPrice(), format: .currency(code: "USD"))
                    .bold()
            }
            .padding(.vertical)

            Button {
                pay()
            } label: {
                Text("Pay")
            }
            .buttonStyle(MyButtonStyle())
            .disabled(shoppingStorage.order.isEmpty)

            Spacer()
        }
        .padding()
        .overlay {
            if isInProgress {
                progressView
            }
        }
        .alert(
            "Something went wrong",
            isPresented: $isError,
            actions: {},
            message: {
                Text("Please try again later")
            }
        )
        .alert(
            "Success!",
            isPresented: $isSuccess,
            actions: {
                Button("Empty the cart") {
                    shoppingStorage.order.removeAll()
                }

                Button("Leave all items in the cart") {}
            },
            message: {
                Text("Thank you for the payment")
            }
        )
    }
}

private extension ShoppingCartView {
    var header: some View {
        VStack(spacing: 0) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
            .tint(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("Shopping cart")
                .font(.title.bold())

            Divider()
                .padding()
        }
    }

    var items: some View {
        ForEach(shoppingStorage.order.keys.sorted(by: { $0.id < $1.id })) { item in
            getViewFor(item)
            Divider()
        }
    }

    var progressView: some View {
        Group {
            Color.black
                .opacity(0.2)
                .ignoresSafeArea()
            ProgressView()
                .controlSize(.extraLarge)
                .padding()
                .background(.thickMaterial)
                .clipShape(.rect(cornerRadius: 16))
        }
    }

    func getViewFor(_ item: ProductTypes) -> some View {
        HStack {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100)

            VStack(alignment: .leading) {
                Text(item.rawValue.capitalized)

                Spacer()
                
                HStack {
                    Text(item.price, format: .currency(code: "USD"))

                    Spacer()

                    switch item {
                    case .course:
                        Button(role: .destructive) {
                            shoppingStorage.order.removeValue(forKey: .course)
                        } label: {
                            Text("Remove")
                        }
                    case .stuff:
                        Stepper("x \(shoppingStorage.order[.stuff] ?? 0)") {
                            shoppingStorage.order.merge([.stuff : 1], uniquingKeysWith: +)
                        } onDecrement: {
                            guard let numberOfStuff = shoppingStorage.order[.stuff],
                                  numberOfStuff > 1 else {
                                shoppingStorage.order.removeValue(forKey: .stuff)
                                return
                            }

                            shoppingStorage.order.merge([.stuff : 1], uniquingKeysWith: -)
                        }
                    }
                }
            }
            .padding()
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func pay() {
        Task { @MainActor in
            isInProgress = true

            do {
                try await NetworkManager.shared.pay()
                isInProgress = false
                isSuccess = true
            } catch {
                isInProgress = false
                isError = true
            }
        }
    }
}

#Preview {
    let storage = ShoppingStorage()
    storage.order.updateValue(1, forKey: .course)
    storage.order.updateValue(3, forKey: .stuff)

    return ShoppingCartView(shoppingStorage: storage)
}
