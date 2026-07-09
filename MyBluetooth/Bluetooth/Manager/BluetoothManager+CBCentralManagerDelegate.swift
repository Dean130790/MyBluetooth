//
//  BluetoothManager+CBCentralManagerDelegate.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 09/07/26.
//

import CoreBluetooth

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

        setContext(PeripheralContext(peripheral: peripheral), for: peripheral.deviceID)

        let device = BluetoothDevice(
            id: peripheral.deviceID,
            name: name,
            rssi: RSSI.intValue,
            advertisementData: AdvertisementData(dictionary: advertisementData),
            connectionState: peripheral.state.covertToConnectionState
        )

        send(.deviceDiscovered(device))
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        send(.connectionStateChanged(peripheral.deviceID, peripheral.state.covertToConnectionState))
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        guard error == nil else  { return }

        if isManualDisconnect {
            isManualDisconnect = false
            removeContext(for: peripheral.deviceID)
            send(.forgotDevice(peripheral.deviceID))
        } else {
            send(.connectionStateChanged(peripheral.deviceID, peripheral.state.covertToConnectionState))
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        send(.connectionFailed(peripheral.deviceID,.connectionFailed))
    }
}
