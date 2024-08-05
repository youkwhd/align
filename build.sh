#!/usr/bin/bash

EXE=align

sbcl --non-interactive \
     --quit \
     --load common/io.lisp \
     --load common/string.lisp \
     --load src/args.lisp \
     --load src/align.lisp \
     --eval "(sb-ext:save-lisp-and-die
               \"$EXE\"
               :toplevel #'align:main
               :compression -7
               :executable t
               :save-runtime-options t)"
