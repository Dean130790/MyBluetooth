//
//  AppState.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 09/07/26.
//

import Foundation

struct AppState {
    var bluetoothState: BluetoothState = .unknown
    var isScanning = false
    var myDevices: [BluetoothDevice] = []
    var otherDevices: [BluetoothDevice] = []
    var device: BluetoothDevice?

    var bluetoothEnabled: Bool {
        bluetoothState == .poweredOn
    }
}
