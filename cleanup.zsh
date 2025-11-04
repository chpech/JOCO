#!/bin/zsh
cd /Users/pech/Library/Preferences/GAP/pkg/joco
touch test.txt~
rm **/*~ 

cd /Users/pech/Library/Preferences/GAP/pkg/joco/doc
setopt extended_glob
touch test.txt
rm ^(joco.bib|joco.xml|gapdoc.dtd|gapdoc.rnc|directory_name)
