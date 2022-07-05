//
//  XcodeProj+Read.swift
//  Bee
//
//  Created by Vyacheslav Khorkov on 07.02.2022.
//  Copyright © 2022 Vyacheslav Khorkov. All rights reserved.
//

import Files
import Foundation
import XcodeProj

enum XcodeProjErrors: LocalizedError {
    case cantFind

    var errorDescription: String? {
        switch self {
        case .cantFind:
            return "Can't find any Xcode project."
        }
    }
}

extension XcodeProj {
    static func read(path: String?) throws -> XcodeProj {
        let resolvedPath: String
        if let path = path {
            resolvedPath = try Folder.current.subfolder(at: path).path
        } else if let path = Folder.current.firstXcodeProjectPath() {
            resolvedPath = path
        } else {
            throw XcodeProjErrors.cantFind
        }

        let projectName = URL(fileURLWithPath: resolvedPath).lastPathComponent
        print("Read \(projectName) ⏱".yellow)
        let (project, time) = try meassure { try XcodeProj(pathString: resolvedPath) }
        let done = "\(time.output()) Read \(projectName) ✓".green
        printAndUpdateLastLine(done)
        return project
    }
}

func meassure<T>(_ block: () throws -> T) rethrows -> (result: T, time: Double) {
    let begin = ProcessInfo.processInfo.systemUptime
    return (try block(), ProcessInfo.processInfo.systemUptime - begin)
}

func printAndUpdateLastLine(_ text: String) {
    print("\u{1B}[1A\u{1B}[K\(text)")
}

private extension Folder {
    func firstXcodeProjectPath() -> String? {
        Folder.current.subfolders
            .first { $0.url.pathExtension == .xcodeproj }?
            .path
    }
}

private extension String {
    static let xcodeproj = "xcodeproj"
}

private extension Double {
    func formatTime() -> String {
        let formatter = DateComponentsFormatter()

        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en")
        formatter.calendar = calendar

        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 2
        return formatter.string(from: max(1, self)) ?? "NaN"
    }

    func output() -> String {
        "[\(formatTime())]".yellow
    }
}
