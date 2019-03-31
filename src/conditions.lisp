(defpackage #:weblocks-auth/conditions
  (:use #:cl)
  (:export
   #:unable-to-authenticate
   #:get-reason
   #:get-message))
(in-package weblocks-auth/conditions)


(define-condition unable-to-authenticate ()
  ((message :initarg :message
            :reader get-message)
   (reason :initarg :reason
           :initform nil
           :reader get-reason))
  (:report (lambda (condition stream)
             (format stream
                     "~A~%Reason: ~A"
                     (get-message condition)
                     (get-reason condition)))))
