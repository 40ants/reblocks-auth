(uiop:define-package #:reblocks-auth-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog)
  (:import-from #:reblocks-auth/github
                #:get-scopes
                #:render-button
                #:*secret*)
  (:import-from #:reblocks-auth/models
                #:get-user-by-nickname
                #:get-user-by-email
                #:social-profile
                #:user
                #:change-email)
  (:import-from #:reblocks-auth/core
                #:render-buttons
                #:*enabled-services*
                #:*login-hooks*))
(in-package #:reblocks-auth-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "HTTP"))
  (0.7.0 2022-06-07
         "* Added documentation and an example application.")
  (0.6.0 2021-01-24
         "* Added support for `secret-values` in *SECRET*.")
  (0.5.1 2019-06-24
         "* Supported recent change [of mito](https://github.com/fukamachi/mito/commit/be0ea57df921aa1beb2045b50a8c2e2e4f8b8955)
            caused an error when searching a social user.")
  (0.5.0 2019-06-22
         "* Added a CHANGE-EMAIL function.")
  (0.4.0 2019-06-20
         "* Added a new variable *LOGIN-HOOKS*.
          * A variable *ENABLED-SERVICES* was exported.
          * A function RENDER-BUTTONS was exported.")
  (0.3.0 2019-04-18
         "* Now classes USER and SOCIAL-PROFILE are exported from `reblocks-auth/models` system.
          * New function were added: GET-USER-BY-EMAIL and GET-USER-BY-NICKNAME.")
  (0.2.0 2019-04-17
         "* Now only `user:email` scope is required for authentication
            via github.
          * And RENDER-BUTTON GET-SCOPES
            functions was added to request more scopes if required.")
  (0.1.0 2019-03-31
         "* First version with GitHub authentication."))
