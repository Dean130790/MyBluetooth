//
//  BluetoothCharacteristicProperties+CoreBluetooth.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 09/07/26.
//

import CoreBluetooth

extension BluetoothCharacteristicProperties {
    init(coreBluetoothProperties: CBCharacteristicProperties) {

        self = []

        if coreBluetoothProperties.contains(.broadcast) {
            insert(.broadcast)
        }

        if coreBluetoothProperties.contains(.read) {
            insert(.read)
        }

        if coreBluetoothProperties.contains(.writeWithoutResponse) {
            insert(.writeWithoutResponse)
        }

        if coreBluetoothProperties.contains(.write) {
            insert(.write)
        }

        if coreBluetoothProperties.contains(.notify) {
            insert(.notify)
        }

        if coreBluetoothProperties.contains(.indicate) {
            insert(.indicate)
        }

        if coreBluetoothProperties.contains(.authenticatedSignedWrites) {
            insert(.authenticatedSignedWrites)
        }

        if coreBluetoothProperties.contains(.extendedProperties) {
            insert(.extendedProperties)
        }

        if coreBluetoothProperties.contains(.notifyEncryptionRequired) {
            insert(.notifyEncryptionRequired)
        }

        if coreBluetoothProperties.contains(.indicateEncryptionRequired) {
            insert(.indicateEncryptionRequired)
        }
    }
}
