//
//  CBPeripheral+Extension.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 09/07/26.
//

import CoreBluetooth

extension CBPeripheral {
    var deviceID: DeviceID {
        DeviceID(rawValue: self.identifier.uuidString)
    }
}
