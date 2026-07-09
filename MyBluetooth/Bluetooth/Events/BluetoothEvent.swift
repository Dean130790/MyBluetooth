//
//  BluetoothEvent.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 02/07/26.
//

import Foundation

enum BluetoothEvent: Sendable {
    // MARK: - Scan
    case scanStarted
    case scanStopped

    // MARK: - State
    case stateChanged(BluetoothState)

    // MARK: - Connection
    case deviceDiscovered(BluetoothDevice)
    case connectionStateChanged(DeviceID, ConnectionState)
    case connectionFailed(DeviceID, BluetoothError)

    // MARK: - GATT
    case servicesDiscovered(deviceID: DeviceID, services: [BluetoothService])
    case servicesDiscoveryFailed(deviceID: DeviceID, error: Error)
    case characteristicsDiscovered(deviceID: DeviceID, serviceID: ServiceID, characteristics: [BluetoothCharacteristic])
    case characteristicsDiscoveryFailed(deviceID: DeviceID, serviceID: ServiceID, error: Error)
    case notified(deviceID: DeviceID, characteristicID: CharacteristicID, isNotifying: Bool)
    case notifyFailed(deviceID: DeviceID, characteristicID: CharacteristicID, error: Error)
    case read(deviceID: DeviceID, characteristicID: CharacteristicID, data: Data)
    case readFailed(deviceID: DeviceID, characteristicID: CharacteristicID, error: Error)
    case write(deviceID: DeviceID, characteristicID: CharacteristicID)
    case writeFailed(deviceID: DeviceID, characteristicID: CharacteristicID, error: Error)
}
