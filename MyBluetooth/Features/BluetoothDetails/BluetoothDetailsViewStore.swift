//
//  BluetoothDetailsViewStore.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import Foundation

@MainActor
@Observable
final class BluetoothDetailsViewStore {
    private(set) var state: BluetoothDetailsViewState
    
    private let repository: BluetoothRepositoryProtocol
    
    private var observationTask: Task<Void, Never>?
    
    init(deviceID: UUID, repository: BluetoothRepositoryProtocol) {
        self.repository = repository
        self.state = .init(deviceID: deviceID)

//        repository.events() { [weak self] _ in
//            self?.updateState()
//        }
//
//        updateState()
    }
    
    private func updateState() {
        //state.device = repository.device(id: state.deviceID)
    }
    
    func disconnect() {
        guard let device = state.device else { return }
        state.isDisconnecting = true
        repository.disconnect(deviceID: device.id)
    }
}
