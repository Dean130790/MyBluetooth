//
//  RootView.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import SwiftUI

struct RootView: View {
    
    let store: BluetoothViewStore

    @State private var router = AppRouter()
    
    
    var body: some View {
        NavigationStack(path: $router.path) {
            BluetoothView(store: store, tapOnDeviceInfo: { device in
                router.push(.deviceDetails(id: device.id))
            })
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .deviceDetails (let id):
                    BluetoothDetailsView(deviceID: id, store: store)
                }
            }
        }
    }
}
