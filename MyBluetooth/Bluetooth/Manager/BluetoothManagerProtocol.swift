//
//  BluetoothManagerProtocol.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 02/07/26.
//

import Foundation

@MainActor
protocol BluetoothManagerProtocol: AnyObject {
    // MARK: - Scan
    func startScan()
    func stopScan()

    // MARK: - Connection
    func connect(deviceID: DeviceID)
    func disconnect(deviceID: DeviceID)
    func forgetDevice(deviceID: DeviceID)

    // MARK: - GATT
    func discoverServices(deviceID: DeviceID)
    func discoverCharacteristics(serviceID: ServiceID, deviceID: DeviceID)
    func read(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID)
    func write(_ data: Data, characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID)
    func subscribe(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID)
    func unsubscribe(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID)

    // MARK: - Events
    func events(_ observer: @escaping @MainActor (BluetoothEvent) -> Void)
}
