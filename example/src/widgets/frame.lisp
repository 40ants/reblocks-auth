(uiop:define-package #:reblocks-auth-example/widgets/frame
  (:use #:cl)
  (:import-from #:reblocks-lass)
  (:import-from #:serapeum
                #:fmt)
  (:import-from #:reblocks/widget
                #:render
                #:defwidget)
  (:import-from #:reblocks-ui
                #:ui-widget)
  (:import-from #:reblocks-ui/form
                #:render-form-and-button)
  (:import-from #:reblocks/dependencies
                #:get-dependencies)
  (:import-from #:reblocks-auth-example/vars
                #:yandex-metrika-code
                #:*text-color*
                #:*dark-background*)
  (:import-from #:reblocks/html
                #:with-html)
  (:export #:make-page-frame))
(in-package #:reblocks-auth-example/widgets/frame)


(defwidget frame-widget (ui-widget)
  ((content :initarg :content
            :reader content)
   (wide :initarg :wide
         :initform nil
         :reader widep)))


(defun make-page-frame (content &key wide)
  (make-instance 'frame-widget
                 :content content
                 :wide wide))


(defmethod render ((widget frame-widget))
  (with-html ()
    (:header
     (:div :class "navbar"
           (:div :class "main-logo"
                 (:div :class "title"
                       (:a :href "/"
                           "Reblocks Auth Example")))))

    (:div :class (if (widep widget)
                     "wide-page-content"
                     "page-content")
          (render (content widget)))

    (:div :class "footer"
          "I ❤️ Common Lisp!")))



(defmethod get-dependencies ((widget frame-widget))
  (list*
   (reblocks-lass:make-dependency
     `(body
       :background ,*dark-background*
       :color ,*text-color*
       
       (.frame-widget
        :display flex
        :flex-direction column
        :align-items center

        (.navbar
         :display flex
         :justify-content space-between
         :padding-left 1rem
         :padding-right 1rem
         (.main-logo
          :display flex
          :flex-direction column
          :flex-grow 10
          :text-align center
          (a :color ,*text-color*)

          (.title
           :font-size 3rem
           :font-weight bold))

         (.user-icon
          :width 32px
          :height 32px
          :margin-top 1rem)
         ((:or .user-icon
               .login-link)
          :margin-left 3em))
        
        (.page-content
         :width 80%
         :margin-left auto
         :margin-right auto)
        
        (.wide-page-content
         :width 100%)
        
        (header
         :width 100%
         (.main-menu :display flex
                     :align-items center
                     (a :margin-right 1rem))
         
         (input
          :margin 0))

        (.footer
         (.contacts
          :margin-bottom 7rem
          (img
           :height 1em)
          (a :color ,*text-color*))))))

   (reblocks-lass:make-dependency
     `(:media "(max-width: 600px)"
              (body
               (.frame-widget
                (.navbar
                 (.user-icon
                  :width 32px
                  :height 32px)
                 (.main-logo
                  (.motto :display none)))

                (.page-content
                 :width 100%
                 :margin 0
                 :padding-left 1rem
                 :padding-right 1rem)))))
   
   (call-next-method)))
