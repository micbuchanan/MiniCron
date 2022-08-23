//
//  MiniCronTests.swift
//  MiniCronTests
//
//  Created by Michael Buchanan on 21/08/2022.
//

import XCTest

class MiniCronTests: XCTestCase {
    var arguments: [String]!
    var sut: MiniCron!
    fileprivate var console: MockConsole!

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.arguments = ["appAddress/MiniCron"]
        self.console = MockConsole()
        self.sut = MiniCron(
            console: self.console,
            currentDate: Date(timeIntervalSince1970: 1642889978)
        )
    }

    override func tearDownWithError() throws {
        self.arguments = nil
        self.sut = nil
        self.console = nil
        try super.tearDownWithError()
    }

    func testStaticMode_All_success() throws {
        self.arguments.append(contentsOf: Factory.schedulingConfig_All_success)
        self.sut.staticMode(self.arguments)
        
        XCTAssertTrue(self.console.errors.isEmpty)
        XCTAssertEqual(self.console.messages.count, 4)
        XCTAssertEqual(self.console.messages[0], "1:30 tomorrow - /bin/run_me_daily\n")
        XCTAssertEqual(self.console.messages[1], "16:45 today - /bin/run_me_hourly\n")
        XCTAssertEqual(self.console.messages[2], "16:10 today - /bin/run_me_every_minute\n")
        XCTAssertEqual(self.console.messages[3], "19:00 today - /bin/run_me_sixty_times\n")
    }
    
    func testStaticMode_All_failure() throws {
        self.arguments.append(contentsOf: Factory.schedulingConfig_All_failure)
        self.sut.staticMode(self.arguments)
        
        XCTAssertTrue(self.console.messages.isEmpty)
        XCTAssertEqual(self.console.errors.count, 1)
        XCTAssertEqual(self.console.errors[0], "The time entered is in an incorrect format")
    }
    
    func testStaticMode_All_failure_numberOfSections() throws {
        self.arguments.append(contentsOf: Factory.schedulingConfig_All_failure_numberOfSections)
        self.sut.staticMode(self.arguments)
        
        XCTAssertTrue(self.console.messages.isEmpty)
        XCTAssertEqual(self.console.errors.count, 1)
        XCTAssertEqual(self.console.errors[0], "Incorrect number of arguments in a section.")
    }
    
    func testStaticMode_Config_success() throws {
        self.arguments.append(contentsOf: Factory.schedulingConfig_Config_success)
        self.sut.staticMode(self.arguments)
        
        XCTAssertTrue(self.console.errors.isEmpty)
        XCTAssertEqual(self.console.messages.count, 4)
        XCTAssertEqual(self.console.messages[0], "1:30 tomorrow - /bin/run_me_daily\n")
        XCTAssertEqual(self.console.messages[1], "22:45 today - /bin/run_me_hourly\n")
        XCTAssertEqual(self.console.messages[2], "22:19 today - /bin/run_me_every_minute\n")
        XCTAssertEqual(self.console.messages[3], "19:00 tomorrow - /bin/run_me_sixty_times\n")
    }
    
    func testStaticMode_Config_failure() throws {
        self.arguments.append(contentsOf: Factory.schedulingConfig_Config_failure)
        self.sut.staticMode(self.arguments)
        
        XCTAssertTrue(self.console.messages.isEmpty)
        XCTAssertEqual(self.console.errors.count, 1)
        XCTAssertEqual(self.console.errors[0], "Incorrect number of arguments for option c")
    }

    func testStaticMode_Help() throws {
        self.arguments.append(contentsOf: Factory.schedulingConfig_Help)
        self.sut.staticMode(self.arguments)
        
        XCTAssertTrue(self.console.errors.isEmpty)
        XCTAssertTrue(self.console.messages.isEmpty)
        XCTAssertTrue(self.console.printUsageCalled)
    }

}

private final class MockConsole: Console {
    var messages = [String]()
    var errors = [String]()
    var printUsageCalled = false
    
    func writeMessage(_ message: String, to: OutputType) {
        switch to {
        case .error:
            self.errors.append(message)
        case .standard:
            self.messages.append(message)
        }
    }
    
    func printUsage() {
        self.printUsageCalled = true
    }
}

private enum Factory {
    static let schedulingConfig_All_success = [
        "-a",
        "30",
        "1",
        "/bin/run_me_daily",
        "45",
        "*",
        "/bin/run_me_hourly",
        "*",
        "*",
        "/bin/run_me_every_minute",
        "*",
        "19",
        "/bin/run_me_sixty_times",
        "16:10",
    ]
    
    static let schedulingConfig_All_failure = [
        "-a",
        "/bin/run_me_daily",
        "/bin/run_me_sixty_times",
    ]
    
    static let schedulingConfig_All_failure_numberOfSections = [
        "-a",
        "/bin/run_me_daily",
        "/bin/run_me_sixty_times",
        "16:10",
    ]
    
    static let schedulingConfig_Config_success = [
        "-c",
        "30",
        "1",
        "/bin/run_me_daily",
        "45",
        "*",
        "/bin/run_me_hourly",
        "*",
        "*",
        "/bin/run_me_every_minute",
        "*",
        "19",
        "/bin/run_me_sixty_times",
    ]
    
    static let schedulingConfig_Config_failure = [
        "-c",
        "*",
        "19",
        "/bin/run_me_sixty_times",
        "16:10",
    ]
    
    static let schedulingConfig_Help = [
        "-h",
    ]
}
