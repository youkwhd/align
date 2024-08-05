#!/usr/bin/bash

EXE=align

# from -7 to 22 (lowest better)
COMPRESSION_LEVEL=-7

sbcl --non-interactive \
     --quit \
     --load common/io.lisp \
     --load common/string.lisp \
     --load src/args.lisp \
     --load src/align.lisp \
     --eval "(sb-ext:save-lisp-and-die
               \"$EXE\"
               :toplevel #'align:main
               :compression $COMPRESSION_LEVEL
               :executable t
               :save-runtime-options t)"
