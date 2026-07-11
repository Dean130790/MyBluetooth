//
//  AppStore.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 09/07/26.
//

import Foundation

@MainActor
@Observable
final class AppStore {

    // MARK: - Internals
    private(set) var state: AppState

    // MARK: - Dependencies
    private let repository: BluetoothRepositoryProtocol

    private var subscriptionTask: Task<Void, Never>?


    // MARK: - Init
    init(repository: BluetoothRepositoryProtocol) {
        self.state = AppState()
        self.repository = repository
        send(.onAppear)
    }


    // MARK: - Actions
    func send(_ action: AppAction) {
        switch action {
        case .onAppear:
            observeRepository()
        case .onDisappear:
            subscriptionTask?.cancel()
            subscriptionTask = nil
        case .connect(let deviceID):
            repository.connect(deviceID: deviceID)
        case .detail(let detailAction):
            switch detailAction {
            case .onAppear(let deviceID):
                if let deviceIndex = index(id: deviceID, devices: state.myDevices) {
                    state.device = state.myDevices[deviceIndex]
                }
            case .forgetDevice(let deviceID):
                repository.forgetDevice(deviceID: deviceID)
            }
        }
    }

    private func removeDevice(_ deviceID: DeviceID) {
        guard let index = state.myDevices.firstIndex(where: { $0.id == deviceID }) else { return }
        state.myDevices.remove(at: index)
    }


    // MARK: - Repository observer
    private func observeRepository() {
        guard subscriptionTask == nil else { return }
        subscriptionTask = Task { [repository] in
            let stream = repository.events()
            for await event in stream {
                handle(event)
            }
        }
    }


    // MARK: - BluetoothEvent handler
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
                state.otherDevices[index].update(from: device)
            } else if let index = index(id: device.id, devices: state.myDevices) {
                state.myDevices[index].update(from: device)
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
        case .forgotDevice(let deviceID):
            removeDevice(deviceID)
        case .connectionFailed(_, let error):
            print("===connectionFailed===")
            print("Error: \(error.localizedDescription)")
        case .servicesDiscovered(let deviceID, let services):
            if let index = index(id: deviceID, devices: state.otherDevices) {
                state.otherDevices[index].services = services
            } else if let index = index(id: deviceID, devices: state.myDevices) {
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


    // MARK: - Private helpers
    private func index(id: DeviceID, devices: [BluetoothDevice]) -> Int? {
        devices.firstIndex(where: { $0.id == id })
    }

    private func index(id: ServiceID, services: [BluetoothService]) -> Int? {
        services.firstIndex(where: { $0.id == id })
    }
}

