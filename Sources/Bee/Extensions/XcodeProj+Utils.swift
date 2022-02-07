//
//  XcodeProj+Utils.swift
//  Bee
//
//  Created by Vyacheslav Khorkov on 07.02.2022.
//  Copyright © 2022 Vyacheslav Khorkov. All rights reserved.
//

import XcodeProj

extension PBXProj {
    var main: PBXProject { projects[0] }
}

extension PBXTargetDependency {
    var displayName: String? { name ?? target?.name }
}
