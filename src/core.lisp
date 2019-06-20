(defpackage #:weblocks-auth/core
  (:nicknames #:weblocks-auth)
  (:use #:cl)
  (:import-from #:log4cl)
  (:import-from #:weblocks-auth/button)
  (:import-from #:weblocks-auth/auth)
  (:import-from #:weblocks/response
                #:redirect)
  (:import-from #:weblocks/request
                #:get-parameters
                #:get-parameter)
  (:import-from #:weblocks/widget
                #:widget
                #:render
                #:defwidget)
  (:import-from #:weblocks/page
                #:get-title)
  (:import-from #:weblocks-auth/utils
                #:keywordify
                #:to-plist)
  (:import-from #:weblocks-auth/conditions
                #:get-message
                #:unable-to-authenticate)
  (:import-from #:weblocks/html
                #:with-html)
  (:import-from #:weblocks-auth/models
                #:get-current-user)
  (:export #:*login-hooks*
           #:*enabled-services*
           #:make-login-processor
           #:make-logout-processor
           #:render-buttons))
(in-package weblocks-auth/core)


(defvar *enabled-services* (list :github)
  "Set this variable to limit a services available to login through.")


(defvar *login-hooks* nil
  "Append a funcallable handlers which accept single argument - logged user.")


(defwidget login-processor ()
  ()
  (:documentation "Этот виджет мы показываем, когда обрабатываем логин
                   пользователя посредством кода из письма или нужно отрисовать форму логина."))


(defwidget logout-processor ()
  ()
  (:documentation "Этот виджет мы показываем, когда нужно разлогинить пользователя."))


(defun make-login-processor ()
  (make-instance 'login-processor))


(defun make-logout-processor ()
  (make-instance 'logout-processor))


(defgeneric reach-goal (widget goal-name &key survive-redirect-p)
  ;; TODO: move this to a separate system weblocks-metrics
  (:method ((widget t) goal-name &key survive-redirect-p)
    (declare (ignorable widget survive-redirect-p))
    (log:debug "Goal" goal-name "was reached")))


(defun render-buttons (&key retpath)
  (loop for service in *enabled-services*
        do (weblocks-auth/button:render service
                                        :retpath retpath)))


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

    (weblocks/html:with-html
      (:h1 "Login with"))

    (cond (service
           (let ((params (to-plist (get-parameters)
                                   :without '(:service))))
             (handler-case
                 (multiple-value-bind (user existing-p)
                     (apply 'weblocks-auth/auth:authenticate
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
                 (with-html
                   (:p :class "label alert"
                       (get-message condition))
                   (:p (render-buttons :retpath retpath)))))))

          ;; Here we just show the raw of available buttons
          ;; to login via different identity providers
          (t
           (render-buttons :retpath retpath)))))


(defmethod render ((widget logout-processor))
  (let ((retpath (or (get-parameter "retpath")
                     "/")))
    (weblocks/session:reset)
    (redirect retpath)))
