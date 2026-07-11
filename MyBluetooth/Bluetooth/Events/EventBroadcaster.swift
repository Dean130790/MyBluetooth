//
//  EventBroadcaster.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 10/07/26.
//

import Foundation

final class EventBroadcaster<BluetoothEvent: Sendable>: @unchecked Sendable {

    typealias Observer = @Sendable (BluetoothEvent) -> Void

    private var observer: Observer?

    func observe(_ observer: @escaping @Sendable Observer) {
        self.observer = observer
    }

    func send(_ event: BluetoothEvent) {
        observer?(event)
    }
}
