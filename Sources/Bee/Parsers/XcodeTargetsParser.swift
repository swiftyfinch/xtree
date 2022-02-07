//
//  XcodeTargetsParser.swift
//  Bee
//
//  Created by Vyacheslav Khorkov on 08.02.2022.
//  Copyright © 2022 Vyacheslav Khorkov. All rights reserved.
//

import XcodeProj

struct XcodeTargetsParser {
    let project: XcodeProj

    func parse(contains: [String], excludes: [String]) -> [String: [String]] {
        var content: [String: [String]] = [:]
        for target in project.pbxproj.main.targets {
            if excludes.contains(where: { target.name.contains($0) }) { continue }
            if !contains.isEmpty {
                guard contains.contains(where: { target.name.contains($0) }) else { continue }
            }

            var dependencies = target.dependencies.compactMap(\.displayName).sorted()
            for element in excludes {
                dependencies = dependencies.filter { !$0.contains(element) }
            }
            if !contains.isEmpty {
                dependencies = dependencies.filter { dependency in
                    contains.contains { dependency.contains($0) }
                }
            }
            content[target.name] = dependencies
        }
        return content
    }
}
