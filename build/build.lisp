;; loads your common lisp configuration and quicklisp
;; see: https://lispcookbook.github.io/cl-cookbook/scripting.html#quickloading-dependencies-from-a-script
(load "~/.sbclrc")

(load "common/io.lisp")
(load "common/string.lisp")
(load "src/args.lisp")
(load "src/align.lisp")

(sb-ext:save-lisp-and-die
  "build/align"
  :toplevel 'align:main
  :executable t)
