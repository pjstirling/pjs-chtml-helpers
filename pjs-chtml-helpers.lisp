(in-package #:pjs-chtml-helpers)

(defvar *document* nil)

(defun parse-html (text)
  (chtml:parse text (chtml:make-lhtml-builder)))

(defun dom-attrs (node)
  (second node))

(defun dom-attr-value (node key)
  (dolist (attr (dom-attrs node))
    (when (eq (first attr)
	      key)
      (return (second attr)))))

(defun dom-children (node &optional node-p)
  (if node-p
      (remove-if #'stringp (nthcdr 2 node))
      ;; else
      (nthcdr 2 node)))

(defun dom-tag-kind (node)
  (first node))

(defun dom-is-node (node)
  (listp node))

(defun dom-find-if (pred &optional (root *document*) (missing-error nil))
  (labels ((rec (root)
	     (dolist (node (dom-children root))
	       (when (dom-is-node node)
		 (when (funcall pred node)
		   (return-from dom-find-if node))
		 (rec node)))))
    (or (rec root)
	(and missing-error
	     (error "node not found! ~w~% ~w" pred root)))))

(defun dom-find-all-if (pred &optional (root *document*))
  (with-collector (collect)
    (labels ((rec (root)
	       (dolist (node (dom-children root))
		 (when (dom-is-node node)
		   (if (funcall pred node)
		       (collect node)
		       ;; else
		       (rec node))))))
      (rec root))))

(defun dom-find-all-by-tag (tag &optional (root *document*))
  (dom-find-all-if (dom-node-of-tag tag)
		   root))

(defun dom-find-node-by-id (id &optional (root *document*) missing-error)
  (dom-find-if (dom-node-with-attr-of-value :id id)
	       root
	       missing-error))

(defun dom-node-of-tag (tag)
  (lambda (node)
    (eq (dom-tag-kind node)
	tag)))

(defun dom-node-of-tag-and-class (tag class)
  (lambda (node)
    (and (eq (dom-tag-kind node)
	     tag)
	 (string= (dom-attr-value node :class)
		  class))))

(defun dom-node-with-attr (attr)
  (lambda (node)
    (dom-attr-value node attr)))

(defun dom-node-with-attr-of-value (attr value)
  (lambda (node)
    (awhen (dom-attr-value node attr)
      (string= it value))))

(defun dom-text-node-p (node)
  (let* ((children (dom-children node))
	 (child (first children)))
    (and (null (rest children))
	 (stringp child)
	 child)))

(defun dom-node-text (node)
  (aif (dom-text-node-p node)
       it
       ;; else
       (error "node not only text ~a" node)))
