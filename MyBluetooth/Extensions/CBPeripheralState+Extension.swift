//
//  CBPeripheralState+Extension.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import CoreBluetooth

extension CBPeripheralState {
    var covertToConnectionState: ConnectionState {
        switch self {
        case .connected:
            return .connected
        case .connecting:
            return .connecting
        case .disconnected:
            return .disconnected
        case .disconnecting:
            return .disconnecting
        @unknown default:
            return .disconnected
        }
    }
}
