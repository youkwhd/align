(defpackage #:io
  (:use #:cl)
  (:export #:slurp))

(in-package #:io)

(defun slurp (&optional (stream *query-io*))
  (concatenate 'string 
    (loop for ch = (read-char stream nil nil)
          until (or
                  (not ch)
                  (char= ch #\Sub)
                  (char= ch #\Eot))
          collecting ch)))

