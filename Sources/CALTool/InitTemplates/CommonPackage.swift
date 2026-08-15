//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

let commonPackage = """
// Copyright (c) <YEAR> <AUTHOR>

// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "TARGET_NAME",
    platforms: [.macOS(.v26)],

    products: [
        .executable(name: "PRODUCT_NAME", targets: ["TARGET_NAME"])
    ],

    dependencies: [
        .package(url: "https://github.com/ouser4629/CmdArgLibCore.git", branch: "main"),
        .package(url: "https://github.com/ouser4629/CmdArgLibMacros.git", branch: "main"), 
        .package(url: "https://github.com/ouser4629/CmdArgLibHelpScreen.git", branch: "main"), COMPLETION_PACKAGE_DEPENDENCY_LINE MANPAGE_PACKAGE_DEPENDENCY_LINE
    ],

    targets: [
        .executableTarget(
            name: "TARGET_NAME",
            dependencies: [
                "CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibHelpScreen", COMPLETION_TARGET_DEPENDENCY_WORD MANPAGE_TARGET_DEPENDENCY_WORD
            ]
        ),
    ]
)
"""
