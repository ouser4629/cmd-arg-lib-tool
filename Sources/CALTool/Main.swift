//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibHelpScreen
import CmdArgLibManpage
import CmdArgLibCompletions
import CmdArgLibMacros
import Foundation

@main
struct Main {

    typealias Shell = CompletionGenerator
    
    @CommandNodeMacro<GlobalOptions>(
        synopsis: "", children: subcommands
    )
    private static func caltool(
        R__releaseDir releaseDir: ReleaseDirectory = GlobalOptions.defaultReleaseDir,
        P__productDir productDir: ProductDirectory = GlobalOptions.defaultProductDir,
        M__manpageDir manpageDir: ManpageDirectory = GlobalOptions.defaultManpageDir,
        F__fishDir fishDir: FishDirectory = GlobalOptions.defaultFishDir,
        Z__zshDir zshDir: ZshDirectory = GlobalOptions.defaultZshDir,
        generateCompletionScript: MetaOption<Shell> = completionScript,
        generateManpage: MetaFlag = MetaFlag(manpageElements: manpageElements),
        t__tree tree: MetaFlag = MetaFlag(treeFor: "caltool", synopsis: ""),
        v__version version: MetaFlag = MetaFlag(string: "caltool 0.5.0"),
        h__help help: MetaFlag = MetaFlag(helpElements: helpElements),
        state: [GlobalOptions]) -> [GlobalOptions]
    {
        let globalOptions = GlobalOptions(
            releaseDir: releaseDir,
            productDir: productDir,
            manpageDir: manpageDir,
            fishDir: fishDir,
            zshDir: zshDir
        )
        return [globalOptions]
    }

    private static let subcommands = [Init.commandNode, Install.commandNode, Uninstall.commandNode]
    private static let generator = Shell(name: "caltool", suggestionElements: helpElements)
    private static let completionScript = MetaOption(generator)

    private static let helpElements: [ShowElement] = [
        .text("DESCRIPTION\n", "Create and manage Swift executable products."),
        .synopsis("\nUSAGE\n", line: ["help",  "tree", "version", "$_:Variadic<ConfigurationOption>=", "$_:Subcommand"]),
        .text("\nOPTIONS"),
        .parameter("help", "Show this help screen"),
        .parameter("tree", "Show the command hierarchy"),
        .parameter("version", "Show the version"),
        .pseudoParameter("<configuration-options>...", "Global configuration options (described in the manual page)"),
        .text("\nSUBCOMMANDS"),
        .commandContext(Init.commandNode.context),
        .commandContext(Install.commandNode.context),
        .commandContext(Uninstall.commandNode.context),
    ]

    static let manpageElements: [ShowElement] = [
        .prologue(description: "create and manage Swift executable products"),
        .synopsis(lines: [
            ["help",  "tree", "version","$_:Subcommand"],
            ["$generateCompletionScript:Variadic<Shell>="],
            ["$generateManpage:Flag="],
        ]),
        .mdoc("DESCRIPTION\n", manpageDescription),
        .mdoc("", cmdArgLibNote),
        .mdoc("", "The following options are available:"),
        .parameter("help", "Show this help screen"),
        .parameter("tree", "Show the command hierarchy"),
        .parameter("version", "Show the version"),
        .mdoc("META-OPTIONS", "The following meta-options are used when configuring the $F{} installation."),
        .parameter("generateCompletionScript","Print a completion script for $F{} for the indicated shell (\(ShellType.orCases()))"),
        .parameter("generateManpage", "Generate the mdoc source for this manual page and write it to stadard output"),
        .mdoc("CONFIGURATION OPTIONS", globalOptionNote),
        .mdoc("", availableGlobalOptions),
        .parameter("fishDir", "The directory for fish completion files", .path),
        .parameter("manpageDir", "The directory in which to install manpages", .path),
        .parameter("productDir", "The directory in which to install the products", .path),
        .parameter("releaseDir", "The directory containing the package's products", .path),
        .parameter("zshDir", "The directory for zsh completion files", .path),
        .mdoc("SUBCOMMANDS", "The available subcommands are:"),
        .commandContext(Init.commandNode.context),
        .commandContext(Install.commandNode.context),
        .commandContext(Uninstall.commandNode.context),
        .mdoc("EXAMPLES",examples),
        .mdoc("ENVIRONMENT", manpageEnvironmentNote1),
        .mdoc("", manpageEnvironmentNote2),
        .mdoc("", manpageEnvironmentNote3),
        .mdoc("", exitStatus),
        .mdoc("", seeAlso),
        .mdoc("", authors),
    ]

    static let manpageDescription = """
        The $F{} utility initializes packages for building executable products. Generated
        products can include support for generating shell completion scripts and
        manual pages. The utility can also install and uninstall products locally.

        """

    static let cmdArgLibNote = """
        Generated packages depend on modules from Command Argument Library. 
        .Lk https://github.com/ouser4629/cmd-arg-lib.git Command Argument Library .
        
        """

    static let manpageEnvironmentNote1 = """
       The $T{productDir} and $T{manpageDir} should appear in the shell's PATH and MANPATH, respectively. 
       """

    static let manpageEnvironmentNote2 = """
       The $T{zshDir} and $T{fishDir} should be on zsh's FPATH and fish's 
       fish_complete_path, respectively.
       """

    static let manpageEnvironmentNote3 = """
       These directories should be writable without superuser privileges. 
       """

    static let exitStatus = """
        .Sh EXIT STATUS
        The
        .Nm
        utility returns zero on success and non-zero on failure.
        """

    private static let name = commandNode.name

    private static let examples = """
        Initialize, build, install and run a sample product with unit testing
        and completion scripts.
        .Pp
        .Dl > mkdir Demo && cd Demo
        .Dl Demo> \(name) init --with-completion --template testing
        .Dl Demo> swift test
        .Dl Demo> swift build -c release 
        .Dl Demo> \(name) install --with-shells fish zsh
        .D1 > cd
        .D1 > demo -h
        .D1 > demo -uc2 wolf
        .Pp
        Initialize, build, install and run a sample product with a custom 
        name and a manual page generator, in a new directory
        .Pp
        .Dl > mkdir Demo && cd Demo
        .Dl Demo> \(name) init --template manpage -d ManpageExample --name man-ex
        .Dl Demo> cd ManpageExample
        .Dl ManpageExample> swift build -c release 
        .Dl ManpageExample> \(name) install
        .Dl ManpageExample> man-ex -h
        .Dl ManpageExample> man man-ex
        .Dl ManpageExample> man-ex -ic2 -g "Good to see you, " Sammy
        """

    static let globalOptionNote = """
        Global options are specified on the top-level command and inherited by its subcommands.
        
        """

    static let availableGlobalOptions = """
        The following global options are available:
        
        """

    private static let seeAlso = """
        .Sh SEE ALSO
        .Xr \(name)-init 1 ,
        .Xr \(name)-install 1 ,
        .Xr \(name)-uninstall 1
        """

    static let authors = """
        .Sh AUTHOR
        The 
        .Nm
        utility was written by
        .%A Peter Buenafuente Summerland .
        """

    private static func main() async
    {
        await runAsMain(commandNode)
    }
}
