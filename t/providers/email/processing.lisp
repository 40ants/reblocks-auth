(uiop:define-package #:reblocks-auth-tests/providers/email/processing
  (:use #:cl)
  (:import-from #:rove
                #:signals
                #:ng
                #:deftest
                #:ok
                #:testing)
  (:import-from #:reblocks-auth/providers/email/processing
                #:verify-smartcaptcha
                #:*smartcaptcha-server-key*
                #:*smartcaptcha-client-key*)
  (:import-from #:flexi-streams))
(in-package #:reblocks-auth-tests/providers/email/processing)


(deftest verify-smartcaptcha-success ()
  "Tests successful SmartCaptcha verification"
  (let ((*smartcaptcha-client-key* "test-client-key")
        (*smartcaptcha-server-key* "test-server-key"))
    (with-output-to-string (s)
      (let* ((response "{\"status\":\"ok\"}")
             (parsed (yason:parse response)))
        (ok (equalp (gethash "status" parsed) "ok"))))))

(deftest verify-smartcaptcha-failure
  "Tests failed SmartCaptcha verification"
  (let ((*smartcaptcha-client-key* "test-client-key")
        (*smartcaptcha-server-key* "test-server-key"))
    (let* ((response "{\"status\":\"error\"}")
           (parsed (yason:parse response)))
      (ng (equal (gethash "status" parsed) "ok")))))

(deftest verify-smartcaptcha-no-server-key
  "Tests that verify-smartcaptcha signals error when server key is not set"
  (let ((*smartcaptcha-server-key* nil))
    (signals (verify-smartcaptcha "test-token"))))
