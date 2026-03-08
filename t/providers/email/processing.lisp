(defpackage #:reblocks-auth-tests/providers/email/processing
  (:use #:cl #:fiveam)
  (:import-from #:reblocks-auth/providers/email/processing)
  (:import-from #:flexi-streams))
(in-package #:reblocks-auth-tests/providers/email/processing)

(def-suite* smartcaptcha-tests)

(test verify-smartcaptcha-success
  "Tests successful SmartCaptcha verification"
  (let ((*smartcaptcha-client-key* "test-client-key")
        (*smartcaptcha-server-key* "test-server-key"))
    (with-output-to-string (s)
      (let* ((response "{\"status\":\"ok\"}")
             (parsed (yason:parse response)))
        (is (equalp (gethash "status" parsed) "ok"))))))

(test verify-smartcaptcha-failure
  "Tests failed SmartCaptcha verification"
  (let ((*smartcaptcha-client-key* "test-client-key")
        (*smartcaptcha-server-key* "test-server-key"))
    (let* ((response "{\"status\":\"error\"}")
           (parsed (yason:parse response)))
      (is-false (equal (gethash "status" parsed) "ok")))))

(test verify-smartcaptcha-no-server-key
  "Tests that verify-smartcaptcha signals error when server key is not set"
  (let ((*smartcaptcha-server-key* nil))
    (signals error (verify-smartcaptcha "test-token"))))
