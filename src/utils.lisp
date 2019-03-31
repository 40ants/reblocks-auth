(defpackage #:weblocks-auth/utils
  (:use #:cl)
  (:import-from #:alexandria
                #:make-keyword)
  (:export
   #:to-plist
   #:keywordify))
(in-package weblocks-auth/utils)


(defun keywordify (string)
  (check-type string string)
  (make-keyword (string-upcase string)))


(defun to-plist (alist &key without)
  (loop for (key . value) in alist
        for new-key = (keywordify key)
        unless (member new-key without)
          appending (list new-key value)))
