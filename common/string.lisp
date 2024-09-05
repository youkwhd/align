(defpackage #:string
  (:use #:cl)
  (:import-from #:glob)
  (:export #:ends-with?
           #:starts-with?
           #:index
           #:filln
           #:join
           #:repeat
           #:seperate
           #:split))

(in-package #:string)

(defun ends-with? (str what)
  (cond ((string= str "") nil)
        ((string= str what) t)
        (t (ends-with? (subseq str 1) what))))

(defun starts-with? (str what)
  (cond ((string= str "") nil)
        ((string= str what) t)
        (t (starts-with? (subseq str 0 (- (length str) 1)) what))))

(defun index (str what &key (from-idx 0))
  (let ((sub (subseq str 0 from-idx)))
    (cond ((ends-with? sub what) (- from-idx (length what)))
          ((string= sub str) nil)
          (t (index str what :from-idx (+ from-idx 1))))))

(defun filln (str val n)
  (if (= n 0)
    str
    (filln (concatenate 'string str val) val (- n 1))))

(defun join (seq str)
  ;; passing empty list to reduce
  ;; seems to cause an error.
  (if (not seq)
    '()
    (reduce (lambda (acc x) (concatenate 'string acc str x)) seq)))
  

(defun repeat (str n)
  (join
    (loop for val = str
          repeat n
          collect val) ""))

(defun seperate (str seperator)
  (let ((idx (glob:index str seperator)))
    (when (not idx) (return-from seperate (list str)))
    (let ((len (glob:match (subseq str idx) seperator nil)))
      (cons
        (subseq str 0 idx)
        (cons (subseq str idx (+ idx len))
          (cons (subseq str (+ idx len)) '()))))))

(defun split (str seperator)
  (let ((idx (index str seperator)))
    (if (not idx)
      (cons str '())
      (cons
        (subseq str 0 idx)
        (split (subseq str (+ idx (length seperator))) seperator)))))
