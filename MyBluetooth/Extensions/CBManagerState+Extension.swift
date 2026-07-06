//
//  CBManagerState+Extension.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import CoreBluetooth

extension CBManagerState {
    var covertToBluetoothState: BluetoothState {
        switch self {
        case .unknown:
            return .unknown
        case .resetting:
            return .resetting
        case .unsupported:
            return .unsupported
        case .unauthorized:
            return .unauthorized
        case .poweredOff:
            return .poweredOff
        case .poweredOn:
            return .poweredOn
        @unknown default:
            return .unknown
        }
    }
}
