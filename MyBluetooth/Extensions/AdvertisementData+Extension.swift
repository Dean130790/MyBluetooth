//
//  AdvertisementData+Extension.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import CoreBluetooth

extension AdvertisementData {
    init(dictionary: [String: Any]) {
        self.localName = dictionary[CBAdvertisementDataLocalNameKey] as? String
        self.manufacturerData = dictionary[CBAdvertisementDataManufacturerDataKey] as? Data
        //        self.serviceUUIDs = (dictionary[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID])?
        //            .map(\.uuid) ?? []
        self.txPower = (dictionary[CBAdvertisementDataTxPowerLevelKey] as? NSNumber)?
            .intValue
        self.isConnectable = (dictionary[CBAdvertisementDataIsConnectable] as? NSNumber)?
            .boolValue ?? false
    }
}
