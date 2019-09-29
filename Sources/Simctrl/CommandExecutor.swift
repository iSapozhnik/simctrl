//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 27.09.19.
//

import Foundation

struct CommandExecutor {
    @discardableResult
    func execute(_ command: Command) -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        print("Executing: \(command.stringRepresentation)")
        task.arguments = ["-c", command.stringRepresentation]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

        return output
    }
}
