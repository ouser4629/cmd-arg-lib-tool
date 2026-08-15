//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibMacros
import Foundation

struct Uninstall {

    typealias Limit = Int

    @CommandNodeMacro<GlobalOptions>(
        shadowGroups: ["confirmEach confirmEachLimit"],
        synopsis: "Uninstall executable products."
    )
    static func uninstall(
        i__confirmEach confirmEach: Flag,
        I__confirmOnce confirmEachLimit: Limit?,
        generateManpage: MetaFlag = MetaFlag(manpageElements: manpageElements),
        h__help help: MetaFlag = MetaFlag(helpElements: helpElements),
        _ productNames: Variadic<Product> = [],
        state: [GlobalOptions]) async throws -> [GlobalOptions]
    {
        guard let globalOptions = state.first else { fatalError() }
        let uninstaller = Uninstaller(globalOptions: globalOptions)
        try await uninstaller.uninstall(productNames, confirmEach: confirmEach, confirmEachLimit: confirmEachLimit)
        return []
    }

    static let helpElements: [ShowElement] = [
        .text("DESCRIPTION\n", helpOverview),
        .synopsis("\nUSAGE\n", line: ["$*", "!generateManpage"],),
        .text("\nOPTIONS"),
        .parameter("confirmEach", "Request confirmation before attempting to remove each product"),
        .parameter("confirmEachLimit", "Request confirmation just once if more than $E{confirmEachLimit} products are being removed"),
        .parameter("help", "Show this help message"),
        .parameter( "productNames", "Names of products to uninstall (default: the names of products in the release directory)"),
        .text("\nNOTE\n", shadowNote),
    ]

    static let helpOverview = """
        Uninstall executable products, including associated shell completion scripts and
        manual pages.
        """

    static let confirmEachLimitNote = """
        Request confirmation just once if more than $E{confirmEachLimit} products are being removed (default: 
        """

    static let shadowNote = """
        The $S{confirmEach} and $S{confirmEachLimit} options override each other; the last one specified
        determines how product removal is confirmed.
        """

    static let manpageElements: [ShowElement] = [
        .prologue(description: "uninstall executable products"),
        .synopsis(lines: [
            ["$*", "!generateManpage"],
            ["$generateManpage:Flag="]
        ]),
        .mdoc("DESCRIPTION", manpageOverview1),
        .mdoc("", manpageOverview2),
        .mdoc("", "The following options are available:"),
        .parameter("confirmEach", "Request confirmation before attempting to remove each file"),
        .parameter("confirmEachLimit", "Request confirmation just once if more than $E{confirmEachLimit} products are being removed"),
        .parameter("generateManpage", "Generate the mdoc source for this manual page and write it to standard output"),
        .parameter("help", "Show a help screen"),
        .mdoc("\n", shadowNote),
        .mdoc("", Main.exitStatus),
        .mdoc("", seeAlso),
        .mdoc("", Main.authors),
    ]

    static let manpageOverview1 = """
        The $N{-} utility uninstalls the indicated executable products.
        If no product names are specified, it uses the names of executalbe products in the release
        directory.
        """

    static let manpageOverview2 = """
        When a product, say "name" is uninstalled, its associated shell completions are uninstalled, as
        well as any manpage whose name matches the glob pattern "name*". 
        """

    static let manpageEnvironmentNote = """
       The $T{productDir} and $T{manpageDir} should be on the shell's PATH and MANPATH, respectively. The $T{zshDir} 
       and $T{fishDir} should be on zsh's fpath and fish's fish_complete_path, respectively. None of these directories
       can require super user write privileges. 
       """

    static let seeAlso = """
        .Sh SEE ALSO
        .Xr caltool 1 ,
        .Xr caltool-init 1 ,
        .Xr caltool-install 1
        """
}
