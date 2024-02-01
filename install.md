# Orion - Installation Guide

# Requirements

1. Operating System: Linux/MacOS/Windows
2. OPAM (OCaml Package Manger)
3. ANSITerminal

# Instructions to Install and Run

# Follow the instructions from this link to install opam: https://cs3110.github.io/textbook/chapters/preface/install.html

# 1. We must install an additional OPAM package, run the following commands(omitting brackets):

[opam update]

## (This may take a while, so do not panic, it can take up to 10+ minutes!)

## If it asks you to upgrade aready installed packages, which it likely will, do so using:

[opam upgrade]

## Now you must install ANSITerminal to allow for the text user interface using:

[opam install ANSITerminal]

# The next two steps are necessary only if your terminal is not currently in the directory the source code was extracted into when it was unzipped. This should be named "Orion-main". If your terminal IS currently in the project directory, you can skip to step 4.

# 2. Ensure the terminal is currently in the working directory you put the zip file in. If it isnt, input the following command (omitting brackets) replacing "yourworkingdir" with the name of the directory the zip file was placed in. Otherwise, continue to next step.

[cd yourworkingdir]

# 3. After you unzipped your file, the source code was extracted into a directory named "Orion-main". Input the following commands in the terminal to access this project directory (omitting brackets):

[cd Orion]

# 4. Building the project: In the project directory, run the following command in your terminal(omitting brackets):

[make build]

# 6. Running the project: In the project directory, run the following commands in your terminal(without brackets):

[make plan]

Once you’re done with that you have access to the working interface of our project so far.
PLAY AROUND WITH THE FEATURES!!!

## Notes

# To view the documentation you can run `make doc` followed by `make opendoc` to open the documentation folder

## TROUBLESHOOTING

• If the installation fails due to a missing dependency, check the error message for instructions on how to install the missing dependency.
• If you encounter any other issues, please refer to the project documentation.
