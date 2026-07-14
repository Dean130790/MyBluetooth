//
//  MainView.swift
//  BluetoothView
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {

    var store: StoreOf<AppFeature>

    var tapOnDeviceInfo: (BluetoothDevice) -> Void


    var body: some View {
        NavigationStack {
            List {
                MainViewSection(store: store)

                if store.state.bluetoothEnabled {
                    myDevicesSection
                    otherDevicesSection
                }
            }
            .onAppear{
                store.send(.onAppear)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Bluetooth")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.visible)
        }
    }
}

private extension MainView {
    var myDevicesSection: some View {
        Section("My Devices") {
            if store.state.myDevices.isEmpty {
                HStack {
                    Text("No devices found.")
                    Spacer()
                }
            } else {
                ForEach(store.state.myDevices) { device in
                    MainViewCell(cellType: .myDevices, device: device, tapOnDevice: { device in
                        guard device.connectionState == .disconnected else { return }
                        store.send(.connect(device.id))
                    }, tapOnDeviceInfo: { device in
                        tapOnDeviceInfo(device)
                    })
                }
            }
        }
    }
}

private extension MainView {
    var otherDevicesSection: some View {
        Section {
            if store.state.otherDevices.isEmpty {
                Text("No devices found")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 6)
            } else {
                ForEach(store.state.otherDevices) { device in
                    MainViewCell(cellType: .otherDevices, device: device) { device in
                        store.send(.connect(device.id))
                    } tapOnDeviceInfo: { _ in }
                }
            }
        } header: {
            HStack(spacing: 8) {
                Text("Other Devices")
                ProgressView()
                    .opacity(store.state.isScanning ? 1 : 0)
            }
        }
    }
}
