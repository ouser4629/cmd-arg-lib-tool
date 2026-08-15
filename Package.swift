//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

// swift-tools-version: 6.2

import PackageDescription

let cmdArgLib = "cmd-arg-lib"

let package = Package(
    name: "cmd-arg-lib-tool",
    platforms: [.macOS(.v26)],
    products: [
        .executable(name: "caltool", targets: ["CALTool"]),
        .executable(name: "__cal_fish_completion_tool", targets: ["FishCompletionTool"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ouser4629/CmdArgLibCore.git", branch: "main"),
        .package(url: "https://github.com/ouser4629/CmdArgLibHelpScreen.git", branch: "main"),
        .package(url: "https://github.com/ouser4629/CmdArgLibManpage.git", branch: "main"),
        .package(url: "https://github.com/ouser4629/CmdArgLibMacros.git", branch: "main"),
        .package(url: "https://github.com/ouser4629/CmdArgLibCompletions.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "CALTool",
            dependencies: ["CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibHelpScreen", "CmdArgLibManpage", "CmdArgLibCompletions"]
        ),
        .executableTarget(
            name: "FishCompletionTool",
            dependencies: ["CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibHelpScreen", ]
        ),
    ]
)
