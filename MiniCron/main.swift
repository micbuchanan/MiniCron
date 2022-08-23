//
//  main.swift
//  MiniCron
//
//  Created by Michael Buchanan on 21/08/2022.
//

import Foundation

let miniCron = MiniCron(
    console: ConsoleIO(),
    currentDate: Date()
)
let arguments = CommandLine.arguments
miniCron.staticMode(arguments)

