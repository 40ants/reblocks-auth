(uiop:define-package #:reblocks-auth/providers/email/mailgun
  (:use #:cl)
  (:import-from #:mailgun)
  (:import-from #:reblocks/response
                #:make-uri)
  (:import-from #:alexandria
                #:with-gensyms)
  (:import-from #:reblocks-auth/providers/email/models
                #:registration-code
                #:registration-email)
  (:export
   #:define-code-sender))
(in-package #:reblocks-auth/providers/email/mailgun)


(defun make-code-sender (thunk)
  (flet ((mailgun-code-sender (registration-code &key retpath)
           (let* ((email (registration-email registration-code))
                  (params (append
                           (list (cons "code" (registration-code registration-code))
                                 (cons "service" "email"))
                           (when retpath
                             (list (cons "retpath" retpath)))))
                  (url (make-uri
                        (format nil
                                "/login?~A"
                                (quri:url-encode-params params)))))

             (cond
               ((and mailgun:*domain*
                     mailgun:*api-key*)
                
                (funcall thunk email url))

               (t (log:warn "You didn't set MAILGUN_DOMAIN and MAILGUN_API_KEY env variables. So I am unable to send auth code."
                            url)
                  (reblocks/response:redirect url))))))
    #'mailgun-code-sender))


(defmacro define-code-sender (name (from-email url-var &key (subject "Authentication code"))
                              &body html-template-body)
  (with-gensyms (email-var)
    `(flet ((,name (,email-var ,url-var)
              (mailgun:send (,from-email
                             ,email-var
                             ,subject)
                ,@html-template-body)))
       (setf reblocks-auth/providers/email/models::*send-code-callback*
             (make-code-sender #',name)))))

