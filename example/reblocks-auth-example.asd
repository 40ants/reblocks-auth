#-asdf3.1 (error "reblocks-auth-example requires ASDF 3.1 because for lower versions pathname does not work for package-inferred systems.")
(defsystem "reblocks-auth-example"
  :description "A demo site showing how to use reblocks-auth system."
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :class :40ants-asdf-system
  :defsystem-depends-on ("40ants-asdf-system")
  :pathname "src"
  :depends-on ("reblocks"
               "reblocks-auth-example/server")
  :in-order-to ((test-op (test-op "reblocks-auth-example-tests"))))
