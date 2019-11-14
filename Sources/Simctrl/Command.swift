//
//  Command.swift
//  
//
//  Created by Ivan Sapozhnik on 27.09.19.
//

import Foundation

public protocol Command {
    var tool: Tool? { get set }

    var stringRepresentation: String { get }
}

public struct XCRunCommand: Command {
    public var tool: Tool?

    public var stringRepresentation: String {
        var string = "xcrun "
        string += tool?.stringRepresentation ?? ""
        return string
    }
}

public struct OpenCommand: Command {
    public var tool: Tool?
    
    public var stringRepresentation: String {
        return "open \(simulatorPath)"
    }
    
    private let simulatorPath = "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/"
}
