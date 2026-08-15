//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibHelpScreen
import CmdArgLibMacros
import Foundation

struct EnableBasic {

    @CommandNodeMacro(synopsis: "Test if can suggest completion for a basic type or flag.")
    static func basic(
        c commandCall: CommandCall,
        _rc_ requiredCommandsSpec: Commands,
        _sc_ subcommandsSpec: Subcommands,
        h__help: MetaFlag = MetaFlag(helpElements: help),
    )  {
        if commandAreOK(c: commandCall, requiredCommandsSpec, subcommandsSpec) {
            exit(EXIT_SUCCESS)
        } else {
            exit(EXIT_FAILURE)
        }
    }

    static private let help: [ShowElement] = [
        .text("DESCRIPTION\n","Test if can suggest completion for a basic type or flag."),
        .synopsis("\nUSAGE:\n"),
        .text("\nPARAMETERS"),
        .parameter("commandCall","Command line words up to cursor - (commandline -opc)"),
        .parameter("requiredCommandsSpec","Required preceding commands, separated by whitespace"),
        .parameter("subcommandsSpec","Current command's subcommands, sperated by whitespace."),
        .parameter("h__help", "Show help information."),
    ]
}
