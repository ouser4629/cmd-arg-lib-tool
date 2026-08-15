//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

let statefulTreeSon = """
// Copyright (c) <YEAR> <AUTHOR>

import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibHelpScreen COMPLETION_IMPORT_LINE 

struct Son {COMPLETION_GENERATOR_LINES

    @CommandNodeMacro<Format>(synopsis: "Simulate son speaking.")
    static func son(
       h__help: MetaFlag = MetaFlag(helpElements: helpElements),
       state: [Format]) -> [Format]  
    {
        var text = "I want to play chess with my sister."
        if let format = state.first {
            if format.lower { text = text.lowercased() }
            if format.upper { text = text.uppercased() }
        }
        print(text)
        return []
    }

    private static let helpElements: [ShowElement] = [
        .text("DESCRIPTION\\n", "Simulate son speaking."),
        .synopsis("\\nUSAGE\\n"),
        .text("\\nOPTIONS"),
        .parameter("h__help", "Show help information"),
    ]
}
"""

let minimalstatefulTreeSon = statefulTreeSon
