(uiop:define-package #:reblocks-auth/providers/email/resend
  (:use #:cl)
  (:import-from #:resend)
  (:import-from #:reblocks/response
                #:make-uri)
  (:import-from #:alexandria
                #:with-gensyms)
  (:import-from #:reblocks-auth/providers/email/models
                #:registration-code
                #:registration-email)
  (:export
   #:define-code-sender))
(in-package #:reblocks-auth/providers/email/resend)


(defun make-code-sender (thunk &key base-uri)
  (flet ((resend-code-sender (registration-code &key retpath)
           (let* ((email (registration-email registration-code))
                  (params (append
                           (list (cons "code" (registration-code registration-code))
                                 (cons "service" "email"))
                           (when retpath
                             (list (cons "retpath" retpath)))))
                  (url (make-uri
                        (format nil
                                "/login?~A"
                                (quri:url-encode-params params))
                        :base-uri base-uri)))

             (cond
               (resend:*api-key*
                
                (funcall thunk email url))

               (t (log:warn "You didn't set RESEND:*API-KEY* variable. So I am unable to send auth code."
                            url)
                  (reblocks/response:redirect url))))))
    #'resend-code-sender))


(defmacro define-code-sender (name (from-email url-var &key (subject "Authentication code"))
                              &body html-template-body)
  (with-gensyms (email-var)
    `(flet ((,name (,email-var ,url-var)
              (resend:send (,from-email
                            ,email-var
                            ,subject)
                ,@html-template-body)))
       (setf reblocks-auth/providers/email/models::*send-code-callback*
             (make-code-sender #',name)))))

