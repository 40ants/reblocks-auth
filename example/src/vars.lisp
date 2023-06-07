(uiop:define-package #:reblocks-auth-example/vars
  (:use #:cl)
  (:export #:yandex-metrika-code
           #:*dark-background*
           #:*light-background*
           #:*text-color*))
(in-package #:reblocks-auth-example/vars)


(defun yandex-metrika-code ()
  (uiop:getenv "YANDEX_METRIKA_CODE"))


(defparameter *dark-background* "rgb(51, 53, 65)")

(defparameter *light-background* "rgb(61, 63, 75)")

(defparameter *text-color* "rgb(235, 236, 241)")
