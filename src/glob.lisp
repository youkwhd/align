(defpackage #:align/glob
  (:use #:cl)
  (:export #:match))

(in-package #:align/glob)

;; NOTE: the (or) logical does not evaluate every 
;; expression, we need a way to keep consuming [abc] matches
(defun or2 (a b)
  (when a (return-from or2 t))
  (when b (return-from or2 t))
  nil)

(defun match (str pattern)
  (cond ((and (string= pattern "") (string= str "")) t)
        ((or (string= pattern "") (string= str "")) nil)
        (t (cond ((equal (elt pattern 0) #\?) (match (subseq str 1) (subseq pattern 1)))
                 ((equal (elt pattern 0) #\[)
                   (setf pattern (subseq pattern 1))
                   (labels ((recurse ()
                              (cond ((equal (elt pattern 0) #\]) nil)
                                    (t (let ((ch (elt pattern 0)))
                                         (setf pattern (subseq pattern 1))
                                         (or2 (equal ch (elt str 0)) (recurse)))))))
                     (and (recurse) (match (subseq str 1) (subseq pattern 1)))))
                 (t (and
                      (equal (elt str 0) (elt pattern 0))
                      (match (subseq str 1) (subseq pattern 1))))))))

; (format t "~a~%" (match "hello" "hello"))
; (format t "~a~%" (match "hello" "?ello"))
; (format t "~a~%" (match "hello" "?elwo"))
; (format t "~a~%" (match "hello" "[abcde]ello"))
; (format t "~a~%" (match "Hello" "[hH]ello"))
; (format t "~a~%" (match "Gello" "[Hh]ello"))
; (format t "~a~%" (match "H" "[Hh]ello"))
