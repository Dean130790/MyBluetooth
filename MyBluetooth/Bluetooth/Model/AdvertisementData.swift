//
//  AdvertisementData.swift
//  BLT
//
//  Created by Yatharth Wadekar on 02/07/26.
//

import Foundation

struct AdvertisementData: Hashable, Sendable {
    var localName: String?
    var manufacturerData: Data?
    var serviceUUIDs: [ServiceID]
    var txPower: Int?
    var isConnectable: Bool
}
