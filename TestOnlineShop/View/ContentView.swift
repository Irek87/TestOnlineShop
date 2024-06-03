//
//  ContentView.swift
//  TestOnlineShop
//
//  Created by Reek i on 03.06.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var shoppingStorage = ShoppingStorage()
    @State private var pickerIsPresented: Bool = false
    @State private var shoppingCartIsPresented: Bool = false
    @State private var numberOfStuff: Int = 0
    @State private var buttonIsAnimated: Bool = false

    var body: some View {
        VStack(spacing: 32) {
            emblem
            Spacer()
            texts
            buttons
            Spacer()
            cartButton
        }
        .padding()
        .sheet(isPresented: $pickerIsPresented) {
            picker
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $shoppingCartIsPresented) {
            ShoppingCartView(shoppingStorage: shoppingStorage)
        }
    }
}

private extension ContentView {
    var emblem: some View {
        Image("topImage")
            .resizable()
            .scaledToFit()
    }

    var texts: some View {
        VStack(spacing: 8) {
            Text("Welcome to our shop!")
                .font(.largeTitle.bold())
                .foregroundStyle(.red)

            Text("Choose what you would like to buy")
                .font(.title3)
        }
    }

    var buttons: some View {
        VStack(spacing: 16) {
            Button {
                addCourseToCart()
            } label: {
                HStack {
                    Image(systemName: "graduationcap.circle")
                    Text("English course")
                }
            }
            .buttonStyle(MyButtonStyle())

            Button {
                pickerIsPresented.toggle()
            } label: {
                HStack {
                    Image(systemName: "book.closed.circle")
                    Text("Some stuff")
                }
            }
            .buttonStyle(MyButtonStyle())
        }
    }

    var picker: some View {
        VStack {
            Text("Choose desired number")
                .font(.title3)

            Picker("", selection: $numberOfStuff) {
                ForEach(0..<100, id: \.self) {
                    Text("\($0)")
                }
            }
            .pickerStyle(.wheel)

            Button {
                if numberOfStuff > 0 {
                    shoppingStorage.order.merge([.stuff : numberOfStuff], uniquingKeysWith: +)
                }
                pickerIsPresented = false
            } label: {
                Text("Submit")
            }
            .buttonStyle(MyButtonStyle())
        }
        .padding(.horizontal)
    }

    var cartButton: some View {
        Button {
            shoppingCartIsPresented.toggle()
        } label: {
            Image(systemName: "cart.circle.fill")
                .resizable()
                .foregroundStyle(.indigo)
                .frame(width: 48, height: 48)
        }
        .buttonStyle(.plain)
        .overlay {
            Text("\(shoppingStorage.getNumber() > 99 ? "99+" : "\(shoppingStorage.getNumber())")")
                .foregroundStyle(.white)
                .padding(6)
                .background(Color.red.clipShape(.circle))
                .offset(x: 20, y: -20)
        }
        .background(pulsatingCircle)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    var pulsatingCircle: some View {
        Circle()
            .foregroundStyle(.white)
            .frame(width: 46, height: 46)
            .background(
                Circle()
                    .foregroundStyle(.indigo)
                    .frame(width: 48, height: 48)
                    .blur(radius: 5)
                    .scaleEffect(buttonIsAnimated ? 1.3 : 1)
                    .onAppear { buttonIsAnimated.toggle() }
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(),
                        value: buttonIsAnimated
                    )
            )
    }

    func addCourseToCart() {
        shoppingStorage.order.updateValue(1, forKey: .course)
    }
}

#Preview {
    ContentView()
}
