//
//  PeripheralContext.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 09/07/26.
//

import CoreBluetooth

//check Sendable, Equatable
class PeripheralContext {
    let peripheral: CBPeripheral
    var services: [ServiceID: ServiceContext] = [:]
    var isManualDisconnect = false

    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
}

class ServiceContext {
    var service: CBService
    var characteristics: [CharacteristicID: CBCharacteristic] = [:]

    init(service: CBService) {
        self.service = service
    }
}
