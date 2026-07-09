//
//  MainViewSection.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 03/07/26.
//

import SwiftUI

struct MainViewSection: View {
    
    let store: AppStore
    
    var body: some View {
        Section {
            HStack {
                Text("Status")
                Spacer()
                Text(store.state.bluetoothEnabled ? "Enabled" : "Disabled")
                    .foregroundStyle(store.state.bluetoothEnabled ? .green : .red)
            }
            
            if !store.state.bluetoothEnabled {
                Button {
                    openBluetoothSettings()
                } label: {
                    HStack {
                        Text("Open Bluetooth Settings")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        } footer: {
            Text("Bluetooth can only be enabled or disabled from the Settings app.")
        }
    }
    
    private func openBluetoothSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url)
    }
}
