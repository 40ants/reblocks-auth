(uiop:define-package #:reblocks-auth/core
  (:nicknames #:reblocks-auth)
  (:use #:cl)
  (:import-from #:log)
  (:import-from #:reblocks-lass)
  (:import-from #:reblocks-auth/button)
  (:import-from #:reblocks-auth/auth)
  (:import-from #:reblocks/response
                #:redirect)
  (:import-from #:reblocks/request
                #:get-parameters
                #:get-parameter)
  (:import-from #:reblocks/widget
                #:widget
                #:render
                #:defwidget)
  (:import-from #:reblocks-auth/utils
                #:keywordify
                #:to-plist)
  (:import-from #:reblocks-auth/conditions
                #:get-message
                #:unable-to-authenticate)
  (:import-from #:reblocks/html
                #:with-html)
  (:import-from #:reblocks-auth/models
                #:get-current-user)
  (:import-from #:reblocks/dependencies
                #:get-dependencies)
  (:import-from #:reblocks/app)
  (:import-from #:reblocks/session)
  (:export #:*login-hooks*
           #:*enabled-services*
           #:make-login-processor
           #:make-logout-processor
           #:render-buttons
           #:login-processor
           #:logout-processor
           #:render-login-page
           #:*allow-new-accounts-creation*))
(in-package reblocks-auth/core)


(defvar *enabled-services* (list :github)
  "Set this variable to limit a services available to login through.")


(defvar *login-hooks* nil
  "Append a funcallable handlers which accept single argument - logged user.")


(defvar *allow-new-accounts-creation* t
  "When True, a new account will be created. Otherwise only already existing users can log in.")


(defwidget login-processor ()
  ()
  (:documentation "This widget should be rendered to process user's login."))


(defwidget logout-processor ()
  ()
  (:documentation "This widget should be rendered to process user's logout."))


(defun make-login-processor ()
  (make-instance 'login-processor))


(defun make-logout-processor ()
  (make-instance 'logout-processor))


(defgeneric reach-goal (widget goal-name &key survive-redirect-p)
  ;; TODO: move this to a separate system reblocks-metrics
  (:method ((widget t) goal-name &key survive-redirect-p)
    (declare (ignorable widget survive-redirect-p))
    (log:debug "Goal" goal-name "was reached")))


(defun render-buttons (&key retpath)
  "Renders a row of buttons for enabled service providers.

   Optionally you can specify RETPATH argument with an URI to return user
   after login."
  (with-html ()
    (:div :class "auth-buttons"
          (loop for service in *enabled-services*
                do (reblocks-auth/button:render service
                                                :retpath retpath)))))


(defmethod render ((widget login-processor))
  (let ((service (get-parameter "service"))
        (retpath (or (get-parameter "retpath")
                     "/")))
    
    ;; (cond
    ;;   (retpath
    ;;    (setf (get-retpath widget)
    ;;          retpath))
    ;;   (t (setf retpath
    ;;            (get-retpath widget))))

    (cond (service
           (let ((params (to-plist (get-parameters)
                                   :without '(:service))))
             (handler-case
                 (multiple-value-bind (user existing-p)
                     (apply 'reblocks-auth/auth:authenticate
                            (keywordify service)
                            params)
                   (log:debug "User logged in" user)

                   ;; Если логин удался, то надо вернуть пользователя на главную страницу
                   (unless existing-p
                     (reach-goal widget "REGISTERED" :survive-redirect-p t))

                   ;; Ну и в любом случае, зафиксируем факт логина
                   (reach-goal widget "LOGGED-IN" :survive-redirect-p t)

                   (setf (get-current-user)
                         user)

                   (loop for hook in *login-hooks*
                         do (funcall hook user))

                   (log:debug "Redirecting to" retpath)
                   (redirect retpath))
               (unable-to-authenticate (condition)
                 (with-html ()
                   (:p :class "label alert"
                       (get-message condition))
                   (render-login-page (reblocks/app:get-current)
                                      :retpath retpath))))))

          ;; Here we just show the raw of available buttons
          ;; to login via different identity providers
          (t
           (render-login-page (reblocks/app:get-current)
                              :retpath retpath)))))


(defgeneric render-login-page (app &key retpath)
  (:documentation "By default, renders a list of buttons for each allowed authentication method.")
  (:method ((app t) &key retpath)

    (with-html ()
      (:h1 "Login with"))
    
    (render-buttons :retpath retpath)))


(defmethod render ((widget logout-processor))
  (let ((retpath (or (get-parameter "retpath")
                     "/")))
    (reblocks/session:reset)
    (redirect retpath)))


(defmethod get-dependencies ((widget login-processor))
  (list*
   (reblocks-lass:make-dependency
     `(.auth-buttons
       :display flex
       :gap 1rem))
   (call-next-method)))
