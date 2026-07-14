//
//  RootView.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: StoreOf<AppFeature>

    @State private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            MainView(store: store, tapOnDeviceInfo: { device in
                router.push(.deviceDetails(device: device))
            })
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .deviceDetails (let device):
                    let store = Store(initialState: DetailFeature.State(device: device)) { DetailFeature() }
                    DetailsView(store: store)
                }
            }
        }
    }
}
