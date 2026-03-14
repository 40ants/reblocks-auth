(uiop:define-package #:reblocks-auth-example/app
  (:use #:cl)
  (:import-from #:reblocks-auth)
  (:import-from #:reblocks/app
                #:defapp)
  (:import-from #:reblocks/routes
                #:page)
  (:import-from #:reblocks-auth-example/pages/landing
                #:make-landing-page)
  (:import-from #:reblocks-auth-example/widgets/frame
                #:make-page-frame))
(in-package #:reblocks-auth-example/app)


(defapp app
  :prefix "/"
  :routes ((page ("/")
             (make-page-frame
              (make-landing-page)))
           (page ("/login")
             (make-page-frame
              (reblocks-auth:make-login-processor)))
           (page ("/logout")
             (make-page-frame
              (reblocks-auth:make-logout-processor)))))
