(defpackage :string
  (:use :cl)
  (:export #:ends-with?
           #:starts-with?
           #:index
           #:filln
           #:join
           #:seperate
           #:split))

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

(defun filln (str val n)
  (if (= n 0)
    str
    (filln (concatenate 'string str val) val (- n 1))))

(defun join (seq str)
  (reduce (lambda (acc x) (concatenate 'string acc str x)) seq))

(defun seperate (str seperator)
  (let ((idx (index str seperator)))
    (if (not idx)
      (cons str '())
      (cons
        (subseq str 0 idx)
        (cons seperator
          (cons (subseq str (+ idx (length seperator)))
                '()))))))

(defun split (str seperator)
  (let ((idx (index str seperator)))
    (if (not idx)
      (cons str '())
      (cons
        (subseq str 0 idx)
        (split (subseq str (+ idx (length seperator))) seperator)))))
