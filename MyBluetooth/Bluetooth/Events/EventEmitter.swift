//
//  EventEmitter.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 05/07/26.
//

import Foundation

@MainActor
final class EventEmitter<Event> {
    
    typealias Observer = @MainActor (Event) -> Void
    
    private var observer: Observer?
    
    func observe(_ observer: @escaping Observer) {
        self.observer = observer
    }
    
    func send(_ event: Event) {
        observer?(event)
    }
}
