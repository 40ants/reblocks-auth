(uiop:define-package #:reblocks-auth-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog))
(in-package #:reblocks-auth-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "URL"
                              "API"
                              "HTTP"))
  (0.11.1 2025-02-15
          "
Fixed
=====

- Email provider form rendering was fixed to work with Reblocks changes introduced in [PR57](https://github.com/40ants/reblocks/pull/57).
")
  (0.11.0 2023-12-18
          "
Added
=====

- REBLOCKS-AUTH/CORE:RENDER-LOGIN-PAGE generic-function was added allowing to make a custom.
  Widget class REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING:REQUEST-CODE-FORM, REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING:RENDER-SUBMIT-BUTTON generic-function, REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING:RENDER-EMAIL-INPUT generic-function, REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING:FORM-CSS-CLASSES generic-function and REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING:RENDER-SENT-MESSAGE generic-function were added to allow login page customizations.
- Added REBLOCKS-AUTH/CORE:*ALLOW-NEW-ACCOUNTS-CREATION* variable to control if new accounts can be registered.
- Added REBLOCKS-AUTH/MODELS:*USER-CLASS* variable. This allows to make a custom user model with additional fields.

Changed
=======

- Now when user authenticates using email, we fill email column.
- Function REBLOCKS-AUTH/PROVIDERS/EMAIL/MODELS:SEND-CODE now accepts SEND-CALLBACK argument. This argument can be used when you need to send login code with a custom email markup. For example, this way a special welcome email can be sent when a new user was added by a site admin.
- Function REBLOCKS-AUTH/PROVIDERS/EMAIL/RESEND:MAKE-CODE-SENDER now accepts additional argument BASE-URI.
")
  (0.10.0 2023-10-22
          "Experimental reCaptcha support was added into email provider.

           Set REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING:*RECAPTCHA-SITE-KEY*
           and REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING:*RECAPTCHA-SECRET-KEY*
           variables to try it.

           Note: this version requires a new Reblocks, where was added get-remote-ip function.")
  (0.9.0 2023-10-01
         "Email authentication provider now is able to use Resend API. Load `reblocks-auth/providers/email/resend` ASDF system to enable this feature.")
  (0.8.0 2023-08-04
         "New authentication provider was added. It will send an authentication URL to user's email.

          To make it work, you'll need to add this table to the database:

          ```
          CREATE TABLE registration_code (
              id BIGSERIAL NOT NULL PRIMARY KEY,
              email VARCHAR(255) NOT NULL,
              code VARCHAR(255) NOT NULL,
              valid_until TIMESTAMP NOT NULL,
              created_at TIMESTAMPTZ,
              updated_at TIMESTAMPTZ
          );
          ```

          After that, do this to enable the auth provider:

          ```
          (pushnew :email reblocks-auth:*enabled-services*)
          ```

          Also, you'll need to provide credentials for working with Mailgun service. At the moment
          sending email works only via this service, but other methods can be implemented.

          If you decide to go with default sending method, define email template like this:

          ```
          (define-code-sender send-code (\"Ultralisp.org <noreply@ultralisp.org>\" url)
            (:p (\"To log into [Ultralisp.org](~A), follow [this link](~A).\"
                 url
                 url))
            (:p \"Hurry up! This link will expire in one hour.\"))
          ```

          Here is how to provide credentials to make sending work:


          ```
          (setf mailgun:*domain* \"mg.ultralisp.org\")

          (setf mailgun:*api-key*
                (secret-values:conceal-value
                 \"********************************-*********-*********\"))
          ```

          To supply an alternative sending method, define a function of two arguments: email and url.
          Set REBLOCKS-AUTH/PROVIDERS/EMAIL/MODELS:*SEND-CODE-CALLBACK* variable to the value
          of this function.
")
  (0.7.0 2022-06-07
         "* Added documentation and an example application.")
  (0.6.0 2021-01-24
         "* Added support for `secret-values` in REBLOCKS-AUTH/GITHUB:*SECRET*.")
  (0.5.1 2019-06-24
         "* Supported recent change [of mito](https://github.com/fukamachi/mito/commit/be0ea57df921aa1beb2045b50a8c2e2e4f8b8955)
            caused an error when searching a social user.")
  (0.5.0 2019-06-22
         "* Added a REBLOCKS-AUTH/MODELS:CHANGE-EMAIL function.")
  (0.4.0 2019-06-20
         "* Added a new variable REBLOCKS-AUTH/CORE:*LOGIN-HOOKS*.
          * A variable REBLOCKS-AUTH/CORE:*ENABLED-SERVICES* was exported.
          * A function REBLOCKS-AUTH/CORE:RENDER-BUTTONS was exported.")
  (0.3.0 2019-04-18
         "* Now classes REBLOCKS-AUTH/MODELS:USER and REBLOCKS-AUTH/MODELS:SOCIAL-PROFILE are exported from `reblocks-auth/models` system.
          * New function were added: REBLOCKS-AUTH/MODELS:GET-USER-BY-EMAIL and REBLOCKS-AUTH/MODELS:GET-USER-BY-NICKNAME.")
  (0.2.0 2019-04-17
         "* Now only `user:email` scope is required for authentication
            via github.
          * And REBLOCKS-AUTH/GITHUB:RENDER-BUTTON, REBLOCKS-AUTH/GITHUB:GET-SCOPES
            functions was added to request more scopes if required.")
  (0.1.0 2019-03-31
         "* First version with GitHub authentication."))
