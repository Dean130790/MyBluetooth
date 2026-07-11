//
//  BluetoothManager.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import CoreBluetooth

final class BluetoothManager: NSObject, BluetoothManagerProtocol, @unchecked Sendable {

    // MARK: - Dependencies
    private var centralManager: CBCentralManager!
    
    // MARK: - Internals
    private let centralQueue = DispatchQueue(label: "com.app.ble.central", qos: .userInitiated)

    private var peripheralContexts: [DeviceID: PeripheralContext] = [:]
    private let eventBroadcaster = EventBroadcaster<BluetoothEvent>()


    // MARK: - Init
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }

    // MARK: - Call backs
    func events(_ observer: @escaping @Sendable (BluetoothEvent) -> Void) {
        eventBroadcaster.observe(observer)
    }

    func send(_ event: BluetoothEvent) {
        eventBroadcaster.send(event)
    }

    
    // MARK: - Scan
    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        send(.scanStarted)
        centralManager.scanForPeripherals(withServices: nil,options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func stopScan() {
        centralManager.stopScan()
        send(.scanStopped)
    }
    
    
    // MARK: - Connect/Disconnect
    func connect(deviceID: DeviceID) {
        guard let peripheralContexts = peripheralContexts[deviceID] else { return }
        send(.connectionStateChanged(peripheralContexts.peripheral.deviceID, .connecting))
        centralManager.connect(peripheralContexts.peripheral)
    }
    
    func disconnect(deviceID: DeviceID) {
        guard let peripheral = peripheralContexts[deviceID]?.peripheral else { return }
        send(.connectionStateChanged(deviceID, .disconnecting))
        centralManager.cancelPeripheralConnection(peripheral)
    }

    func forgetDevice(deviceID: DeviceID) {
        guard let peripheralContext = peripheralContexts[deviceID] else { return }
        if peripheralContext.peripheral.state == .connected {
            peripheralContext.isManualDisconnect = true
            disconnect(deviceID: deviceID)
        } else {
            peripheralContexts.removeValue(forKey: deviceID)
            send(.forgotDevice(deviceID))
        }
    }

    
    // MARK: - GATT
    func discoverServices(deviceID: DeviceID) {
        guard let deviceContext = peripheralContexts[deviceID] else { return }
        deviceContext.peripheral.discoverServices(nil)
    }
    
    func discoverCharacteristics(serviceID: ServiceID, deviceID: DeviceID) {
        guard let deviceContext = peripheralContexts[deviceID], let serviceContext = deviceContext.services[serviceID] else { return }
        deviceContext.peripheral.discoverCharacteristics(nil, for: serviceContext.service)
    }
    
    // MARK: - Read, Write and Notify
    func read(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        guard let deviceContext = peripheralContexts[deviceID], let serviceContext = deviceContext.services[serviceID], let characteristic = serviceContext.characteristics[characteristicID] else { return }
        if characteristic.properties.contains(.read) {
            deviceContext.peripheral.readValue(for: characteristic)
        }
    }
    
    func write(_ data: Data, characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        guard let deviceContext = peripheralContexts[deviceID], let serviceContext = deviceContext.services[serviceID], let characteristic = serviceContext.characteristics[characteristicID] else { return }
        if characteristic.properties.contains(.write) {
            deviceContext.peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
    
    func subscribe(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        setSubscribed(true, characteristicID: characteristicID, serviceID: serviceID, deviceID: deviceID)
    }
    
    func unsubscribe(characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        setSubscribed(false, characteristicID: characteristicID, serviceID: serviceID, deviceID: deviceID)
    }

    
    // MARK: - Private helpers
    private func setSubscribed(_ isSubscribed: Bool, characteristicID: CharacteristicID, serviceID: ServiceID, deviceID: DeviceID) {
        guard let deviceContext = peripheralContexts[deviceID], let serviceContext = deviceContext.services[serviceID], let characteristic = serviceContext.characteristics[characteristicID] else { return }
        if characteristic.properties.contains(.notify) {
            deviceContext.peripheral.setNotifyValue(isSubscribed, for: characteristic)
        }
    }
    
    
    // MARK: - Public helpers
    func context(for deviceID: DeviceID) -> PeripheralContext? {
        peripheralContexts[deviceID]
    }
    
    func setContext(_ context: PeripheralContext, for deviceID: DeviceID) {
        peripheralContexts[deviceID] = context
    }

    func removeContext(for deviceID: DeviceID) {
        peripheralContexts.removeValue(forKey: deviceID)
    }
}
