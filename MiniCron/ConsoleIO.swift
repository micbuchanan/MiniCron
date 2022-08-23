//
//  ConsoleIO.swift
//  MiniCron
//
//  Created by Michael Buchanan on 21/08/2022.
//

import Foundation

enum OutputType {
  case error
  case standard
}

protocol Console: AnyObject {
    func writeMessage(
        _ message: String,
        to: OutputType
    )
    
    func printUsage()
}

extension Console {
    func writeMessage(
        _ message: String,
        to: OutputType = .standard
    ) {
        writeMessage(
            message,
            to: to
        )
    }
}

class ConsoleIO: Console {
    func writeMessage(
        _ message: String,
        to: OutputType = .standard
    ) {
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("\(message)\n", stderr)
        }
    }
    
    func printUsage() {

        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
           
        writeMessage("Welcome to \(executableName), a scheduler command line app. It works in one of the 3 modes stated below.")
        writeMessage("usage:")
        writeMessage("\(executableName) -a string1: Configuration, string2: Current time as HH:mm")
        writeMessage("or")
        writeMessage("\(executableName) -c string: Configuration (Fetches the current time as a reference)")
        writeMessage("or")
        writeMessage("\(executableName) -h to show usage information")
    }
}
