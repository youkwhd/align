(defpackage #:align/glob
  (:use #:cl)
  (:export #:match))

(in-package #:align/glob)

(defun match (str pattern)
  (cond ((and (string= pattern "") (string= str "")) t)
        ((or (string= pattern "") (string= str "")) nil)
        (t (cond ((equal (elt pattern 0) #\?) (match (subseq str 1) (subseq pattern 1)))
                 (t (and
                      (equal (elt str 0) (elt pattern 0))
                      (match (subseq str 1) (subseq pattern 1))))))))

; (format t "~a~%" (match "hello" "hello"))
; (format t "~a~%" (match "hello" "?ello"))
; (format t "~a~%" (match "hello" "?elwo"))
