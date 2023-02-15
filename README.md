# macportsAssistant

## Description and Version Information
These shell utilities work on Macintosh macOS 13 Ventura and later to either automate the installation of MacPorts, upgrade MacPorts if an installation for an earlier version of macOS exists, or update the current macPorts version if it was installed using **macportsAssistant**. See the file [VERSION](VERSION) in this directory for version information.

## Usage Instructions
Both the installation and upgrade utilities must be ran as root and will create a `~/bin/MacPorts` directory to work from and add it to your path envars. In addition, they install a third utility to automate MacPorts updating (`macports_updater.sh`) which must also be ran as root. See the file [USING](USING) in this directory for basic usage instructions.

## Code, Testing, and Other Contributions
Both the install and upgrade utilities can be further improved by combining them into a single script that determines at runtime if MacPorts is (1) installed and already the current version, (2) is installed, but not the current version, or (3) is not installed, then calling the appropriate functionality from there. Contributors/testers may find other areas of improvement. See the files [AUTHORS](AUTHORS) and [CONTRIBUTING](CONTRIBUTING) in this directory for contributing parties and contribution information.

## Error Reporting
If this is a beta release, you may find that the program is unfinished. Even if it is a maintenance release, you may encounter bugs. If you do, please report them. Your bug reports are valuable contributions to Positronikal since they allow us to notice and fix problems on machines we don't have or in code we don't use often. See the file [BUGS](BUGS) in this directory for error reporting information.

## EULA
Claims, copyrights, and licensing information can be found in the files [ATTRIBUTION](ATTRIBUTION) and [COPYING](COPYING) in this directory.

Hoyt Harness, [Positronikal](https://positronikal.github.io/), [(Email)](mailto:hoyt.harness@gmail.com), 2023
