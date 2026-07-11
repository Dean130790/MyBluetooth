//
//  BluetoothRepository.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import Foundation

actor BluetoothRepository: BluetoothRepositoryProtocol {

    // MARK: - Dependencies
    private let manager: BluetoothManagerProtocol

    // MARK: - Internals
    private let eventEmitter: EventEmitter<BluetoothEvent>
    private let primaryStream: AsyncStream<BluetoothEvent>


    // MARK: - Init
    init(manager: BluetoothManagerProtocol) {
        self.manager = manager

        self.eventEmitter = EventEmitter<BluetoothEvent>()
        let (stream, id, continuation) = eventEmitter.makeStream()
        self.primaryStream = stream
        Task { await eventEmitter.register(continuation, id: id) }

        observeManager()
    }


    // MARK: - Manager observer
    nonisolated private func observeManager() {
        manager.events { [weak self] event in
            Task { await self?.send(event) }
        }
    }

    // MARK: - Events async stream
    nonisolated func events() -> AsyncStream<BluetoothEvent> {
        primaryStream
    }

    func send(_ event: BluetoothEvent) async {
        await eventEmitter.send(event)
    }


    // MARK: - Scan
    nonisolated func startScan() {
        manager.startScan()
    }

    nonisolated func stopScan() {
        manager.stopScan()
    }


    // MARK: - Connect/Disconnect
    nonisolated func connect(deviceID: DeviceID) {
        manager.connect(deviceID: deviceID)
    }

    nonisolated func disconnect(deviceID: DeviceID) {
        manager.disconnect(deviceID: deviceID)
    }

    nonisolated func forgetDevice(deviceID: DeviceID) {
        manager.forgetDevice(deviceID: deviceID)
    }


    // MARK: - Discover Services and Characteristics
    nonisolated func discoverServices(deviceID: DeviceID) {
        manager.discoverServices(deviceID: deviceID)
    }

    nonisolated func discoverCharacteristics(serviceID: ServiceID, deviceID: DeviceID) {
        manager.discoverCharacteristics(serviceID: serviceID, deviceID: deviceID)
    }


    // MARK: - Read, Write and Notify
    nonisolated func read(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        manager.read(characteristicID: characteristicID, serviceID: serviceID, deviceID: deviceID)
    }

    nonisolated func write(_ data: Data, characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        manager.write(data, characteristicID: characteristicID, serviceID: serviceID, deviceID: deviceID)
    }

    nonisolated func subscribe(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        manager.subscribe(characteristicID: characteristicID, serviceID: serviceID, deviceID: deviceID)
    }

    nonisolated func unsubscribe(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        manager.unsubscribe(characteristicID: characteristicID, serviceID: serviceID, deviceID: deviceID)
    }
}
