//
//  BluetoothDeviceRow.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import SwiftUI

enum BluetoothDeviceRowType {
    case myDevices
    case otherDevices
}

struct BluetoothDeviceRow: View {

    let bluetoothDeviceRowType: BluetoothDeviceRowType
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

                    if bluetoothDeviceRowType == .myDevices || bluetoothDeviceRowType == .otherDevices && device.connectionState == .connecting {
                        Text(device.connectionState.title)
                            .foregroundStyle(device.connectionState.color)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if bluetoothDeviceRowType == .myDevices {
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
