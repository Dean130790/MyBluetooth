//
//  AppFeature.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 14/07/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {

    @ObservableState
    struct State: Equatable {
        var bluetoothState: BluetoothState = .unknown
        var isScanning = false
        var myDevices: [BluetoothDevice] = []
        var otherDevices: [BluetoothDevice] = []
        @Presents var detail: DetailFeature.State?

        var bluetoothEnabled: Bool {
            bluetoothState == .poweredOn
        }
    }

    enum Action {
        case onAppear
        case onDisappear
        case bluetoothEvent(BluetoothEvent)
        case connect(DeviceID)
        case detail(PresentationAction<DetailFeature.Action>)
    }

    @Dependency(\.bluetoothRepository) var repository

    private enum CancelID { case subscription }


    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    for await event in repository.events() {
                        await send(.bluetoothEvent(event))
                    }
                }
                .cancellable(id: CancelID.subscription)
            case .bluetoothEvent(let event):
                return handle(event, state: &state)
            case .onDisappear:
                return .cancel(id: CancelID.subscription)
            case .connect(let deviceID):
                return .run { send in repository.connect(deviceID: deviceID) }
            case .detail:
                return .none
            }
        }
    }


    // MARK: - BluetoothEvent handler
    private func handle(_ event: BluetoothEvent, state: inout State) -> Effect<Action> {
        switch event {
        case .stateChanged(let bluetoothState):
            state.bluetoothState = bluetoothState
            return .run { _ in
                if bluetoothState == .poweredOn {
                    repository.startScan()
                } else {
                    repository.stopScan()
                }
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
            if let index = state.myDevices.firstIndex(where: { $0.id == deviceID }) {
                state.myDevices.remove(at: index)
            }
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
        return .none
    }


    // MARK: - Private helpers
    private func index(id: DeviceID, devices: [BluetoothDevice]) -> Int? {
        devices.firstIndex(where: { $0.id == id })
    }

    private func index(id: ServiceID, services: [BluetoothService]) -> Int? {
        services.firstIndex(where: { $0.id == id })
    }
}
