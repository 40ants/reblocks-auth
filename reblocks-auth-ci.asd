(defsystem "reblocks-auth-ci"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/reblocks-auth/"
  :class :package-inferred-system
  :description "Provides CI settings for reblocks-auth."
  :source-control (:git "https://github.com/40ants/reblocks-auth")
  :bug-tracker "https://github.com/40ants/reblocks-auth/issues"
  :pathname "src"
  :depends-on ("40ants-ci"
               "reblocks-auth-ci/ci"))
