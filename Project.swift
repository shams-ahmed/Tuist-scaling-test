import ProjectDescription
import ProjectDescriptionHelpers
import Foundation

/*
                +-------------+
                |             |
                |     App     | Contains TuistApp App target and TuistApp unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

let count = 300
let appName = "TuistApp"
let tuistAppKit = appName + "Kit"
let tuistAppUI = appName + "UI"
let sources = "Sources"
let tests = "Tests"
let sourceTemplate = """
import Foundation

public final class ??? {
    public static func hello() {
        print("Hello, from ???")
    }
}
"""
let testsTemplate = """
import Foundation
import XCTest

final class ???Tests: XCTestCase {
    func test_example() {
        XCTAssertEqual("???", "???")
    }
}
"""
let appKits = Array(repeating: "", count: count).enumerated().map {
    "\(tuistAppKit)\($0.offset)"
}
let uiKits = Array(repeating: "", count: count).enumerated().map {
    "\(tuistAppUI)\($0.offset)"
}


// MARK: - Create folders

let fileManager = FileManager.default
let path = fileManager.currentDirectoryPath + "/Targets"

func createAppKitFoldersAndFiles() {
    appKits.forEach {
        let folder = (path as NSString).appendingPathComponent($0)
        let sourcesFolder = (folder as NSString).appendingPathComponent(sources)
        let testsFolder = (folder as NSString).appendingPathComponent(tests)
        
        try! fileManager.createDirectory(atPath: folder, withIntermediateDirectories: true)
        try! fileManager.createDirectory(atPath: sourcesFolder, withIntermediateDirectories: true)
        try! fileManager.createDirectory(atPath: testsFolder, withIntermediateDirectories: true)
        
        let sourceFile = sourceTemplate.replacingOccurrences(of: "???", with: $0)
        let testsFile = testsTemplate.replacingOccurrences(of: "???", with: $0)
        
        try! sourceFile.write(
            toFile: (sourcesFolder as NSString).appendingPathComponent("\($0).swift"),
            atomically: true,
            encoding: .utf8
        )
        
        try! testsFile.write(
            toFile: (testsFolder as NSString).appendingPathComponent("\($0)Tests.swift"),
            atomically: true,
            encoding: .utf8
        )
    }
}

func createAppUIFoldersAndFiles() {
    uiKits.forEach {
        let folder = (path as NSString).appendingPathComponent($0)
        let sourcesFolder = (folder as NSString).appendingPathComponent(sources)
        let testsFolder = (folder as NSString).appendingPathComponent(tests)
        
        try! fileManager.createDirectory(atPath: folder, withIntermediateDirectories: true)
        try! fileManager.createDirectory(atPath: sourcesFolder, withIntermediateDirectories: true)
        try! fileManager.createDirectory(atPath: testsFolder, withIntermediateDirectories: true)
        
        let sourceFile = sourceTemplate.replacingOccurrences(of: "???", with: $0)
        let testsFile = testsTemplate.replacingOccurrences(of: "???", with: $0)
        
        try! sourceFile.write(
            toFile: (sourcesFolder as NSString).appendingPathComponent("\($0).swift"),
            atomically: true,
            encoding: .utf8
        )
        
        try! testsFile.write(
            toFile: (testsFolder as NSString).appendingPathComponent("\($0)Tests.swift"),
            atomically: true,
            encoding: .utf8
        )
    }
}

createAppKitFoldersAndFiles()
createAppUIFoldersAndFiles()

// MARK: - Create Files


// MARK: - Project

let additionalTargets = ["TuistAppKit", "TuistAppUI"] + appKits + uiKits

// Creates our project using a helper function defined in ProjectDescriptionHelpers
var project = Project.app(
        name: appName,
        platform: .iOS,
        additionalTargets: additionalTargets,
        spm: [
            .external(name: "Alamofire"),
            .external(name: "RxSwift"),
            .external(name: "Moya"),
            .external(name: "Promises"),
            .external(name: "SnapKit"),
            .external(name: "TinyConstraints"),
            .external(name: "Defaults"),
            .external(name: "CombineExt"),
            .external(name: "CombineCocoa"),
            .external(name: "SpotifyAPI")
        ],
        developmentTeam: "72SA8V3WYL"
)
