//
//  BluetoothDetailsViewState.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import Foundation

struct BluetoothDetailsViewState {
    let deviceID: UUID
    var device: BluetoothDevice?
    var isDisconnecting = false
    var error: String?

    init(deviceID: UUID, device: BluetoothDevice? = nil) {
        self.deviceID = deviceID
        self.device = device
    }
}

