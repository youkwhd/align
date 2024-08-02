(defpackage :align
  (:use :cl)
  (:export :main)
  (:import-from :align/args))

(in-package :align)

(defun main ()
  (let ((args (align/args:args))))
    )
