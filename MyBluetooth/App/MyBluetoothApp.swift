//
//  MyBluetoothApp.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct MyBluetoothApp: App {
    
    private let store: StoreOf<AppFeature>
    
    init() {
        store = Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
    }
}
