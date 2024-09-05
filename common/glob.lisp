(defpackage #:glob
  (:use #:cl)
  (:export #:match
           #:index))

(in-package #:glob)

;; NOTE: the (or) logical does not evaluate every 
;; expression, we need a way to keep consuming [abc] matches
(defun or2 (a b)
  (when a (return-from or2 t))
  (when b (return-from or2 t))
  nil)

(defun bool-to-int (bool)
  (if (equal bool nil) 0 1))

(defun int-to-bool (int)
  (if (<= int 0) nil t))

(defun match (str pattern &optional (exact t))
  (let ((matched 0))
    (labels ((recurse (str pattern &optional (exact exact))
             (cond ((and exact (string= pattern "") (string= str "")) t)
                   ((and (not exact) (string= pattern "")) t)
                   ((or (string= pattern "") (string= str "")) nil)
                   (t (cond ((equal (elt pattern 0) #\?)
                              (setf matched (+ matched 1))
                              (recurse (subseq str 1) (subseq pattern 1) exact))
                            ((equal (elt pattern 0) #\[)
                              (setf pattern (subseq pattern 1))
                              (labels ((rrange ()
                                         (cond ((equal (elt pattern 0) #\]) nil)
                                               ((and (>= (length pattern) 3) (equal (elt pattern 1) #\-))
                                                 (let ((includes-ch (loop for ch from (char-code (elt pattern 0))
                                                                                 to (char-code (elt pattern 2))
                                                                          when (equal (code-char ch) (elt str 0))
                                                                          return t)))
                                                   (setf pattern (subseq pattern 3))
                                                   (or2 includes-ch (rrange))))
                                               (t (let ((ch (elt pattern 0)))
                                                    (setf pattern (subseq pattern 1))
                                                    (or2 (equal ch (elt str 0)) (rrange)))))))
                                (let ((equiv (rrange)))
                                  (setf matched (+ matched (bool-to-int equiv)))
                                  (and
                                    equiv
                                    (recurse (subseq str 1) (subseq pattern 1) exact)))))
                            (t (let ((equiv (equal (elt str 0) (elt pattern 0))))
                                 (setf matched (+ matched (bool-to-int equiv)))
                                 (and
                                   equiv
                                   (recurse (subseq str 1) (subseq pattern 1) exact)))))))))
    (if (recurse str pattern) matched 0))))

(defun index (str pattern)
  (labels ((recurse (str pattern &optional (index 0))
             (cond ((string= str "") nil)
                   ((int-to-bool (match str pattern nil)) index)
                   (t (recurse (subseq str 1) pattern (+ index 1))))))
    (recurse str pattern)))
