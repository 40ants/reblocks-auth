(uiop:define-package #:reblocks-auth-docs/index
  (:use #:cl)
  (:import-from #:pythonic-string-reader
                #:pythonic-string-syntax)
  #+quicklisp
  (:import-from #:quicklisp)
  (:import-from #:named-readtables
                #:in-readtable)
  (:import-from #:40ants-doc
                #:defsection
                #:defsection-copy)
  (:import-from #:reblocks-auth-docs/changelog
                #:@changelog)
  (:import-from #:docs-config
                #:docs-config)
  (:import-from #:40ants-doc/autodoc
                #:defautodoc)
  (:import-from #:reblocks-auth/models)
  (:export #:@index
           #:@readme
           #:@changelog))
(in-package #:reblocks-auth-docs/index)

(in-readtable pythonic-string-syntax)


(defmethod docs-config ((system (eql (asdf:find-system "reblocks-auth-docs"))))
  ;; 40ANTS-DOC-THEME-40ANTS system will bring
  ;; as dependency a full 40ANTS-DOC but we don't want
  ;; unnecessary dependencies here:
  #+quicklisp
  (ql:quickload "40ants-doc-theme-40ants")
  #-quicklisp
  (asdf:load-system "40ants-doc-theme-40ants")
  
  (list :theme
        (find-symbol "40ANTS-THEME"
                     (find-package "40ANTS-DOC-THEME-40ANTS"))))


(defsection @index (:title "reblocks-auth - A system to add an authentication to the Reblocks based web-site."
                    :ignore-words ("JSON"
                                   "HTTP"
                                   "TODO"
                                   "URI"
                                   "Unlicense"
                                   "OA"
                                   "REPL"
                                   "GIT"
                                   "ASDF:PACKAGE-INFERRED-SYSTEM"
                                   "ASDF"
                                   "40A")
                    :external-docs ("https://40ants.com/reblocks-navigation-widget/"))
  (reblocks-auth system)
  "
[![](https://github-actions.40ants.com/40ants/reblocks-auth/matrix.svg?only=ci.run-tests)](https://github.com/40ants/reblocks-auth/actions)

![Quicklisp](http://quickdocs.org/badge/reblocks-auth.svg)

Reblocks-auth is a system for adding authentication for your Reblocks application. It allows users to login using multiple ways. Right now GitHub is only supported but the list will be extended.

This system uses [Mito](https://github.com/fukamachi/mito) as a storage to store data about users and their data from service providers. Each user has a unique nickname and an optional email. Also, one or more identity providers can be bound to each user account.
"
  (@installation section)
  (@example section)
  (@usage section)
  (@api section)
  (@roadmap section))


(defsection-copy @readme @index)


(defsection @installation (:title "Installation")
  """
You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :reblocks-auth)
```
""")


(defsection @usage (:title "Usage")
  "
This system provides a way for user authentifications. Each user is represented in the database
using REBLOCKS-AUTH/MODELS:USER model user can be bound to one or more \"social profiles\" -
REBLOCKS-AUTH/MODELS:SOCIAL-PROFILE. For example, if user logged in via GitHub, then
database will store one \"user\" record and one \"social-profile\" record. Each social profile
can hold additional information in it's metadata slot.

To use this system, you have to define two routes which will be responsible for login and logout.
On each route you have to render either REBLOCKS-AUTH:LOGIN-PROCESSOR or REBLOCKS-AUTH:LOGOUT-PROCESSOR widgets.

Usually you can define your routes like this (REBLOCKS-NAVIGATION-WIDGET:DEFROUTES is used here):

```
(defroutes routes
    (\"/\" (make-page-frame
          (make-landing-page)))
  (\"/login\"
   (make-page-frame
    (reblocks-auth:make-login-processor)))
  (\"/logout\"
   (make-page-frame
    (reblocks-auth:make-logout-processor))))
```

This code will render a set up buttons to login through enabled service providers.
Enabled service providers are listed in REBLOCKS-AUTH:*ENABLED-SERVICES* variable.

Login processor does two things:

- renders buttons for enabled service providers calling REBLOCKS-AUTH/BUTTON:RENDER generic-function.
- service processor is executed when user clicks a \"login\" button. For example GitHub processor
  redirects to https://github.com/login/oauth/authorize
- when user comes back to /login page, service processor gets or creates entries in the database
  and stores current user in the session.
- after this, any code can retrieve current user by a call to REBLOCKS-AUTH/MODELS:GET-CURRENT-USER.

Logout processor renders a \"logout\" button and when user clicks on it, removes user from the current session.
")


(defsection @example (:title "Example App")
  "
I've made an example application to demonstrate how does REBLOCKS-AUTH system work.
To start this example application, run this code in the REPL:

```
(asdf:load-system :reblocks-auth-example)

(reblocks-auth-example/server:start :port 8080)
```

When you'll open the http://localhost:8080/ you will see this simple website:

![](https://storage.yandexcloud.net/40ants-blog-images/reblocks-auth-example.gif)

")

(defsection @roadmap (:title "Roadmap")
  "
* Add support for authentication by a link sent to the email.
* Add ability to bind multiple service providers to a single user.")


;; A hack around the Mito's autogenerated reader method
(eval-when (:compile-toplevel :load-toplevel :execute)
  (pushnew 'reblocks-auth/models:profile-user
           40ants-doc:*symbols-with-ignored-missing-locations*))


(defautodoc @api (:system "reblocks-auth"))
