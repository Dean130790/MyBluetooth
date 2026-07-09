//
//  BluetoothViewStore.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import Foundation

@MainActor
@Observable
final class BluetoothViewStore {
    
    private(set) var state = BluetoothViewState()
    private let repository: BluetoothRepositoryProtocol
    
    
    init(repository: BluetoothRepositoryProtocol) {
        self.repository = repository
        observeRepository()
    }
    
    private func observeRepository() {
        repository.events() { [weak self] event in
            self?.handle(event)
        }
    }
    
    private func handle(_ event: BluetoothEvent) {
        switch event {
        case .stateChanged(let state):
            self.state.bluetoothState = state
            if self.state.bluetoothEnabled {
                self.repository.startScan()
            } else {
                self.repository.stopScan()
            }
        case .scanStarted:
            state.isScanning = true
        case .scanStopped:
            state.isScanning = false
        case .deviceDiscovered(let device):
            if let index = index(id: device.id, devices: state.otherDevices) {
                self.state.otherDevices[index] = device
            } else if let index = index(id: device.id, devices: state.myDevices) {
                self.state.myDevices[index] = device
            } else {
                state.otherDevices.append(device)
            }
        case .connectionStateChanged(let deviceID, let connectionState):
            switch connectionState {
            case .connected:
                if let index = index(id: deviceID, devices: state.otherDevices) {
                    var device = state.otherDevices.remove(at: index)
                    device.connectionState = .connected
                    device.lastSeen = .now
                    state.myDevices.append(device)
                } else if let index = index(id: deviceID, devices: state.myDevices) {
                    state.myDevices[index].connectionState = .connected
                    state.myDevices[index].lastSeen = .now
                }
            case .disconnected:
                if let index = index(id: deviceID, devices: state.myDevices) {
                    state.myDevices[index].connectionState = .disconnected
                    state.myDevices[index].lastSeen = .now
                }
            case .connecting, .disconnecting:
                if let index = index(id: deviceID, devices: state.myDevices) {
                    state.myDevices[index].connectionState = connectionState
                } else if let index = index(id: deviceID, devices: state.otherDevices) {
                    state.otherDevices[index].connectionState = connectionState
                }
            }
        case .connectionFailed(_, let error):
            print("===connectionFailed===")
            print("Error: \(error.localizedDescription)")
        case .servicesDiscovered(let deviceID, let services):
            if let index = index(id: deviceID, devices: state.otherDevices) {
                state.otherDevices[index].services = services
            } else if let index = index(id: deviceID, devices: state.otherDevices) {
                state.myDevices[index].services = services
            }
        case .servicesDiscoveryFailed(let deviceID, let error):
            print("===servicesDiscoveryFailed===")
            print("deviceID: \(deviceID)")
            print("Error: \(error.localizedDescription)")
        case .characteristicsDiscovered(let deviceID, let serviceID, let characteristics):
            if let deviceIndex = index(id: deviceID, devices: state.otherDevices) {
                if let serviceIndex = index(id: serviceID, services: state.otherDevices[deviceIndex].services) {
                    state.otherDevices[deviceIndex].services[serviceIndex].characteristics = characteristics
                }
            } else if let deviceIndex = index(id: deviceID, devices: state.myDevices) {
                if let serviceIndex = index(id: serviceID, services: state.myDevices[deviceIndex].services) {
                    state.myDevices[deviceIndex].services[serviceIndex].characteristics = characteristics
                }
            }
        case .characteristicsDiscoveryFailed(let deviceID, let serviceID, let error):
            print("===characteristicsDiscoveryFailed===")
            print("deviceID: \(deviceID)")
            print("serviceID: \(serviceID)")
            print("Error: \(error.localizedDescription)")
        case .notified(let deviceID, let characteristicID, let isNotifying):
            print("===notified===")
            print("deviceID: \(deviceID)")
            print("characteristicID: \(characteristicID)")
            print("isNotifying: \(isNotifying)")
        case .notifyFailed(let deviceID, let characteristicID, let error):
            print("===notifyFailed===")
            print("deviceID: \(deviceID)")
            print("characteristicID: \(characteristicID)")
            print("Error: \(error.localizedDescription)")
        case .read(let deviceID, let characteristicID, let data):
            print("===readCompleted===")
            print("deviceID: \(deviceID)")
            print("characteristicID: \(characteristicID)")
            print("data: \(data.map { String(format: "%02x", $0) }.joined(separator: " "))")
        case .readFailed(let deviceID, let characteristicID, let error):
            print("===readCompleted===")
            print("deviceID: \(deviceID)")
            print("characteristicID: \(characteristicID)")
            print("Error: \(error.localizedDescription)")
        case .write(let deviceID, let characteristicID):
            print("===writeCompleted===")
            print("deviceID: \(deviceID)")
            print("characteristicID: \(characteristicID)")
        case .writeFailed(let deviceID, let characteristicID, let error):
            print("===writeCompleted===")
            print("deviceID: \(deviceID)")
            print("characteristicID: \(characteristicID)")
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func index(id: DeviceID, devices: [BluetoothDevice]) -> Int? {
        devices.firstIndex(where: { $0.id == id })
    }
    
    private func index(id: ServiceID, services: [BluetoothService]) -> Int? {
        services.firstIndex(where: { $0.id == id })
    }
    
    
    func startScan() {
        repository.startScan()
    }
    
    func stopScan() {
        repository.stopScan()
    }
    
    func connect(_ device: BluetoothDevice) {
        repository.connect(deviceID: device.id)
    }
    
    func disconnect(_ device: BluetoothDevice) {
        repository.disconnect(deviceID: device.id)
    }
    
    func forget(_ deviceID: DeviceID) {
        guard let index = state.myDevices.firstIndex(where: { $0.id == deviceID }) else { return }
        state.myDevices.remove(at: index)
    }
}
