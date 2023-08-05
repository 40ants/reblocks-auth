(uiop:define-package #:reblocks-auth/providers/email/processing
  (:use #:cl)
  (:import-from #:reblocks-auth/providers/email/models
                #:registration-email
                #:check-registration-code)
  (:import-from #:reblocks/html
                #:with-html)
  (:import-from #:reblocks/widget
                #:defwidget)
  (:import-from #:reblocks-auth/button)
  (:import-from #:reblocks-ui/form
                #:with-html-form
                #:render-form-and-button)
  (:import-from #:reblocks-ui/popup
                #:hide-popup
                #:show-popup)
  (:import-from #:reblocks-lass)
  (:import-from #:reblocks/dependencies))
(in-package #:reblocks-auth/providers/email/processing)


(defwidget email-query-widget (reblocks-ui/popup:popup-widget)
  ((retpath :initarg :retpath
            :reader retpath)
   (sent :initform nil
         :accessor sent)))


(defmethod reblocks-ui/popup:render-popup-content ((widget email-query-widget))
  (flet ((send-code (&key email &allow-other-keys)
           (cond
             ((string= email "")

              (reblocks-ui/form:field-error "email"
                                            "Please, give a correct email address."))
             (t
              (setf (sent widget)
                    t)
              (reblocks-auth/providers/email/models::send-code email :retpath (retpath widget))
              (reblocks/widget:update widget))))
         (close-popup (&rest rest)
           (declare (ignore rest))
           (setf (sent widget)
                 nil)
           (hide-popup widget)))
    (cond
      ((sent widget)
       (with-html
         (:p "A login link was sent to your email."))
       (render-form-and-button :close #'close-popup))
      (t
       (with-html-form (:post #'send-code)
         (:input :name "email"
                 :type "email"
                 :placeholder "Email")
         (reblocks-ui/form:error-placeholder "email")
         (:input :type "submit"
                 :class "button small"
                 :value "Send Code"))))))


(defmethod reblocks-auth/button:render ((service (eql :email))
                                        &key retpath)
  (let ((popup (make-instance 'email-query-widget
                              :retpath retpath)))
    (with-html
      (reblocks/widget:render popup)

      (render-form-and-button
       :email (lambda (&rest args)
                (declare (ignore args))
                (show-popup popup))
       :button-class "button small"))))



(defmethod reblocks-auth/auth:authenticate ((service (eql :email)) &rest params &key code)
  (declare (ignorable params))
  
  (unless code
    (error "Unable to authenticate user without the code."))
  
  (let* ((registration-code (check-registration-code code)))
    (let* ((email (registration-email registration-code))
           (user (reblocks-auth/models:find-social-user :email email)))
      
      (cond
        (user (values user
                      nil))
        (t (values (reblocks-auth/models:create-social-user :email
                                                            email
                                                            :email email)
                   t))))))


(defmethod reblocks/dependencies:get-dependencies ((widget email-query-widget))
  (list*
   (reblocks-lass:make-dependency
     '(.email-query-widget
       (.popup-content
        :color black)))
   (call-next-method)))
