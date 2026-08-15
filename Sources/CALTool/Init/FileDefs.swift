//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore

enum Template: String, CmdArgEnum {
    case opaque, basic, manpage, testing
    case simpleTree = "simple-tree"
    case statefulTree = "stateful-tree"
}

typealias FileName = String
typealias FileContent = String
typealias FileDef = (FileName, FileContent)

let fileDefsFor: [Template: [FileDef]] = [
    .basic: [("Main.swift", basicMain)],
    .manpage: [("Main.swift", manpageMain)],
    .opaque: [("Main.swift", opaqueMain)],
    .simpleTree: [
        ("Main.swift", simpleTreeMain), ("Son.swift", simpleTreeSon),("Daughter.swift", simpleTreeDaughter),
    ],
    .statefulTree: [
        ("Main.swift", statefulTreeMain), ("Son.swift", statefulTreeSon), ("Daughter.swift", statefulTreeDaughter),
    ],
    .testing: [("Main.swift", testingMain)],
]

let minimalFileDefsFor: [Template: [FileDef]] = [
    .basic: [("Main.swift", minimalBasicMain)],
    .manpage: [("Main.swift", manpageMain)],
    .opaque: [("Main.swift", minimalOpaqueMain)],
    .simpleTree: [
        ("Main.swift", minimalSimpleTreeMain), ("Son.swift", minimalSimpleTreeSon), ("Daughter.swift", minimalSimpleTreeDaughter),
    ],
    .statefulTree: [
        ("Main.swift", minimalStatefulTreeMain), ("Son.swift", minimalstatefulTreeSon), ("Daughter.swift", minimalStatefulTreeDaughter),
    ],
    .testing: [("Main.swift", minimalTestingMain)],
]
