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
//        task.waitUntilExit()
        
        print("Executing: \(command.stringRepresentation)")
        task.arguments = ["-c", command.stringRepresentation]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
//        task.terminationHandler = { process in
//
//        }
         
//        if status == 0 {
//            print("Task succeeded.")
//        } else {
//            print("Task failed.")
//        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

        return output
    }
}
