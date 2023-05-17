//
//  Graph.swift
//  Bee
//
//  Created by Vyacheslav Khorkov on 07.02.2022.
//  Copyright © 2022 Vyacheslav Khorkov. All rights reserved.
//

import Rainbow

final class Graph {
    private let content: [String: [String]]
    private let keys: [String]
    private let arrowsColor: UInt32
    private let colors: [UInt32]
    private let inMiddle: String
    private let leaf: String
    private let pipe: String

    init(content: [String: [String]]) {
        self.content = content
        self.keys = content.keys.sorted { $0.localizedCompare($1) == .orderedAscending }
        self.arrowsColor = 0xA3A300
        self.colors  = [0xA3A300, 0x964B00]
        self.pipe = "│"
        self.inMiddle = "├──"
        self.leaf = "└──"
    }

    func draw(name: String?,
              depth: Int = 0,
              last: Bool = false,
              maxDepth: Int? = nil,
              prefix: String = "") {
        if let maxDepth = maxDepth, depth >= maxDepth + 1 { return }

        let dependencies: [String]
        if let name = name {
            dependencies = content[name] ?? []
        } else {
            dependencies = Array(keys)
        }

        let label = name ?? "."
        let arrow = (depth == 0) ? "" : (last ? "\(leaf) " : "\(inMiddle) ")
        let color = colors[depth % colors.count]
        let output = "\(label) (\(dependencies.count))".hex(depth == 0 ? arrowsColor : color)
        print((prefix + arrow).hex(arrowsColor) + output)

        for (index, dependency) in dependencies.enumerated() {
            var prefix = prefix
            if depth > 0 { prefix += last ? "  " : "\(pipe)  " }
            draw(name: dependency,
                 depth: depth + 1,
                 last: index + 1 == dependencies.count,
                 maxDepth: maxDepth,
                 prefix: prefix)
        }
    }
}
