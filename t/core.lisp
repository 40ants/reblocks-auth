(uiop:define-package #:reblocks-auth-tests/core
  (:use #:cl)
  (:import-from #:rove
                #:deftest
                #:ok
                #:testing))
(in-package #:reblocks-auth-tests/core)


(deftest test-example ()
  (ok t "Replace this test with something useful."))
