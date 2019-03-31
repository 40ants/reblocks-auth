(defpackage #:weblocks-auth/github
  (:use #:cl)
  (:import-from #:dexador)
  (:import-from #:jonathan
                #:to-json)
  (:import-from #:weblocks-auth/button)
  (:import-from #:weblocks-auth/auth)
  (:import-from #:weblocks/html
                #:with-html)
  (:import-from #:weblocks-auth/conditions
                #:unable-to-authenticate)
  (:import-from #:weblocks-auth/models
                #:find-social-user
                #:create-social-user)
  (:export
   #:*client-id*
   #:*secret*))
(in-package weblocks-auth/github)


(defvar *client-id* nil
  "OAuth client id")


(defvar *secret* nil
  "OAuth secret")


(defun make-authentication-url ()
  (format nil
          "https://github.com/login/oauth/authorize?client_id=~A&scope=write:repo_hook,read:org"
          *client-id*))


(defun get-oauth-token-by (code)
  (let* ((response (dex:post "https://github.com/login/oauth/access_token"
                             :content (to-json (list :|code| code
                                                     :|client_id| *client-id*
                                                     :|client_secret| *secret*))
                             :headers '(("Accept" . "application/json")
                                        ("Content-Type" . "application/json"))))
         (data (jonathan:parse response))
         (error (getf data :|error|)))
    (when error
      (log:error "Unable to authenticate" error)
      (error 'unable-to-authenticate
             :message (format nil "Unable to authenticate! ~A Please, try again."
                              (getf data :|error_description|))
             :reason error))
    (values (getf data :|access_token|)
            data)))


(defmethod weblocks-auth/button:render ((service (eql :github)))
  (with-html
    (if *client-id*
        (:a :href (make-authentication-url)
            :class "button"
            "GitHub")
        (:a :href ""
            :class "button"
            "Please, set weblocks-auth/github:*client-id*"))))



(defmethod weblocks-auth/auth:authenticate ((service (eql :github)) &rest params &key code)
  (declare (ignorable params))
  
  (unless code
    (error "Unable to authenticate user without the code."))
  
  (let* ((token (get-oauth-token-by code))
         (user-data (dex:get "https://api.github.com/user"
                             :headers (list (cons "Authorization"
                                                  (format nil "token ~A" token)))))
         (parsed (jonathan:parse user-data))
         (login (getf parsed :|login|))
         (user (find-social-user :github login)))
    
    (log:info "Token" token login)
    (cond
      (user (values user
                    nil))
      (t (values (create-social-user :github
                                     login
                                     :email (getf parsed :|email|))
                 t)))))
