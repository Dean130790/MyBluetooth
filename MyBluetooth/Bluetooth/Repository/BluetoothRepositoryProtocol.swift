//
//  BluetoothRepositoryProtocol.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 02/07/26.
//

import Foundation

protocol BluetoothRepositoryProtocol: Sendable {
    func startScan()
    func stopScan()
    func connect(deviceID: UUID)
    func disconnect(deviceID: UUID)
    func events(_ observer: @escaping @MainActor (BluetoothEvent) -> Void)
}
