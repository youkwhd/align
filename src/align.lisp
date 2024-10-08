(defpackage #:align
  (:use #:cl)
  (:export #:main)
  (:import-from #:align/args)
  (:import-from #:string)
  (:import-from #:io))

(in-package #:align)

(defun align (str seperator &key (margin 1))
  (let* ((lines (mapcar (lambda (line) (string:seperate line seperator))
                        (string:split str (format nil "~%"))))
         (max-length (reduce (lambda (acc str-length) (max acc str-length))
                       lines
                       :initial-value 0
                       :key (lambda (line)
                              (if (<= (length line) 1)
                                0
                                (progn
                                  ;; TODO: this is a hack to set spacing margin.
                                  ;;
                                  ;; this should be on it's own loop, but i did it here
                                  ;; for 'optimization' (?) just so that we don't do a
                                  ;; O(2n) loop.
                                  (when (not (string:ends-with? (first line) (string:repeat " " margin)))
                                    (setf (first line) (concatenate 'string (first line) (string:repeat " " margin))))
                                  (when (not (string:starts-with? (third line) (string:repeat " " margin)))
                                    (setf (third line) (concatenate 'string (string:repeat " " margin) (third line))))
                                  (length (first line))))))))
    (labels ((recurse (&optional (lines lines))
               (let ((line (first lines)))
                 (cond ((not line) lines)
                       ((< (length line) 3) (recurse (rest lines)))
                       (t
                        (setf (first line) (string:filln (first line) " " (- max-length (length (first line)))))
                        (recurse (rest lines)))))))
      (recurse)
      (string:join (mapcar (lambda (line) (string:join line "")) lines) (format nil "~%")))))

;; kinda nasty "hack".
;;
;; the first `main` function will set up a handler-case
;; in case for a C-c interrupt, then calls `main` again
;; but indicates that it's not the 'first' / parent main
;; and it will run the app normally.
;;
;; it is possible to do it in one swoop, but the code will
;; look more confusing than this.
;;
;; it's not runtime level so if the user's fast enough
;; sbcl runtime will still issue the sbcl's error msg
(defun main (&optional (parent t))
  (when parent
    (handler-case (main nil)
      (sb-sys:interactive-interrupt ()
        (progn (sb-ext:exit :code 1))))
    (return-from main))

  (let* ((args (align/args:args))
         (seperator (cdr (assoc :sep args)))
         (margin (cdr (assoc :margin args))))
    (format t "~a" (align (io:slurp) seperator :margin margin))))
