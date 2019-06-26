#!/bin/sh
nim c --out:../bin/ndtrl src/main.nim
cd bin
ndtrl
cd ..