(defpackage #:reblocks-auth/github
  (:use #:cl)
  (:import-from #:dexador)
  (:import-from #:log4cl)
  (:import-from #:jonathan
                #:to-json)
  (:import-from #:reblocks-auth/button)
  (:import-from #:reblocks-auth/auth)
  (:import-from #:reblocks/html
                #:with-html)
  (:import-from #:reblocks-auth/conditions
                #:unable-to-authenticate)
  (:import-from #:reblocks-auth/models
                #:find-social-user
                #:create-social-user)
  (:import-from #:reblocks/response
                #:add-retpath-to)
  (:import-from #:cl-strings
                #:split)
  (:import-from #:quri
                #:url-encode-params)
  (:import-from #:reblocks/request
                #:get-uri)
  (:import-from #:secret-values
                #:ensure-value-revealed)
  (:export
   #:*client-id*
   #:*secret*
   #:get-token
   #:get-scopes
   #:*default-scopes*
   #:render-button))
(in-package reblocks-auth/github)


(defvar *client-id* nil
  "OAuth client id")


(defvar *secret* nil
  "OAuth secret. It might be a string or secret-values:secret-value.")


(defvar *default-scopes* (list "user:email"))


(defun make-default-redirect-uri ()
  (reblocks/response:make-uri "/login?service=github"))


(defun make-authentication-url (&key (scopes *default-scopes*)
                                     (redirect-uri (make-default-redirect-uri)))
  (let ((scopes (cl-strings:join scopes :separator " ")))
    (format nil
            "https://github.com/login/oauth/authorize?~A"
            (url-encode-params (list (cons "client_id" *client-id*)
                                     (cons "scope" scopes)
                                     (cons "redirect_uri" redirect-uri))))))


(defun get-oauth-token-by (code)
  (let* ((response (dex:post "https://github.com/login/oauth/access_token"
                             :content (to-json (list :|code| code
                                                     :|client_id| *client-id*
                                                     :|client_secret| (ensure-value-revealed
                                                                       *secret*)))
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


(defun render-button (&key (class "button small")
                           (scopes *default-scopes*)
                           (text "Grant permissions")
                           (retpath (get-uri)))
  "Renders a button to request more scopes."
  (with-html
    (let* ((default-redirect (make-default-redirect-uri))
           (redirect-uri (add-retpath-to default-redirect
                                         :retpath retpath))
           (authentication-uri (make-authentication-url :scopes scopes
                                                        :redirect-uri redirect-uri)))
      (if *client-id*
          (:a :href authentication-uri
              :class class
              text)
          (:a :href ""
              :class class
              "Please, set reblocks-auth/github:*client-id*")))))


(defmethod reblocks-auth/button:render ((service (eql :github))
                                        &key retpath)
  (render-button :text "GitHub"
                 :retpath retpath))


(defmethod reblocks-auth/auth:authenticate ((service (eql :github)) &rest params &key code)
  (declare (ignorable params))
  
  (unless code
    (error "Unable to authenticate user without the code."))
  
  (let* ((token (get-oauth-token-by code)))
    (multiple-value-bind (response code headers)
        (dex:get "https://api.github.com/user"
                 :headers (list (cons "Authorization"
                                      (format nil "token ~A" token))))
      (declare (ignorable code))
      
      (let* ((parsed (jonathan:parse response))
             (login (getf parsed :|login|))
             (user (find-social-user :github login))
             (scopes (gethash "x-oauth-scopes" headers)))
        
        (setf (reblocks/session:get-value
               :github-token)
              token)

        (when scopes
          (setf (reblocks/session:get-value
                 :github-scopes)
                (split scopes ", ")))
    
        (cond
          (user (values user
                        nil))
          (t (values (create-social-user :github
                                         login
                                         :email (getf parsed :|email|))
                     t)))))))


(defun get-token ()
  "Returns current user's GitHub token."
  (reblocks/session:get-value :github-token))


(defun get-scopes ()
  "Returns current user's scopes."
  (reblocks/session:get-value :github-scopes))
