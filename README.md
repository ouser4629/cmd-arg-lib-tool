## Command Argument Library Tool

`caltool` initializes Swift command line tool packages
using [Command Argument Library](https://github.com/ouser4629/cmd-arg-lib.git). The generated
Swift packages contain realistic example programs ready to be edited as needed.

In addition, `caltool` provides a development workflow for building, testing, installing, and documenting 
command line tools:

* caltool init
* develop
  * edit
  * swift test
  * swift build
  * caltool install - install the tool, completion scripts, and manual pages
  * run the tool - directly for the actual user experience, i.e., not with swift run
  * repeat
* caltool uninstall

---

## Features

- Generate Swift command line tool packages.
- Provide templates for basic, tested, documented, and hierarchical tools.
- Generate shell completion scripts for zsh and fish.
- Generate manual pages using mdoc.
- Install and uninstall executable products, shell completions, and manual pages.
- Support a repeatable edit, build, test, install workflow.
___

## Caltool Command Hierarchy

```
> caltool --tree  
caltool
├── init - initialize a new package
├── install - install executable products
└── uninstall - uninstall executable products
```

---

## Caltool Templates

`caltool init` provides the following templates for generating quick start packages:

| Template      | Type                       | Help Screen | Completion Options | Parameter Options |
|:------------- |:--------------------------- |:----------- |:------------------ |:----------------- |
| opaque        | CLI without help screen     | no          |                    | --with-less       |   
| basic         | basic CLI                   | yes         | --with-completion  | --with-less       |    
| testing       | basic CLI with tests        | yes         | --with-completion  | --with-less       |
| manpage       | basic CLI with manual pages | yes         | --with-completion  |                   |
| simple-tree   | stateless hierarchical CLI  | yes         | --with-completion  |                   |
| stateful-tree | stateful hierarchical CLI   | yes         | --with-completion  |                   |

---

## Sample Usage

<details>

<summary>Build and Install</summary>

```
> caltool init --template basic --directory MyTool --with-completion

> cd MyTool

MyTool> tree -L 3
.
├── Package.swift
└── Sources
    └── MyTool
        └── Main.swift

MyTool> swift build -c release

MyTool> caltool install --with-shells fish zsh
my-tool
    installed "my-tool" in /Users/po/.local/bin
    installed "my-tool.fish" in /Users/po/.config/fish/completions
    installed "_my-tool" in /Users/po/.config/zsh/completions
```

</details>

<details>
<summary>Generated Help Screen</summary>

```
MyTool> my-tool -h
DESCRIPTION
  Print lines containing the names of animals.

USAGE
  my-tool [-ivh] [--generate-completion-script <shell>] [-c <count>] <animal>

ARGUMENT
  <animal>                              The name of an animal (can be repeated).

OPTIONS
  -c/--count <count>                    The number of times to repeat the line
                                        (default: 1).
  -i/--index                            Prefix each line with an index.
  -h/--help                             Show this help message.
  -v/--version                          Show version information.
  --generate-completion-script <shell>  Generate a completion script for "zsh" or
                                        "fish".

NOTES
  The available animals are "bear", "fox" and "wolf".

  The value <count>, if specified, must be between 1 and 3.
```

</details>

<details>
<summary>Generated Command Tool in Action</summary>

```
MyTool> my-tool fox bear wolf
fox, bear and wolf

MyTool> my-tool -i --count 2 bear
1: bear
2: bear

MyTool> my-tool -izxc2.0 ant bee
Errors:
  unrecognized options: "-z" and "-x", in "-izxc2.0"
  "2.0" is not a valid <count> after -c
  "ant" is not a valid <animal>
  "bee" is not a valid <animal>
See "my-tool --help" for more information.
```

</details>

<details>
<summary>Cleanup</summary>

```
MyTool> caltool uninstall
my-tool
    uninstalled "my-tool" in /Users/po/.local/bin
    uninstalled "my-tool.fish" in /Users/po/.config/fish/completions
    uninstalled "_my-tool" in /Users/po/.config/zsh/completions
```

</details>

---

## Caltool Help Screens

<details>
<summary>caltool</summary>

```
> caltool -h
DESCRIPTION
  Create and manage Swift executable products.

USAGE
  caltool [-htv] [<configuration-option>...] <subcommand>

OPTIONS
  -h/--help                   Show this help screen.
  -t/--tree                   Show the command hierarchy.
  -v/--version                Show the version.
  <configuration-options>...  Global configuration options (described in the manual
                              page).

SUBCOMMANDS
  init       Initialize a new package.
  install    Install executable products.
  uninstall  Uninstall executable products.
```

</details>

<details>
<summary>caltool init</summary>

```
> caltool init -h
DESCRIPTION
  Initialize a Swift package containing an executable product.

USAGE
  caltool init [-hcl] [-d <directory>] [-n <product>] -t <template>

OPTIONS
  -c/--with-completion        Add zsh and fish completion generation support to the
                              executable product. Does not apply to the "opaque"
                              template.
  -l/--with-less              Use a template variant with fewer example parameters.
                              Applies only to "opaque", "basic" and "testing".
  -h/--help                   Show this help screen.
  -d/--directory <directory>  The directory containing the new package (default: the
                              current directory). If the  <directory> is specified
                              and does not exist, it will be created.
  -n/--name <product>         The name of the product (default: the package name in
                              kebab-case).
  -t/--template <template>    The template to use.

TEMPLATES
  opaque                      A product without a help screen.
  basic                       A product with a help screen.
  testing                     A product with unit tests.
  manpage                     A product with a manual page.
  simple-tree                 A product with commands and subcommands.
  stateful-tree               A product with stateful commands and subcommands.

NOTES
  The package name defaults to the last component of the specified directory path.
```  

</details>

<details>
<summary>caltool install</summary>

```
> caltool install -h
DESCRIPTION
  Install executable products and generate associated shell completion scripts and
  manual pages.

USAGE
  caltool install [-h] [-m <manpage>...] [-c <shell>...] [<product>...]

OPTIONS
  -h/--help                                Show this help screen.
  -m/--with-manpages <manpage>...          Generate and install manual pages for the
                                           indicated products.
  -c/--with-completion-scripts <shell>...  For each product, generate and install
                                           completion scripts for the indicated
                                           shells (available shells: "zsh" and
                                           "fish").
  <product>...                             The names of products to install (default:
                                           executable products in the release
                                           directory).
```  
                             
</details>

<details>
<summary>caltool uninstall</summary>

```
> caltool uninstall -h
DESCRIPTION
  Uninstall executable products, including associated shell completion scripts and
  manual pages.

USAGE
  caltool uninstall [-ih] [-I <limit>] [<product>...]

OPTIONS
  -i/--confirm-each          Request confirmation before attempting to remove each
                             product.
  -I/--confirm-once <limit>  Request confirmation just once if more than <limit>
                             products are being removed.
  -h/--help                  Show this help message.
  <product>...               Names of products to uninstall (default: the names of
                             products in the release directory).

NOTE
  The -i and -I options override each other; the last one specified determines how
  product removal is confirmed.
```

</details>

---

## CalTool Manual Pages

This repository includes `mdoc` source for the `caltool` [manual pages](MANPAGES).

After cloning, you can view the manual pages before installation. E.g.,

```
 cmd-arg-lib-tool> man ./MANPAGES/caltool.1
```

If you are not familiar with `less`, which is used to view manual pages, press "q" to exit.

---

## Installation


<details>
<summary>Prepare</summary>

These instructions are for installing on macOS. They assume common local installation paths for fish and zsh. 

Adjust as needed for your operating system and environment.

* For fish
  * mkdir -p ~/.local/bin 
  * mkdir -p ~/.config/fish/completions
  * mkdir -p ~/.local/share/man/man1
  * run fish_add_path -a ~/.local/bin
  * add "set -gx MANPATH ~/.local/share/man/man1 "" $MANPATH" to ~/.config/fish
  
* For zsh
  * mkdir -p ~/.local/bin 
  * mkdir -p ~/.config/zsh/completions
  * mkdir -p ~/.local/share/man/man1
  * add "path=(/Users/<your-id>/.local/bin $path)" to your zshrc file
  * add "fpath=(/Users/<your-id>/.config/zsh/completions $fpath)" to your zshrc file
  * add "export MANPATH="$HOME/.local/share/man/man1:$MANPATH:"" to your zshrc file
  * start a new terminal so the changes take effect
  
</details>

<details>
<summary>Install</summary>

```
> git clone https://github.com/ouser4629/cmd-arg-lib-tool.git
Cloning into 'cmd-arg-lib-tool'...

> cd cmd-arg-lib-tool

> swift build -c release
Building for production...

> .build/release/caltool install
__cal_fish_completion_tool
    installed "__cal_fish_completion_tool" in /Users/ps/.local/bin
caltool
    installed "caltool" in /Users/ps/.local/bin
    
cmd-arg-lib-tool> caltool install -s fish zsh -m caltool caltool/init caltool/install caltool/uninstall
__cal_fish_completion_tool
    installed "__cal_fish_completion_tool" in /Users/po/.local/bin
caltool
    installed "caltool" in /Users/po/.local/bin
    installed "_caltool" in /Users/po/.config/zsh/completions
    installed "caltool.fish" in /Users/po/.config/fish/completions
    installed "caltool.1" in /Users/po/.local/share/man/man1
    installed "caltool-init.1" in /Users/po/.local/share/man/man1
    installed "caltool-install.1" in /Users/po/.local/share/man/man1
    installed "caltool-uninstall.1" in /Users/po/.local/share/man/man1
```

You might need to refresh the shell's completion script cache. One way is
to open a new tab by pressing `<CMD-T>`.

</details>

---

## Project Status

This software is licensed under the [Mozilla Public License, v. 2.0 "MPL-2.0"](https://mozilla.org/MPL/2.0).

`caltool` is currently in beta (version 0.5.0), and has only been tested for macOS.

`caltool` requires macOS 12, and should be built using Swift 6.2 or later. Earlier toolchains 
either do not support macros or have unacceptable macro build performance.

## See Also

[CmdArgLibCore](https://github.com/ouser4629/CmdArgLibCore.git), 
[CmdArgLibMacros](https://github.com/ouser4629/CmdArgLibMacros.git), 
[CmdArgLibCommandNodeStruct](https://github.com/ouser4629/CmdArgLibCommandNodeStruct.git), 
[CmdArgLibHelpScreen](https://github.com/ouser4629/CmdArgLibHelpScreen.git), 
[CmdArgLibManpage](https://github.com/ouser4629/CmdArgLibManpage.git), 
[CmdArgLibCompletions](https://github.com/ouser4629/CmdArgLibCompletions.git), 
[CmdArgLibTestSupport](https://github.com/ouser4629/CmdArgLibTestSupport.git) 
