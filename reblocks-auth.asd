#-asdf3.1 (error "reblocks-auth requires ASDF 3.1 because for lower versions pathname does not work for package-inferred systems.")
(defsystem "reblocks-auth"
  :description "A system to add an authentication to the Reblocks based web-site."
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/reblocks-auth/"
  :source-control (:git "https://github.com/40ants/reblocks-auth")
  :bug-tracker "https://github.com/40ants/reblocks-auth/issues"
  :class :40ants-asdf-system
  :defsystem-depends-on ("40ants-asdf-system")
  :pathname "src"
  :depends-on ("reblocks-auth/core"
               "reblocks-auth/github"
               "reblocks-auth/models")
  :in-order-to ((test-op (test-op "reblocks-auth-tests"))))
