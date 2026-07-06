//
//  MyBluetoothApp.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import SwiftUI

@main
struct MyBluetoothApp: App {

    private let manager: BluetoothManagerProtocol
    private let repository: BluetoothRepositoryProtocol
    private let store: BluetoothViewStore

    init() {
        manager = BluetoothManager()
        repository = BluetoothRepository(manager: manager)
        store = BluetoothViewStore(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
    }
}
