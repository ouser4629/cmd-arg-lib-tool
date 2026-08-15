//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibHelpScreen
import CmdArgLibCompletions
import CmdArgLibMacros

typealias Product = String
typealias ReleaseDirectory = String
typealias ProductDirectory = String
typealias ManpageDirectory = String
typealias ZshDirectory = String
typealias FishDirectory = String
typealias Path = String
typealias Manpage = String

// Shell is taken


struct Install {

    typealias Shell = ShellType

    @CommandNodeMacro<GlobalOptions>(
        synopsis: "Install executable products."
    )
    static func install(
        m__withManpages manpages: Variadic<Manpage> = [],
        c__withCompletionScripts shells: Variadic<Shell> = [],
        _ productNames: Variadic<Product> = [],
        generateManpage: MetaFlag = MetaFlag(manpageElements: manpageElements),
        h__help help: MetaFlag = MetaFlag(helpElements: helpElements),
        state: [GlobalOptions]) async throws -> [GlobalOptions]
    {
        guard let globalOptions = state.first else {
            fatalError("Missing global options")
        }
        let installer = Installer(
            globaleOptions: globalOptions,
            shellIdentifiers: shells,
            manpages: manpages)
        try await installer.install(productNames, with: manpages)
        return []
    }

    static let helpElements: [ShowElement] = [
        .text("DESCRIPTION\n", helpOverview),
        .synopsis("\nUSAGE\n", line: ["!generateManpage"]),
        .text("\nOPTIONS"),
        .parameter("help", "Show this help screen"),
        .parameter("manpages", manpageSynopsis),
        .parameter("shells", shellsSynopsis, .list(ShellType.cases)),
        .parameter("productNames", "The names of products to install (default: executable products in the release directory)"),
    ]

    static let helpOverview = """
        Install executable products and generate associated shell completion scripts and manual pages.
        """

    static let shellsSynopsis = """
        For each product, generate and install completion scripts for the indicated shells (available shells: \(ShellType.andCases()))
        """

    static let manpageSynopsis = """
        Generate and install manual pages for the indicated products
        """

    static let manpageElements: [ShowElement] = [
        .prologue(description: "install executable products"),
        .synopsis(lines: [
            ["$*", "!generateManpage"],
            ["$generateManpage:Flag="]
        ]),
        .mdoc("DESCRIPTION", productNote),
        .mdoc("","The following options are available:"),
        .parameter("help", "Show a help screen"),
        .parameter("manpages", manpageSynopsis),
        .parameter("shells", shellsSynopsis, .list(ShellType.cases)),
        .parameter("generateManpage", "Generate the mdoc source for this manual page and write it to standard output"),
        .mdoc("\n", completionInstallationNote),
        .mdoc("\n", manpageInstallationNote),
        .mdoc("", Main.exitStatus),
        .mdoc("", seeAlso),
        .mdoc("", Main.authors),
    ]

    static let productNote: String = """
        By default, $F{-} installs all of the executable products in the release directory. 
        If one or more product names are specified, only those products will be installed.
        
        """

     static let completionInstallationNote = """
        The $F{-} utility obtains the completion script for a given shell by calling the product with 
        .Fl -generate-completion-script Ar shell_name .
        The fish completion script requires that
        .Dq __fish_completion_tool
        be installed in a directory in the shell's path.
        
        """

    static let manpageInstallationNote = """
       By default, one manpage is installed for each product that can generate a manpage. I.e.,
       a product that has a $L{generateManpage} option. Alternatively, only the manpages
       specified after $S{manpages} or $L{manpages} will be installed. Each name must be a 
       product name or, for subcommands, subcommand path, separated by "/". For example,
       "$S{manpages} caltool/install" generates a manual page for this subcommand named "caltool-install".
       
       """

    static let seeAlso = """
        .Sh SEE ALSO
        .Xr caltool 1 ,
        .Xr caltool-init 1 ,
        .Xr caltool-uninstall 1 
        """
}
