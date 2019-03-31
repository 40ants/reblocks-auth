(defpackage #:weblocks-auth/auth
  (:use #:cl)
  (:export
   #:authenticate))
(in-package weblocks-auth/auth)


(defgeneric authenticate (service &rest params)
  (:documentation "Called when user had authenticated in the service and returned
                   to our site.

                   All GET arguments are collected into a plist and passed as params.

                   Should return two values a user and a flag denotifing if user was just created.")
  (:method ((service t) &rest params)
    (declare (ignorable params))
    (error "Please, define weblocks-auth/auth:authenticate method for ~A service."
           service)))
