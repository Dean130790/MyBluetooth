//
//  MyBluetoothApp.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import SwiftUI

@main
struct MyBluetoothApp: App {

    private let store: AppStore

    init() {
        let manager: BluetoothManagerProtocol = BluetoothManager()
        let repository: BluetoothRepositoryProtocol = BluetoothRepository(manager: manager)
        store = AppStore(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
    }
}
