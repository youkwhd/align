#!/usr/bin/bash

sbcl --non-interactive \
     --load common/io.lisp \
     --load common/string.lisp \
     --load src/glob.lisp \
     --load src/args.lisp \
     --load src/align.lisp \
     --eval "((lambda () (format t \"~%[$0 ::]~%\") (align:main)))" -- $@
