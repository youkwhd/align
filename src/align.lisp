(defpackage :align
  (:use :cl)
  (:export :main)
  (:import-from :align/args
                :string))

(in-package :align)

(defun align (str)
  ())

(defun main ()
  (let ((args (align/args:args))))
    (print (string:seperate "foo=bar" "=")))
