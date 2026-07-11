//
//  EventEmitter.swift
//  MyBluetooth
//
//  Created by Yatharth Wadekar on 05/07/26.
//

import Foundation

actor EventEmitter<BluetoothEvent: Sendable> {
    private var continuations: [UUID: AsyncStream<BluetoothEvent>.Continuation] = [:]
    
    nonisolated func makeStream() -> (AsyncStream<BluetoothEvent>, UUID, AsyncStream<BluetoothEvent>.Continuation) {
        let id = UUID()
        var capturedContinuation: AsyncStream<BluetoothEvent>.Continuation!
        let stream = AsyncStream<BluetoothEvent> { continuation in
            capturedContinuation = continuation
        }
        return (stream, id, capturedContinuation)
    }
    
    func register(_ continuation: AsyncStream<BluetoothEvent>.Continuation, id: UUID) {
        continuations[id] = continuation
        continuation.onTermination = { [weak self] _ in
            Task { await self?.removeSubscriber(id) }
        }
    }
    
    func subscribe() -> AsyncStream<BluetoothEvent> {
        let id = UUID()
        return AsyncStream { continuation in
            continuations[id] = continuation
            continuation.onTermination = { [weak self] _ in
                Task { await self?.removeSubscriber(id) }
            }
        }
    }
    
    func send(_ event: BluetoothEvent) {
        for continuation in continuations.values {
            continuation.yield(event)
        }
    }
    
    private func removeSubscriber(_ id: UUID) {
        continuations.removeValue(forKey: id)
    }
}
