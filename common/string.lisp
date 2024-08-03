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
        ((equal str what) t)
        (t (starts-with? (subseq str 0 (- (length str) 1)) what))))

(defun index (str what &key (from-idx 0))
  (let ((sub (subseq str 0 from-idx)))
    (cond ((ends-with? sub what) (- from-idx (length what)))
          ((equal sub str) nil)
          (t (index str what :from-idx (+ from-idx 1))))))

(defun seperate (str seperator)
  (let ((idx (index str seperator)))
    (if (not idx)
      (cons str '())
      (cons
        (subseq str 0 idx)
        (cons
          (subseq str idx (+ (length seperator) idx))
          (seperate (subseq str (+ (length seperator) idx)) seperator))))))
