(defpackage #:pjs-chtml-helpers
  (:use #:cl #:pjs-utils)
  (:export #:*document*
	   #:parse-html
	   #:dom-attrs
	   #:dom-attr-value
	   #:dom-children
	   #:dom-tag-kind
	   #:dom-is-node
	   #:dom-find-if
	   #:dom-find-all-if
	   #:dom-find-all-by-tag
	   #:dom-find-node-by-id
	   #:dom-node-of-tag
	   #:dom-node-of-tag-and-class
	   #:dom-node-with-attr
	   #:dom-node-with-attr-of-value
	   #:dom-text-node-p
	   #:dom-node-text))

(in-package #:pjs-chtml-helpers)
