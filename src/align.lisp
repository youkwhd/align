(defpackage :align
  (:use :cl)
  (:export :main)
  (:import-from :align/args
                :string))

(in-package :align)

(defun align (str seperator)
  (let ((lines (mapcar (lambda (line) (string:seperate line seperator))
                       (string:split str (format nil "~%")))))
    lines))

(defun main ()
  (let ((args (align/args:args))))
    (print (string:seperate "q" "="))
    (print (string:seperate " =" "="))
    (print (string:seperate "a=" "="))
    (print (string:seperate " =b" "="))
    (print (string:seperate "nothing at all" "="))
    (print (string:seperate "a=b" "="))
    (print (align (format nil "foo=b~%k=val") "=")))
