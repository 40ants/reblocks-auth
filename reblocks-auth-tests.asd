(defsystem "reblocks-auth-tests"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/reblocks-auth/"
  :class :package-inferred-system
  :description "Provides tests for reblocks-auth."
  :source-control (:git "https://github.com/40ants/reblocks-auth")
  :bug-tracker "https://github.com/40ants/reblocks-auth/issues"
  :pathname "t"
  :depends-on ("reblocks-auth-tests/core")
  :perform (test-op (op c)
                    (unless (symbol-call :rove :run c)
                      (error "Tests failed"))))
