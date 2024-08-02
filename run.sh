#!/usr/bin/bash

sbcl --non-interactive \
     --load src/args.lisp \
     --load src/align.lisp \
     --eval "((lambda () (format t \"~%[$0 ::]~%\") (align:main)))" $0
