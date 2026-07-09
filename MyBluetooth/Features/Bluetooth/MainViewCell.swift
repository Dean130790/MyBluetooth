//
//  MainViewCell.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import SwiftUI

enum CellType {
    case myDevices
    case otherDevices
}

struct MainViewCell: View {
    
    let cellType: CellType
    let device: BluetoothDevice
    
    let tapOnDevice: (BluetoothDevice) -> Void
    let tapOnDeviceInfo: (BluetoothDevice) -> Void
    
    var body: some View {
        HStack {
            Button {
                tapOnDevice(device)
            } label: {
                HStack {
                    Text(device.name ?? "NA")
                    Spacer()
                    
                    if cellType == .myDevices || cellType == .otherDevices && device.connectionState == .connecting {
                        Text(device.connectionState.title)
                            .foregroundStyle(device.connectionState.color)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if cellType == .myDevices {
                Button {
                    tapOnDeviceInfo(device)
                } label: {
                    Image(systemName: "info.circle")
                }
                .buttonStyle(.borderless)
            }
        }
    }
}
