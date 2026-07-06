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
    
    private let manager: BluetoothManagerProtocol
    private let eventEmitter = EventEmitter<BluetoothEvent>()
    
    
    init(manager: BluetoothManagerProtocol) {
        self.manager = manager
        observeManager()
    }
    
    func observeManager() {
        manager.events { [weak self] event in
            self?.send(event)
        }
    }
    
    func startScan() {
        manager.startScan()
    }
    
    func stopScan() {
        manager.stopScan()
    }
    
    func connect(deviceID: UUID) {
        manager.connect(deviceID: deviceID)
    }
    
    func disconnect(deviceID: UUID) {
        manager.disconnect(deviceID: deviceID)
    }
    
    func events(_ observer: @escaping @MainActor (BluetoothEvent) -> Void) {
        eventEmitter.observe(observer)
    }
    
    private func send(_ event: BluetoothEvent) {
        eventEmitter.send(event)
    }
}
