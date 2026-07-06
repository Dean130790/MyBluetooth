//
//  BluetoothError.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 02/07/26.
//

import Foundation

enum BluetoothError: Error, LocalizedError {
    case bluetoothUnavailable
    case unauthorized
    case scanFailed
    case connectionFailed
    case disconnected
    case timeout
    case serviceNotFound
    case characteristicNotFound
    case writeFailed
    case readFailed
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .bluetoothUnavailable:
            return "Bluetooth is unavailable."
        case .unauthorized:
            return "Bluetooth permission denied."
        case .scanFailed:
            return "Scanning failed."
        case .connectionFailed:
            return "Connection failed."
        case .disconnected:
            return "Peripheral disconnected."
        case .timeout:
            return "Operation timed out."
        case .serviceNotFound:
            return "Service not found."
        case .characteristicNotFound:
            return "Characteristic not found."
        case .writeFailed:
            return "Write failed."
        case .readFailed:
            return "Read failed."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
