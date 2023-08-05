(uiop:define-package #:reblocks-auth/errors
  (:use #:cl)
  (:export #:nickname-is-not-available))
(in-package #:reblocks-auth/errors)


(define-condition nickname-is-not-available (error)
  ()
  (:documentation "Signalled when there is already a user with given nickname."))



