//
//  demo.swift
//  BTsocket
//
//  Created by Kumar, Sanjay on 04/04/23.
//

import Foundation
import CoreBluetooth

public protocol SocketService {
    associatedtype T
    var socketChannel: T? { get set }
    func create(channel: T)
    
}

public class BTSocketHandler: SocketService {
    public typealias T = CBL2CAPChannel
    public var socketChannel: CBL2CAPChannel?
    public func create(channel: T) {}
}

public class BTManager<U: SocketService>: NSObject {
    private var centralManager: CBCentralManager
    public var socketServices: any SocketService
    
    public init(socketServices: any SocketService) {
        self.socketServices = socketServices
        self.centralManager = .init()
    }
}

// tried with extension BTManager<U: SocketService> : CBPeripheralDelegate where U.T == CBL2CAPChannel { } . no luck

extension BTManager : CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
        guard let channel = channel else { return }
        socketServices.create(channel: channel)
    }
    
}
