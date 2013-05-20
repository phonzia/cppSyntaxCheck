cppSyntaxCheck
version 1.1
==============
<p>This a script use g++ as a parser to check the syntax of cpp source code, and show where the errors and warnings are. Installion is in a easy way and everytime you save the file, syntax errors and warnings are showed.
<p>You can also check errors in quickfix window by using command :cw
<p>See the install details for install guide, if you find any bugs or method to make it better, please contact me using e-mail: phonzia@gmail.com
<p>
<p>Install details
<p>Put the script cppSyntaxCheck.vim in folder ~/.vim/plugin, Make sure your compiler has been installed then it works
<p>You can add statements below in order to adjust to your environment
<p>let g:include_path=":../include:./include:./tinyxml"
<p>let g:compile_flag="-D_LINUX_"
<p>let g:cpp_compiler="/usr/bin/g++"
<p>let g:enable_warning=1
<p>let g:cpp_compiler="LANG=C g++ -Wall"
<p>let g:longest_text=120

Key binding:
\<Leader\>s      go to next signed error or warning line
