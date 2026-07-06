//
//  BluetoothDevice.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 02/07/26.
//

import Foundation

struct BluetoothDevice: Identifiable, Hashable, Sendable {
    let id: UUID
    var name: String?
    var rssi: Int
    var advertisementData: AdvertisementData
    var connectionState: ConnectionState
    var lastSeen: Date
    
    init(
        id: UUID,
        name: String?,
        rssi: Int,
        advertisementData: AdvertisementData,
        connectionState: ConnectionState = .disconnected,
        lastSeen: Date = .now
    ) {
        self.id = id
        self.name = name
        self.rssi = rssi
        self.advertisementData = advertisementData
        self.connectionState = connectionState
        self.lastSeen = lastSeen
    }
}
