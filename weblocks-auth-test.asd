(defsystem weblocks-auth-test
           :author ""
           :license ""
           :class :package-inferred-system
           :pathname "t"
           :depends-on (:weblocks-auth
                        "weblocks-auth-test/core")
           :description "Test system for weblocks-auth"

           :perform (test-op :after (op c)
                             (symbol-call :rove :run c)
                             (clear-system c)))
