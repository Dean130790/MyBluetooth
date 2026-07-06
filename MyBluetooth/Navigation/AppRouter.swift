//
//  AppRouter.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 02/07/26.
//

import SwiftUI

@MainActor
@Observable
final class AppRouter {

    var path: [AppRoute] = []

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
