(defpackage :string
  (:use :cl)
  (:export :seperate))

(in-package :string)

(defun ends-with? (str what)
  (cond ((equal str "") nil)
        ((equal str what) t)
        (t (ends-with? (subseq str 1) what))))

(defun starts-with? (str what)
  (cond ((equal str "") nil)
        ((equal str what)
         t)
        (t (starts-with? (subseq str 0 (- (length str) 1)) what))))

(defun index (str what &key (from 0))
  (labels ((recurse (str what &optional (idx from))
             (let ((sub (subseq str 0 idx)))
               (cond ((ends-with? sub what) (- idx (length what)))
                     ((equal sub str) nil)
                     (t (recurse str what (+ idx 1)))))))
    (recurse str what)))

(defun seperate (str seperator)
  (let ((idx (index str seperator)))
    (if (not idx)
      (list str "")
      (list (subseq str 0 idx) (subseq str idx)))))
