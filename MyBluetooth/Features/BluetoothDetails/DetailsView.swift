//
//  DetailsView.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 04/07/26.
//

import SwiftUI
import ComposableArchitecture

struct DetailsView: View {

    var store: StoreOf<DetailFeature>

    @Environment(\.dismiss) var dismiss


    var body: some View {
        List {
            connectionSection
            deviceInformationSection
            forgetSection
        }
        .navigationTitle(store.device.name ?? "NA")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension DetailsView {
    var connectionSection: some View {
        Section("CONNECTION") {
            infoRow(
                title: "Status",
                value: store.device.connectionState.title
            )
            infoRow(
                title: "Identifier",
                value: store.device.id.rawValue
            )
        }
    }
}

private extension DetailsView {
    var deviceInformationSection: some View {
        Section("ABOUT") {
            infoRow(
                title: "Name",
                value: store.device.name ?? "Unknown"
            )
            infoRow(
                title: "RSSI",
                value: "\(store.device.rssi) dBm"
            )
            infoRow(
                title: "Bluetooth State",
                value: store.device.connectionState.title
            )
        }
    }
}

private extension DetailsView {
    var forgetSection: some View {
        Section {
            Button(role: .destructive) {
                store.send(.forgetDevice)
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
