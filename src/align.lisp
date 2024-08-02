(defpackage :align
  (:use :cl)
  (:export :main)
  (:import-from :align/args))

(in-package :align)

(defun main ()
  (format t "Hello from Common Lisp!~&"))
