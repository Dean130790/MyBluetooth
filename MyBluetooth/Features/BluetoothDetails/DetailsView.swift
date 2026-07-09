//
//  DetailsView.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import SwiftUI

struct DetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let deviceID: DeviceID
    
    let store: AppStore
    
    var device: BluetoothDevice? {
        store.state.device
    }
    
    var body: some View {
        List {
            connectionSection
            deviceInformationSection
            forgetSection
        }
        .navigationTitle(device?.name ?? "NA")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension DetailsView {
    var connectionSection: some View {
        Section("CONNECTION") {
            infoRow(
                title: "Status",
                value: device?.connectionState.title ?? "NA"
            )
            infoRow(
                title: "Identifier",
                value: device?.id.rawValue ?? "NA"
            )
        }
    }
}

private extension DetailsView {
    var deviceInformationSection: some View {
        Section("ABOUT") {
            infoRow(
                title: "Name",
                value: device?.name ?? "Unknown"
            )
            infoRow(
                title: "RSSI",
                value: "\(device?.rssi ?? 0) dBm"
            )
            infoRow(
                title: "Bluetooth State",
                value: device?.connectionState.title ?? "NA"
            )
        }
    }
}

private extension DetailsView {
    var forgetSection: some View {
        Section {
            Button(role: .destructive) {
                store.send(.detail(.forgetDevice(deviceID)))
                dismiss()
            } label: {
                HStack {
                    Spacer()
                    Text("Forget Device")
                    Spacer()
                }
            }
            
        } footer: {
            Text("Removes this device from the app. The Bluetooth pairing stored by iOS is not removed.")
        }
    }
}

private extension DetailsView {
    @ViewBuilder
    func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
