//
//  BluetoothViewState.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import Foundation

struct BluetoothViewState {
    var bluetoothState: BluetoothState = .unknown
    var isScanning = false
    var myDevices: [BluetoothDevice] = []
    var otherDevices: [BluetoothDevice] = []
    
    var bluetoothEnabled: Bool {
        bluetoothState == .poweredOn
    }
}
