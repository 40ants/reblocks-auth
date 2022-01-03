(defpackage #:reblocks-auth-test/core
  (:use #:cl
        #:reblocks-auth/core
        #:rove
        #:hamcrest/rove))
(in-package reblocks-auth-test/core)


(deftest test-some-staff
    (testing "Replace this test with real staff."
      (assert-that (foo 1 2)
                   (contains 1 2))))
