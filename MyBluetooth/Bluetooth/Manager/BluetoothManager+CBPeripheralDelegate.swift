//
//  BluetoothManager+CBPeripheralDelegate.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 09/07/26.
//

import CoreBluetooth

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error {
            send(.servicesDiscoveryFailed(deviceID: peripheral.deviceID, error: error))
            return
        }
        
        guard let services = peripheral.services, let context = context(for: peripheral.deviceID) else { return }
        
        context.services = Dictionary(uniqueKeysWithValues: services.map { ($0.serviceID, ServiceContext(service: $0)) })
        
        let bluetoothServices = services.map { service in
            BluetoothService(id: service.serviceID, isPrimary: service.isPrimary)
        }
        
        send(.servicesDiscovered(deviceID: peripheral.deviceID, services: bluetoothServices))
        
        services.forEach {
            peripheral.discoverCharacteristics(nil, for: $0)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error {
            send(.characteristicsDiscoveryFailed(deviceID: peripheral.deviceID, serviceID: service.serviceID, error: error))
            return
        }
        
        guard let characteristics = service.characteristics, let peripheralContext = context(for: peripheral.deviceID), let serviceContext = peripheralContext.services[service.serviceID] else { return }
        
        serviceContext.characteristics = Dictionary(uniqueKeysWithValues: characteristics.map { ($0.characteristicID, $0) })
        
        let bluetoothCharacteristics = characteristics.map { characteristic in
            BluetoothCharacteristic(id: characteristic.characteristicID, properties: BluetoothCharacteristicProperties(
                coreBluetoothProperties: characteristic.properties
            ), value: characteristic.value)
        }
        
        send(.characteristicsDiscovered(deviceID: peripheral.deviceID, serviceID: service.serviceID, characteristics: bluetoothCharacteristics))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error {
            send(.readFailed(deviceID: peripheral.deviceID, characteristicID: characteristic.characteristicID, error: error))
            return
        }
        guard let value = characteristic.value else { return }
        send(.read(deviceID: peripheral.deviceID, characteristicID: characteristic.characteristicID, data: value))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if let error {
            send(.writeFailed(deviceID: peripheral.deviceID, characteristicID: characteristic.characteristicID, error: error))
            return
        }
        send(.write(deviceID: peripheral.deviceID, characteristicID: characteristic.characteristicID))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: (any Error)?) {
        if let error {
            send(.notifyFailed(deviceID: peripheral.deviceID, characteristicID: characteristic.characteristicID, error: error))
            return
        }
        send(.notified(deviceID: peripheral.deviceID, characteristicID: characteristic.characteristicID, isNotifying: characteristic.isNotifying))
    }
}
