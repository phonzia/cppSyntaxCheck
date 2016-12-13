#cppSyntaxCheck
## Introduction
This a script use g++ as a parser to check the syntax of cpp source code, and show where the errors and warnings are. Installion is in a easy way and everytime you save the file, syntax errors and warnings are showed.

See the install details for install guide, if you find any bugs or method to make it better, please contact me using e-mail: phonzia@gmail.com

## Install details
Put the script cppSyntaxCheck.vim in folder ~/.vim/plugin, Make sure your compiler has been installed then it works

You can add statements below in order to adjust to your environment

    let g:include_path=":../include:./include:./tinyxml"
    let g:compile_flag="-D_LINUX_"
    let g:cpp_compiler="/usr/bin/g++"
    let g:enable_warning=1
    let g:cpp_compiler="LANG=C g++ -Wall"

## Key binding:

* \<Leader\>s      go to next signed error or warning line
* \<Leader\>p      show complete error message, very useful when error message is too long to be displayed
