//
//  BluetoothRepository.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import Foundation

@MainActor
@Observable
final class BluetoothRepository: BluetoothRepositoryProtocol {
    
    // MARK: - Dependencies
    private let manager: BluetoothManagerProtocol
    
    // MARK: - Internals
    private let eventEmitter = EventEmitter<BluetoothEvent>()
    
    
    // MARK: - Init
    init(manager: BluetoothManagerProtocol) {
        self.manager = manager
        observeManager()
    }
    
    func observeManager() {
        manager.events { [weak self] event in
            self?.send(event)
        }
    }
    
    
    // MARK: - Scan
    func startScan() {
        manager.startScan()
    }
    
    func stopScan() {
        manager.stopScan()
    }
    
    
    // MARK: - Connect/Disconnect
    func connect(deviceID: DeviceID) {
        manager.connect(deviceID: deviceID)
    }
    
    func disconnect(deviceID: DeviceID) {
        manager.disconnect(deviceID: deviceID)
    }

    func forgetDevice(deviceID: DeviceID) {
        manager.forgetDevice(deviceID: deviceID)
    }

    
    // MARK: - Events call backs
    func events(_ observer: @escaping @MainActor (BluetoothEvent) -> Void) {
        eventEmitter.observe(observer)
    }
    
    private func send(_ event: BluetoothEvent) {
        eventEmitter.send(event)
    }
    
    
    // MARK: - Discover Services and Characteristics
    func discoverServices(deviceID: DeviceID) {
        manager.discoverServices(deviceID: deviceID)
    }
    
    func discoverCharacteristics(serviceID: ServiceID, deviceID: DeviceID) {
        manager.discoverCharacteristics(serviceID: serviceID, deviceID: deviceID)
    }
    
    
    // MARK: - Read, Write and Notify
    func read(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        manager.read(characteristicID: characteristicID, serviceID: serviceID, deviceID: deviceID)
    }
    
    func write(_ data: Data, characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        manager.write(data, characteristicID: characteristicID, serviceID: serviceID, deviceID: deviceID)
    }
    
    func subscribe(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        manager.subscribe(characteristicID: characteristicID, serviceID: serviceID, deviceID: deviceID)
    }
    
    func unsubscribe(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        manager.unsubscribe(characteristicID: characteristicID, serviceID: serviceID, deviceID: deviceID)
    }
}
