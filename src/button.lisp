(defpackage #:weblocks-auth/button
  (:use #:cl)
  (:import-from #:weblocks/html
                #:with-html)
  (:export
   #:render))
(in-package weblocks-auth/button)


(defgeneric render (service)
  (:documentation "Renders a button for given service.
                   Service should be a keyword like :github or :facebook.")
  (:method ((service t))
    (with-html
      (:a :href ""
          :class "button"
          ("Login via Unsupported Service ~A"
           service)))))
