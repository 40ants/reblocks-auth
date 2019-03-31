(defpackage #:weblocks-auth-test/core
  (:use #:cl
        #:weblocks-auth/core
        #:rove
        #:hamcrest/rove))
(in-package weblocks-auth-test/core)


(deftest test-some-staff
    (testing "Replace this test with real staff."
      (assert-that (foo 1 2)
                   (contains 1 2))))
