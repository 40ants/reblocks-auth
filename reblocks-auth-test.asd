(defsystem reblocks-auth-test
  :author ""
  :license ""
  :class :package-inferred-system
  :pathname "t"
  :depends-on (:reblocks-auth
               "reblocks-auth-test/core")
  :description "Test system for reblocks-auth"

  :perform (test-op :after (op c)
                    (symbol-call :rove :run c)
                    (clear-system c)))
