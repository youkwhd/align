(defpackage :align/args 
  (:use :cl)
  (:export :args))

(in-package :align/args)

(defun args ()
  ;; see: https://cl-cookbook.sourceforge.net/os.html
  (or
    #+CLISP *args*
    #+SBCL sb-ext:*posix-argv*
    #+LISPWORKS system:*line-arguments-list*
    #+CMU extensions:*command-line-words*
    nil))
