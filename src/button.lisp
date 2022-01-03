(defpackage #:reblocks-auth/button
  (:use #:cl)
  (:import-from #:reblocks/html
                #:with-html)
  (:export
   #:render))
(in-package reblocks-auth/button)


(defgeneric render (service &key retpath)
  (:documentation "Renders a button for given service.
                   Service should be a keyword like :github or :facebook.")
  (:method ((service t) &key retpath)
    (with-html
      (:a :href ""
          :class "button"
          ("Login via Unsupported Service ~A"
           service)))))
