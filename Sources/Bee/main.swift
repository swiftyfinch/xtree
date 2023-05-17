//
//  main.swift
//  Bee
//
//  Created by Vyacheslav Khorkov on 07.02.2022.
//  Copyright © 2022 Vyacheslav Khorkov. All rights reserved.
//

import ArgumentParser
import XcodeProj

struct Bee: ParsableCommand {
    @Option(name: .shortAndLong, help: "Project path.") var path: String?
    @Option(name: .shortAndLong, help: "Select tree root.") var root: String?
    @Option(name: .shortAndLong,
            parsing: .upToNextOption,
            help: "Sequence of searching words.") var contains: [String] = []
    @Option(name: .shortAndLong,
            parsing: .upToNextOption,
            help: "Sequence of words for exclude.") var exclude: [String] = []
    @Option(name: .shortAndLong, help: "Tree depth.") var depth: Int?

    static var configuration = CommandConfiguration(abstract: "🐝 Bee",
                                                    version: "0.2.0")

    func run() throws {
        let project = try XcodeProj.read(path: path)

        let parser = XcodeTargetsParser(project: project)
        let targets = parser.parse(contains: contains, excludes: exclude)

        let graph = Graph(content: targets)
        graph.draw(name: root, maxDepth: depth)
    }
}
Bee.main()
