//
//  BluetoothEvent.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 02/07/26.
//

import Foundation

enum BluetoothEvent: Sendable {
    case stateChanged(BluetoothState)
    case scanStarted
    case scanStopped
    case deviceDiscovered(BluetoothDevice)
    case connectionStateChanged(UUID, ConnectionState)
    case connectionFailed(UUID, BluetoothError)
}
