//
//  AppAction.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 09/07/26.
//

import Foundation

enum AppAction {
    case onAppear
    case onDisappear
    case connect(DeviceID)
    case detail(DetailAction)
}

enum DetailAction {
    case onAppear(DeviceID)
    case forgetDevice(DeviceID)
}
