(defpackage #:align/args 
  (:use #:cl)
  (:export #:args))

(in-package #:align/args)

(defun help (program-name)
  (format t "Usage: ~a [-sep <seperator>, -margin <n>]
Text alignment utility.

Options:
  -help            prints this message and exits.
  -sep <seperator> specify the seperator.
  -margin <n>      specifies how many spaces will
                   be appended in-between the seperator.~%"
  program-name))

(defun help-and-exit (program-name &optional (exit-code 0))
  (help program-name)
  (sb-ext:exit :code exit-code))

(defun args ()
  (let* ((args sb-ext:*posix-argv*)
         (program-name (first args)))
    (labels ((recurse (args)
              (let ((arg (first args)))
                (cond ((or (string= arg "-h")
                           (string= arg "--help")
                           (string= arg "-help"))
                       (help-and-exit program-name 0))
                      ((string= arg "-sep")
                       (let ((val (second args)))
                         (if (not val)
                           (help-and-exit program-name 1)
                           (cons
                             (cons :sep val)
                             (recurse (cddr args))))))
                      ((string= arg "-margin")
                       (let ((val (second args)))
                         (if (not val)
                           (help-and-exit program-name 1)
                           (cons
                             (cons :margin (parse-integer val))
                             (recurse (cddr args))))))
                      ((not arg) '())
                      (t (recurse (rest args)))))))
      (union
         (list (cons :sep "=") (cons :margin 1))
         (recurse (rest args))
         :key #'first))))
