//
//  BluetoothManager.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import CoreBluetooth

@MainActor
final class BluetoothManager: NSObject, BluetoothManagerProtocol {
    
    private var centralManager: CBCentralManager!
    private var peripherals: [UUID: CBPeripheral] = [:]
    private let eventEmitter = EventEmitter<BluetoothEvent>()
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        send(.scanStarted)
        centralManager.scanForPeripherals(withServices: nil,options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    func stopScan() {
        centralManager.stopScan()
        send(.scanStopped)
    }
    
    func connect(deviceID: UUID) {
        guard let peripheral = peripherals[deviceID] else { return }
        send(.connectionStateChanged(peripheral.identifier, .connecting))
        centralManager.connect(peripheral)
    }
    
    func disconnect(deviceID: UUID) {
        guard let peripheral = peripherals[deviceID] else { return }
        send(.connectionStateChanged(peripheral.identifier, .disconnecting))
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func events(_ observer: @escaping @MainActor (BluetoothEvent) -> Void) {
        eventEmitter.observe(observer)
    }
    
    private func send(_ event: BluetoothEvent) {
        eventEmitter.send(event)
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let state: BluetoothState
        switch central.state {
        case .poweredOn:
            state = .poweredOn
        case .poweredOff:
            state = .poweredOff
        case .unauthorized:
            state = .unauthorized
        case .unsupported:
            state = .unsupported
        case .resetting:
            state = .resetting
        default:
            state = .unknown
        }
        
        send(.stateChanged(state))
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = peripheral.name ?? advertisementData[CBAdvertisementDataLocalNameKey] as? String
        guard let name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        peripherals[peripheral.identifier] = peripheral
        let device = BluetoothDevice(
            id: peripheral.identifier,
            name: name,
            rssi: RSSI.intValue,
            advertisementData: AdvertisementData(dictionary: advertisementData),
            connectionState: peripheral.state.covertToConnectionState
        )
        
        send(.deviceDiscovered(device))
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        send(.connectionStateChanged(peripheral.identifier, peripheral.state.covertToConnectionState))
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        send(.connectionStateChanged(peripheral.identifier, peripheral.state.covertToConnectionState))
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        send(.connectionFailed(peripheral.identifier,.connectionFailed))
    }
}
