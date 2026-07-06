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
            if let index = indexInOtherDevices(id: device.id) {
                self.state.otherDevices[index] = device
            } else if let index = indexInMyDevices(id: device.id) {
                self.state.myDevices[index] = device
            } else {
                state.otherDevices.append(device)
            }
        case .connectionStateChanged(let deviceID, let connectionState):
            switch connectionState {
            case .connected:
                if let index = indexInOtherDevices(id: deviceID) {
                    var device = state.otherDevices.remove(at: index)
                    device.connectionState = .connected
                    device.lastSeen = .now
                    state.myDevices.append(device)
                } else if let index = indexInMyDevices(id: deviceID) {
                    state.myDevices[index].connectionState = .connected
                    state.myDevices[index].lastSeen = .now
                }
            case .disconnected:
                //Manuall disconnect via CTA
                //                if let index = indexInOtherDevices(id: deviceID) {
                //                    self.state.myDevices.remove(at: index)
                //                }
                if let index = indexInMyDevices(id: deviceID) {
                    state.myDevices[index].connectionState = .disconnected
                    state.myDevices[index].lastSeen = .now
                }
            case .connecting, .disconnecting:
                if let index = indexInMyDevices(id: deviceID) {
                    state.myDevices[index].connectionState = connectionState
                } else if let index = indexInOtherDevices(id: deviceID) {
                    state.otherDevices[index].connectionState = connectionState
                }
            }
        case .connectionFailed(_, let error):
            state.error = error.localizedDescription
        }
    }

    private func indexInMyDevices(id: UUID) -> Int? {
        self.state.myDevices.firstIndex(where: { $0.id == id })
    }

    private func indexInOtherDevices(id: UUID) -> Int? {
        self.state.otherDevices.firstIndex(where: { $0.id == id })
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

    func forget(_ device: BluetoothDevice) {
        guard let index = state.myDevices.firstIndex(where: { $0.id == device.id }) else { return }
        state.myDevices.remove(at: index)
    }
}
