(quicklisp:quickload '(#:closure-html))

(asdf:defsystem #:pjs-chtml-helpers
  :serial t
  :depends-on (#:pjs-utils)
  :components ((:file "package")
               (:file "pjs-chtml-helpers")))
