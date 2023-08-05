(uiop:define-package #:reblocks-auth-example/pages/landing
  (:use #:cl)
  (:import-from #:spinneret/cl-markdown)
  (:import-from #:reblocks/widget
                #:update
                #:render
                #:defwidget)
  (:import-from #:reblocks/dependencies
                #:get-dependencies)
  (:import-from #:reblocks/html
                #:with-html)
  (:import-from #:reblocks-ui
                #:ui-widget)
  (:import-from #:serapeum
                #:fmt)
  (:import-from #:reblocks-lass)
  (:import-from #:reblocks-ui/form
                #:with-html-form)
  (:import-from #:reblocks-auth/models
                #:profile-service-user-id
                #:profile-service
                #:get-nickname
                #:get-current-user))
(in-package #:reblocks-auth-example/pages/landing)


(defwidget landing-page (ui-widget)
  ((name :initform nil
         :accessor user-name)))


(defun make-landing-page ()
  (make-instance 'landing-page))


(defmethod render ((widget landing-page))
  (let* ((user (get-current-user)))
    (with-html
      (cond
        (user
         (let ((profiles (reblocks-auth/models:user-social-profiles user)))
           (:p (format nil "You are logged as: ~A"
                       (get-nickname user)))
           (when profiles
             (:p "This user has following social profiles:")
             (:ul (loop for profile in profiles
                        do (:li (format nil "~A: ~A"
                                        (profile-service profile)
                                        (profile-service-user-id profile))))))
           (:p (:a :href "/logout"
                   :class "button"
                   "Logout"))))
        (t
         (:p ("You can open [login](/login) page."))
         (:p "Or push login button here:")
         (:p (reblocks-auth:render-buttons)))))))


(defmethod get-dependencies ((widget landing-page))
  (list*
   (reblocks-lass:make-dependency
     `(.landing-page
       :padding 1rem
       ((:and p :last-child)
        :margin-bottom 0)

       (.auth-buttons
        :display flex
        :gap 1rem)))
   (call-next-method)))
