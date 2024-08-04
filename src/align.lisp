(defpackage :align
  (:use :cl)
  (:export :main)
  (:import-from :align/args
                :string))

(in-package :align)

(defun align (str seperator &key (margin 1))
  (let* ((lines (mapcar (lambda (line) (string:seperate line seperator))
                        (string:split str (format nil "~%"))))
         (max-length (reduce (lambda (acc str-length) (max acc str-length))
                       lines
                       :initial-value 0
                       :key (lambda (line)
                              (if (<= (length line) 1)
                                0
                                (length (first line)))))))
    (labels ((recurse (&optional (lines lines))
               (let ((line (first lines)))
                 (cond ((not line) lines)
                       ((< (length line) 3) (recurse (rest lines)))
                       (t
                        (setf (first line) (string:filln (first line) " " (- max-length (length (first line)))))
                        (recurse (rest lines)))))))
      (recurse)
      (string:join (mapcar (lambda (line) (string:join line "")) lines) (format nil "~%")))))

;; (("aqqqqqqqqb")
;;  ("qfoo" "=" "b")
;;  ("k" "=" "val"))

(defun main ()
  (let ((args (align/args:args))))
    ;; (print (string:seperate "q" "="))
    ;; (print (string:seperate " =" "="))
    ;; (print (string:seperate "a=" "="))
    ;; (print (string:seperate " =b" "="))
    ;; (print (string:seperate "nothing at all" "="))
    ;; (print (string:seperate "a=b" "="))
    ;; (print (string:seperate "a=b   foo=bar" "=")))
    (format t "~a" (align (format nil "aqqqqqqqqb~%qfoo=b~%k=val") "=")))
