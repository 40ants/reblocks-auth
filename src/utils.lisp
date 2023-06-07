(uiop:define-package #:reblocks-auth/utils
  (:use #:cl)
  (:import-from #:alexandria
                #:make-keyword))
(in-package reblocks-auth/utils)


(defun keywordify (string)
  (check-type string string)
  (make-keyword (string-upcase string)))


(defun to-plist (alist &key without)
  (loop for (key . value) in alist
        for new-key = (keywordify key)
        unless (member new-key without)
          appending (list new-key value)))
