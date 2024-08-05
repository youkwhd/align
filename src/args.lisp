(defpackage #:align/args 
  (:use #:cl)
  (:export #:args))

(in-package #:align/args)

(defun raw ()
  ;; see: https://cl-cookbook.sourceforge.net/os.html
  (or
    #+CLISP *args*
    #+SBCL sb-ext:*posix-argv*
    #+LISPWORKS system:*line-arguments-list*
    #+CMU extensions:*command-line-words*
    nil))

(defun help (program-name)
  (format t "Usage: ~a [-sep <seperator>]~%" program-name)
  (format t "Syntax aware text alignment utility.~%")
  (format t "~%")
  (format t "Options:~%")
  (format t "  -help            prints this message and exits.~%")
  (format t "  -sep <seperator> specify the seperator.~%"))

(defun help-and-exit (program-name &optional (exit-code 0))
  (help program-name)
  ;; TODO: what are the other exit functions?
  (sb-ext:exit :code exit-code))

(defun args ()
  (let* ((args (raw))
         (program-name (first args)))
    (labels ((next (args)
              (let ((arg (first args)))
                (cond ((or (string= arg "-h")
                           (string= arg "--help")
                           (string= arg "-help"))
                       (help-and-exit program-name 0))
                      ((string= arg "-sep")
                       (let ((val (second args)))
                         (if (equal val nil)
                           (help-and-exit program-name 1)
                           (cons (cons :sep val)
                             (next (cddr args))))))
                      ((equal arg nil) '())
                      (t (next (rest args)))))))
      (next (rest args)))))
