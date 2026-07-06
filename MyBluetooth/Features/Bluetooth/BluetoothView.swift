//
//  MyBluetoothApp.swift
//  BluetoothView
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import SwiftUI

struct BluetoothView: View {
    
    @State private var store: BluetoothViewStore
    
    var tapOnDeviceInfo: (BluetoothDevice) -> Void
    
    
    init(store: BluetoothViewStore, tapOnDeviceInfo: @escaping (BluetoothDevice) -> Void) {
        _store = State(initialValue: store)
        self.tapOnDeviceInfo = tapOnDeviceInfo
    }
    
    var body: some View {
        NavigationStack {
            List {
                BluetoothStatusSection(store: store)
                
                if store.state.bluetoothEnabled {
                    myDevicesSection
                    otherDevicesSection
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Bluetooth")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.visible)
        }
    }
}

private extension BluetoothView {
    var myDevicesSection: some View {
        Section("My Devices") {
            if store.state.myDevices.isEmpty {
                HStack {
                    Text("No devices found.")
                    Spacer()
                }
            } else {
                ForEach(store.state.myDevices) { device in
                    BluetoothDeviceRow(bluetoothDeviceRowType: .myDevices, device: device, tapOnDevice: { device in
                        guard device.connectionState == .disconnected else { return }
                        store.connect(device)
                    }, tapOnDeviceInfo: tapOnDeviceInfo)
                }
            }
        }
    }
}

private extension BluetoothView {
    var otherDevicesSection: some View {
        Section {
            if store.state.otherDevices.isEmpty {
                Text("No devices found")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 6)
            } else {
                ForEach(store.state.otherDevices) { device in
                    BluetoothDeviceRow(bluetoothDeviceRowType: .otherDevices, device: device) { device in
                        store.connect(device)
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
