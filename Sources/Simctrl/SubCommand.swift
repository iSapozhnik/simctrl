//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 27.09.19.
//

import Foundation

public protocol SubCommand {
    var device: Device? { get set }
    var arguments: [Argument]? { get set }
    var subCommand: String { get }
    var stringRepresentation: String { get }
}

public enum StatusBarAction: String {
    case clear
    case override
}

struct StatusBarSubCommand: SubCommand {
    let action: StatusBarAction
    var device: Device?
    var arguments: [Argument]?

    let subCommand = "status_bar"

    var stringRepresentation: String {
        let argumentsAsString: [String]? = arguments?.compactMap { try? $0.validatedParameter() }
        var stringComponents = [String]()
        stringComponents.append(subCommand)

        switch device {
        case .booted:
            stringComponents.append("booted")
        case .id(let idValue):
            stringComponents.append("\(idValue)")
        default:
            stringComponents.append("booted")
        }

        switch action {
        case .clear:
            stringComponents.append("clear")
            return stringComponents.joined(separator: " ")
        case .override:
            stringComponents.append("override")
            stringComponents += argumentsAsString ?? [""]
            return stringComponents.joined(separator: " ")
        }
    }
}

struct DeviceListSubCommand: SubCommand {
    var device: Device?
    var arguments: [Argument]?

    let subCommand = "list"

    var stringRepresentation: String {
        return subCommand
    }
}
