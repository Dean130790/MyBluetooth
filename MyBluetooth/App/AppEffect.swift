//
//  AppEffect.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 15/07/26.
//

import Foundation

enum Effect<Action: Sendable>: Sendable {
    case none
    case run(id: EffectID, @Sendable (@escaping @Sendable (Action) async -> Void) async -> Void)
}

enum EffectID: Hashable {
    case bluetoothSubscription
}
