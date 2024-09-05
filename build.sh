#!/usr/bin/bash

EXE=align
COMPRESSION_LEVEL=nil

if [[ $1 = "--compress" ]]; then
    # from -7 to 22 (lowest better)
    COMPRESSION_LEVEL=-7

    if [ ! -z $2 ]; then
        COMPRESSION_LEVEL=$2
    fi
fi

sbcl --non-interactive \
     --load common/io.lisp \
     --load common/glob.lisp \
     --load common/string.lisp \
     --load src/args.lisp \
     --load src/align.lisp \
     --eval "(sb-ext:save-lisp-and-die
               \"$EXE\"
               :toplevel #'align:main
               :compression $COMPRESSION_LEVEL
               :executable t
               :save-runtime-options t)"
