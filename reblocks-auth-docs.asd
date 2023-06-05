(defsystem "reblocks-auth-docs"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/reblocks-auth/"
  :class :package-inferred-system
  :description "Provides documentation for reblocks-auth."
  :source-control (:git "https://github.com/40ants/reblocks-auth")
  :bug-tracker "https://github.com/40ants/reblocks-auth/issues"
  :pathname "docs"
  :depends-on ("reblocks-auth"
               "reblocks-auth-docs/index"))
