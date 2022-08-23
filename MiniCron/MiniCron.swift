//
//  MiniCron.swift
//  MiniCron
//
//  Created by Michael Buchanan on 21/08/2022.
//

import Foundation

enum OptionType: String {
    case all = "a"
    case config = "c"
    case help = "h"
    case unknown
    
    init(
        value: String
    ) {
        switch value {
        case "a": self = .all
        case "c": self = .config
        case "h": self = .help
        default: self = .unknown
        }
    }
}

class MiniCron {
    private let consoleIO: Console
    private let currentDate: Date
    
    init(
        console: Console,
        currentDate: Date
    ) {
        self.consoleIO = console
        self.currentDate = currentDate
    }
    
    func staticMode(
        _ args: [String]
    ) {
        let argument = args[1]
        let index = argument.index(argument.startIndex, offsetBy: 1)
        let inputArguments = args.dropFirst(2)
        let (option, value) = getOption(String(argument.suffix(from: index)))
        
        switch option {
        case .all:
            let inputTime = inputArguments.last
            var arguments = inputArguments
            _ = arguments.popLast()
            if let timeComponents = inputTime?.components(separatedBy: ":"),
                timeComponents.count == 2 {
                let sections = Array(arguments).sectioned(into: 3)
                for section in sections {
                    guard section.count == 3 else {
                        consoleIO.writeMessage(
                            "Incorrect number of arguments in a section.",
                            to: .error
                        )
                        return
                    }
                    
                    let minutes = section[0]
                    let hours = section[1]
                    let command = section[2]

                    let message = self.scheduleNextRun(
                        minutes: minutes,
                        hours: hours,
                        command: command,
                        currentMinutes: timeComponents[1],
                        currentHours: timeComponents[0]
                    )

                    if let message = message {
                        consoleIO.writeMessage(message)
                    } else {
                        consoleIO.writeMessage(
                            "Unable to schedule item",
                            to: .error
                        )
                    }
                }
            } else {
                consoleIO.writeMessage(
                    "The time entered is in an incorrect format",
                    to: .error
                )
            }
        case .config:
            if inputArguments.count % 3 != 0 {
                consoleIO.writeMessage(
                    "Incorrect number of arguments for option \(option.rawValue)",
                    to: .error
                )
                consoleIO.printUsage()
            } else {
                let sections = Array(inputArguments).sectioned(into: 3)
                for section in sections {
                    guard section.count == 3 else {
                        consoleIO.writeMessage(
                            "Incorrect number of arguments in a section.",
                            to: .error
                        )
                        return
                    }
                    
                    let minutes = section[0]
                    let hours = section[1]
                    let command = section[2]
                    
                    let (currentHours, currentMinutes) = self.currentTimeToStrings()
                    let message = self.scheduleNextRun(
                        minutes: minutes,
                        hours: hours,
                        command: command,
                        currentMinutes: currentMinutes,
                        currentHours: currentHours
                    )
                    
                    if let message = message {
                        consoleIO.writeMessage(message)
                    } else {
                        consoleIO.writeMessage(
                            "Unable to schedule item",
                            to: .error
                        )
                    }
                }
            }
        case .help:
            consoleIO.printUsage()
        case .unknown:
            consoleIO.writeMessage("Unknown option \(value)")
            consoleIO.printUsage()
        }
    }
    
    // MARK: Private methods
    
    private func getOption(
        _ option: String
    ) -> (option: OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
    private func currentTimeToStrings() -> (hours: String, minutes: String) {
        let hourDateFormatter = DateFormatter()
        hourDateFormatter.dateFormat = "HH"
        hourDateFormatter.locale = Locale.init(identifier: "en_GB_POSIX")
        let hourString = hourDateFormatter.string(from: self.currentDate)
        
        let minuteDateFormatter = DateFormatter()
        minuteDateFormatter.dateFormat = "mm"
        minuteDateFormatter.locale = Locale.init(identifier: "en_GB_POSIX")
        let minuteString = minuteDateFormatter.string(from: self.currentDate)
        
        return (hourString, minuteString)
    }
    
    private func scheduleNextRun(
        minutes: String,
        hours: String,
        command: String,
        currentMinutes: String,
        currentHours: String
    ) -> String? {
        guard let currentHoursInt = Int(currentHours) else {
            consoleIO.writeMessage(
                "The current time format is incorrect",
                to: .error
            )
            return nil
        }
        
        var dayString = "today"
        
        var hourString: String
        if hours == "*" {
            hourString = String(currentHoursInt)
        } else {
            guard let hoursInt = Int(hours) else {
                consoleIO.writeMessage(
                    "The hours string format is incorrect",
                    to: .error
                )
                return nil
            }
            
            if hoursInt < currentHoursInt {
                dayString = "tomorrow"
            }
            hourString = String(hours)
        }
        
        var minuteString: String
        if minutes == "*" {
            if hours == "*" || hours == currentHours {
                minuteString = currentMinutes
            } else {
                minuteString = "00"
            }
        } else {
            guard let minutesInt = Int(minutes) else {
                consoleIO.writeMessage(
                    "The minutes string format is incorrect",
                    to: .error
                )
                return nil
            }
            minuteString = String(minutesInt)
        }
        
        return "\(hourString):\(minuteString) \(dayString) - \(command)\n"
    }
}

