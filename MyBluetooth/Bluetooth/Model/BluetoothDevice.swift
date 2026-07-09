//
//  BluetoothDevice.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 02/07/26.
//

import Foundation

struct BluetoothDevice: Identifiable, Hashable, Sendable {
    let id: DeviceID
    var name: String?
    var rssi: Int
    var advertisementData: AdvertisementData
    var connectionState: ConnectionState
    var lastSeen: Date
    
    var services: [BluetoothService] = []
    
    init(
        id: DeviceID,
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

extension BluetoothDevice {
    mutating func update(from advertisement: BluetoothDevice) {
        name = advertisement.name
        rssi = advertisement.rssi
        advertisementData = advertisement.advertisementData
        lastSeen = .now
    }
}

struct BluetoothService: Identifiable, Hashable, Sendable {
    let id: ServiceID
    let isPrimary: Bool
    var characteristics: [BluetoothCharacteristic] = []
}

struct BluetoothCharacteristic: Identifiable, Hashable, Sendable {
    let id: CharacteristicID
    let properties: BluetoothCharacteristicProperties
    var value: Data?
}


struct DeviceID: Hashable, Sendable {
    let rawValue: String
}

struct ServiceID: Hashable, Sendable {
    let rawValue: String
}

struct CharacteristicID: Hashable, Sendable {
    let rawValue: String
}

extension CharacteristicID {
    static let batteryLevel = CharacteristicID(rawValue: "2A19")
    static let manufacturerName = CharacteristicID(rawValue: "2A29")
    static let modelNumber = CharacteristicID(rawValue: "2A24")
    static let serialNumber = CharacteristicID(rawValue: "2A25")
    static let firmwareRevision = CharacteristicID(rawValue: "2A26")
    static let hardwareRevision = CharacteristicID(rawValue: "2A27")
    static let softwareRevision = CharacteristicID(rawValue: "2A28")
    static let deviceName = CharacteristicID(rawValue: "2A00")
    static let appearance = CharacteristicID(rawValue: "2A01")
    static let heartRateMeasurement = CharacteristicID(rawValue: "2A37")
}

extension CharacteristicID {
    var displayName: String {
        switch self {
        case .batteryLevel:
            "Battery Level"
        case .manufacturerName:
            "Manufacturer"
        case .modelNumber:
            "Model Number"
        case .serialNumber:
            "Serial Number"
        default:
            rawValue
        }
    }
}


public struct BluetoothCharacteristicProperties: OptionSet, Hashable, Sendable {
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    /// The characteristic can be broadcast.
    public static let broadcast = Self(rawValue: 1 << 0)
    
    /// The characteristic is readable.
    public static let read = Self(rawValue: 1 << 1)
    
    /// The characteristic supports Write Without Response.
    public static let writeWithoutResponse = Self(rawValue: 1 << 2)
    
    /// The characteristic supports Write With Response.
    public static let write = Self(rawValue: 1 << 3)
    
    /// The characteristic supports Notify.
    public static let notify = Self(rawValue: 1 << 4)
    
    /// The characteristic supports Indicate.
    public static let indicate = Self(rawValue: 1 << 5)
    
    /// The characteristic supports authenticated signed writes.
    public static let authenticatedSignedWrites = Self(rawValue: 1 << 6)
    
    /// The characteristic has extended properties.
    public static let extendedProperties = Self(rawValue: 1 << 7)
    
    /// Notifications require an encrypted link.
    public static let notifyEncryptionRequired = Self(rawValue: 1 << 8)
    
    /// Indications require an encrypted link.
    public static let indicateEncryptionRequired = Self(rawValue: 1 << 9)
}

extension BluetoothCharacteristicProperties {
    
    var debugDescription: String {
        
        var values: [String] = []
        
        if contains(.read) {
            values.append("Read")
        }
        
        if contains(.write) {
            values.append("Write")
        }
        
        if contains(.writeWithoutResponse) {
            values.append("Write Without Response")
        }
        
        if contains(.notify) {
            values.append("Notify")
        }
        
        if contains(.indicate) {
            values.append("Indicate")
        }
        
        if contains(.broadcast) {
            values.append("Broadcast")
        }
        
        if contains(.authenticatedSignedWrites) {
            values.append("Signed Write")
        }
        
        if contains(.extendedProperties) {
            values.append("Extended Properties")
        }
        
        if contains(.notifyEncryptionRequired) {
            values.append("Notify (Encrypted)")
        }
        
        if contains(.indicateEncryptionRequired) {
            values.append("Indicate (Encrypted)")
        }
        
        return values.joined(separator: ", ")
    }
}

public extension BluetoothCharacteristicProperties {
    
    var isReadable: Bool {
        contains(.read)
    }
    
    var isWritable: Bool {
        contains(.write) || contains(.writeWithoutResponse)
    }
    
    var supportsNotifications: Bool {
        contains(.notify)
    }
    
    var supportsIndications: Bool {
        contains(.indicate)
    }
    
    var requiresEncryption: Bool {
        contains(.notifyEncryptionRequired) ||
        contains(.indicateEncryptionRequired)
    }
}
