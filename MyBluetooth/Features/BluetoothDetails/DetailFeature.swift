//
//  DetailFeature.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 14/07/26.
//

import ComposableArchitecture

@Reducer
struct DetailFeature {

    @ObservableState
    struct State: Equatable {
        var device: BluetoothDevice
    }

    enum Action {
        case forgetDevice
    }

    @Dependency(\.bluetoothRepository) var repository


    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .forgetDevice:
                return .run { [id = state.device.id] _ in
                    repository.forgetDevice(deviceID: id)
                }
            }
        }
    }
}


extension BluetoothRepository: DependencyKey {
    static let liveValue = BluetoothRepository(manager: BluetoothManager())
}

extension DependencyValues {
    var bluetoothRepository: BluetoothRepository {
        get { self[BluetoothRepository.self] }
        set { self[BluetoothRepository.self] = newValue }
    }
}
