//
//  CBCharacteristic+Extension.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 09/07/26.
//

import CoreBluetooth

extension CBCharacteristic {
    var characteristicID: CharacteristicID {
        CharacteristicID(rawValue: self.uuid.uuidString)
    }
}
