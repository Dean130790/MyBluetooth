//
//  CBService+Extension.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 09/07/26.
//

import CoreBluetooth

extension CBService {
    var serviceID: ServiceID {
        ServiceID(rawValue: self.uuid.uuidString)
    }
}
