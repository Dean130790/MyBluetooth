//
//  ConnectionState.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 02/07/26.
//

import Foundation
import SwiftUI

enum ConnectionState: Equatable, Sendable {
    case disconnected
    case connecting
    case connected
    case disconnecting
    
    var title: String {
        switch self {
        case .connected:
            return "Connected"
        case .connecting:
            return "Connecting"
        case .disconnecting, .disconnected:
            return "Not Connected"
        @unknown default:
            return "Unknown"
        }
    }
    
    var color: Color {
        switch self {
        case .connected:
            return .green
        case .connecting, .disconnecting:
            return .orange
        case .disconnected:
            return .secondary
        @unknown default:
            return .secondary
        }
    }
}
