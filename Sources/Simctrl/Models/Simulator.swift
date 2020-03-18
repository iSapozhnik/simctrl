//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 13.03.20.
//

import Foundation
import Cocoa

public struct Simulator: Identifiable, Comparable, Hashable {
    public enum State: String {
        case unknown
        case creating
        case booting
        case booted
        case shuttingDown
        case shutdown
    }

    /// The user-facing name for this simulator, e.g. iPhone 11 Pro Max.
    public let name: String

    /// The internal identifier that represents this device.
    public let udid: String

    /// Sends back the UDID for Identifiable.
    public var id: String { udid }

    /// The uniform type identifier of the simulator device
    public let typeIdentifier: TypeIdentifier

    /// The icon representing the simulator's device
    public let image: NSImage

    /// The device family of the simulator
    public var deviceFamily: DeviceFamily { deviceType?.family ?? .iPhone }

    /// The information about the simulator OS
    public let runtime: Runtime?

    /// The device type of the simulator
    public let deviceType: DeviceType?

    /// The current state of the simulator
    public let state: State

    /// The path to the simulator directory location
    public let dataPath: String

    public init(name: String, udid: String, state: State, runtime: Runtime?, deviceType: DeviceType?, dataPath: String) {
        self.name = name
        self.udid = udid
        self.state = state
        self.runtime = runtime
        self.deviceType = deviceType
        self.dataPath = dataPath

        let typeIdentifier: TypeIdentifier
        if let model = deviceType?.modelTypeIdentifier {
            typeIdentifier = model
        } else if name.contains("iPad") {
            typeIdentifier = .defaultiPad
        } else if name.contains("Watch") {
            typeIdentifier = .defaultWatch
        } else if name.contains("TV") {
            typeIdentifier = .defaultTV
        } else {
            typeIdentifier = .defaultiPhone
        }

        self.typeIdentifier = typeIdentifier
        self.image = typeIdentifier.icon
    }

    /// Sort simulators alphabetically.
    public static func < (lhs: Simulator, rhs: Simulator) -> Bool {
        lhs.name < rhs.name
    }

    /// Users whichever simulator simctl feels like; if there's only one active it will be used,
    /// but if there's more than one simctl just picks one.
    public static let `default` = Simulator(name: "Default", udid: "booted", state: .booted, runtime: nil, deviceType: nil, dataPath: "")
}

extension Simulator.State {
    public init(deviceState: String?) {
        if deviceState == "Creating" {
            self = .creating
        } else if deviceState == "Booting" {
            self = .booting
        } else if deviceState == "Booted" {
            self = .booted
        } else if deviceState == "ShuttingDown" {
            self = .shuttingDown
        } else if deviceState == "Shutdown" {
            self = .shutdown
        } else {
            self = .unknown
        }
    }
}
