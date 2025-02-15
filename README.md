<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-40README-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# reblocks-auth - A system to add an authentication to the Reblocks based web-site.

<a id="reblocks-auth-asdf-system-details"></a>

## REBLOCKS-AUTH ASDF System Details

* Description: A system to add an authentication to the Reblocks based web-site.
* Licence: Unlicense
* Author: Alexander Artemenko <svetlyak.40wt@gmail.com>
* Homepage: [https://40ants.com/reblocks-auth/][e462]
* Bug tracker: [https://github.com/40ants/reblocks-auth/issues][4f85]
* Source control: [GIT][1668]
* Depends on: [alexandria][8236], [cl-strings][2ecb], [dexador][8347], [jonathan][6dd8], [local-time][46a1], [log4cl][7f8b], [mailgun][ef16], [mito][5b70], [quri][2103], [reblocks][184b], [reblocks-lass][28e0], [reblocks-ui][4376], [secret-values][cd18], [serapeum][c41d], [uuid][d6b3], [yason][aba2]

[![](https://github-actions.40ants.com/40ants/reblocks-auth/matrix.svg?only=ci.run-tests)][2ba2]

![](http://quickdocs.org/badge/reblocks-auth.svg)

Reblocks-auth is a system for adding authentication for your Reblocks application. It allows users to login using multiple ways. Right now GitHub is only supported but the list will be extended.

This system uses [Mito][c7c4] as a storage to store data about users and their data from service providers. Each user has a unique nickname and an optional email. Also, one or more identity providers can be bound to each user account.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40INSTALLATION-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Installation

You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :reblocks-auth)
```
<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40EXAMPLE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Example App

I've made an example application to demonstrate how does [`reblocks-auth`][ac3a] system work.
To start this example application, run this code in the `REPL`:

```
(asdf:load-system :reblocks-auth-example)

(reblocks-auth-example/server:start :port 8080)
```
When you'll open the http://localhost:8080/ you will see this simple website:

![](https://storage.yandexcloud.net/40ants-blog-images/reblocks-auth-example.gif)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40USAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Usage

This system provides a way for user authentifications. Each user is represented in the database
using [`reblocks-auth/models:user`][05f7] model user can be bound to one or more "social profiles" -
[`reblocks-auth/models:social-profile`][d9d6]. For example, if user logged in via GitHub, then
database will store one "user" record and one "social-profile" record. Each social profile
can hold additional information in it's metadata slot.

To use this system, you have to define two routes which will be responsible for login and logout.
On each route you have to render either [`reblocks-auth:login-processor`][0dc2] or [`reblocks-auth:logout-processor`][4d0d] widgets.

Usually you can define your routes like this ([`reblocks-navigation-widget:defroutes`][5f0d] is used here):

```
(defroutes routes
    ("/" (make-page-frame
          (make-landing-page)))
  ("/login"
   (make-page-frame
    (reblocks-auth:make-login-processor)))
  ("/logout"
   (make-page-frame
    (reblocks-auth:make-logout-processor))))
```
This code will render a set up buttons to login through enabled service providers.
Enabled service providers are listed in [`reblocks-auth:*enabled-services*`][ac4c] variable.

Login processor does two things:

* renders buttons for enabled service providers calling [`reblocks-auth/button:render`][5d34] generic-function.
* service processor is executed when user clicks a "login" button. For example GitHub processor
  redirects to https://github.com/login/oauth/authorize
* when user comes back to /login page, service processor gets or creates entries in the database
  and stores current user in the session.
* after this, any code can retrieve current user by a call to [`reblocks-auth/models:get-current-user`][8c78].

Logout processor renders a "logout" button and when user clicks on it, removes user from the current session.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FAUTH-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/AUTH

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FAUTH-22-29-20PACKAGE-29"></a>

#### [package](594a) `reblocks-auth/auth`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FAUTH-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FAUTH-3AAUTHENTICATE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](d58e) `reblocks-auth/auth:authenticate` service &rest params &key code

Called when user had authenticated in the service and returned
to our site.

All `GET` arguments are collected into a plist and passed as params.

Should return two values a user and a flag denotifing if user was just created.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FBUTTON-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/BUTTON

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FBUTTON-22-29-20PACKAGE-29"></a>

#### [package](87d4) `reblocks-auth/button`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FBUTTON-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FBUTTON-3ARENDER-20GENERIC-FUNCTION-29"></a>

##### [generic-function](16bd) `reblocks-auth/button:render` service &key retpath

Renders a button for given service.
Service should be a keyword like :github or :facebook.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CONDITIONS

<a id="x-28-23A-28-2824-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCONDITIONS-22-29-20PACKAGE-29"></a>

#### [package](543b) `reblocks-auth/conditions`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCONDITIONS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-24UNABLE-TO-AUTHENTICATE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### UNABLE-TO-AUTHENTICATE

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-20CONDITION-29"></a>

###### [condition](a588) `reblocks-auth/conditions:unable-to-authenticate` ()

**Readers**

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](a588) `reblocks-auth/conditions:get-message` (unable-to-authenticate) (:message)

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-REASON-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](a588) `reblocks-auth/conditions:get-reason` (unable-to-authenticate) (:reason = 'nil)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CORE

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCORE-22-29-20PACKAGE-29"></a>

#### [package](b751) `reblocks-auth/core`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-24LOGIN-PROCESSOR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LOGIN-PROCESSOR

<a id="x-28REBLOCKS-AUTH-2FCORE-3ALOGIN-PROCESSOR-20CLASS-29"></a>

###### [class](75b0) `reblocks-auth/core:login-processor` (widget)

This widget should be rendered to process user's login.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-24LOGOUT-PROCESSOR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LOGOUT-PROCESSOR

<a id="x-28REBLOCKS-AUTH-2FCORE-3ALOGOUT-PROCESSOR-20CLASS-29"></a>

###### [class](eb29) `reblocks-auth/core:logout-processor` (widget)

This widget should be rendered to process user's logout.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FCORE-3ARENDER-LOGIN-PAGE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](9ed3) `reblocks-auth/core:render-login-page` app &key retpath

By default, renders a list of buttons for each allowed authentication method.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGIN-PROCESSOR-20FUNCTION-29"></a>

##### [function](fd01) `reblocks-auth/core:make-login-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGOUT-PROCESSOR-20FUNCTION-29"></a>

##### [function](5a82) `reblocks-auth/core:make-logout-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3ARENDER-BUTTONS-20FUNCTION-29"></a>

##### [function](6477) `reblocks-auth/core:render-buttons` &key retpath

Renders a row of buttons for enabled service providers.

Optionally you can specify `RETPATH` argument with an `URI` to return user
after login.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2AALLOW-NEW-ACCOUNTS-CREATION-2A-20-28VARIABLE-29-29"></a>

##### [variable](df1b) `reblocks-auth/core:*allow-new-accounts-creation*` t

When True, a new account will be created. Otherwise only already existing users can log in.

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2AENABLED-SERVICES-2A-20-28VARIABLE-29-29"></a>

##### [variable](a864) `reblocks-auth/core:*enabled-services*` (:github)

Set this variable to limit a services available to login through.

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2ALOGIN-HOOKS-2A-20-28VARIABLE-29-29"></a>

##### [variable](70a7) `reblocks-auth/core:*login-hooks*` nil

Append a funcallable handlers which accept single argument - logged user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FERRORS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/ERRORS

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FERRORS-22-29-20PACKAGE-29"></a>

#### [package](56f8) `reblocks-auth/errors`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FERRORS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FERRORS-24NICKNAME-IS-NOT-AVAILABLE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### NICKNAME-IS-NOT-AVAILABLE

<a id="x-28REBLOCKS-AUTH-2FERRORS-3ANICKNAME-IS-NOT-AVAILABLE-20CONDITION-29"></a>

###### [condition](1626) `reblocks-auth/errors:nickname-is-not-available` (error)

Signalled when there is already a user with given nickname.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FGITHUB-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/GITHUB

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FGITHUB-22-29-20PACKAGE-29"></a>

#### [package](0dfc) `reblocks-auth/github`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-SCOPES-20FUNCTION-29"></a>

##### [function](3538) `reblocks-auth/github:get-scopes`

Returns current user's scopes.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-TOKEN-20FUNCTION-29"></a>

##### [function](240d) `reblocks-auth/github:get-token`

Returns current user's GitHub token.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3ARENDER-BUTTON-20FUNCTION-29"></a>

##### [function](94a4) `reblocks-auth/github:render-button` &KEY (CLASS "button small") (SCOPES \*DEFAULT-SCOPES\*) (TEXT "Grant permissions") (RETPATH (GET-URI))

Renders a button to request more scopes.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ACLIENT-ID-2A-20-28VARIABLE-29-29"></a>

##### [variable](94cf) `reblocks-auth/github:*client-id*` nil

`OA`uth client id

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ADEFAULT-SCOPES-2A-20-28VARIABLE-29-29"></a>

##### [variable](70d5) `reblocks-auth/github:*default-scopes*` ("user:email")

A listo of default scopes to request from GitHub.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ASECRET-2A-20-28VARIABLE-29-29"></a>

##### [variable](70ff) `reblocks-auth/github:*secret*` nil

`OA`uth secret. It might be a string or secret-values:secret-value.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/MODELS

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FMODELS-22-29-20PACKAGE-29"></a>

#### [package](a769) `reblocks-auth/models`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24SOCIAL-PROFILE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### SOCIAL-PROFILE

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-20CLASS-29"></a>

###### [class](ba9f) `reblocks-auth/models:social-profile` (serial-pk-mixin dao-class record-timestamps-mixin)

Represents a User's link to a social service.
User can be bound to multiple social services.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](f37a) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](001e) `reblocks-auth/models:profile-service` (social-profile) (:service)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-USER-ID-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](cee2) `reblocks-auth/models:profile-service-user-id` (social-profile) (:service-user-id)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-USER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader] `reblocks-auth/models:profile-user` (social-profile) (:user)

A [`user`][05f7] instance, bound to the [`social-profile`][d9d6].

**Accessors**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [accessor](f37a) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24USER-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### USER

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AUSER-20CLASS-29"></a>

###### [class](67cb) `reblocks-auth/models:user` (serial-pk-mixin dao-class record-timestamps-mixin)

This class stores basic information about user - it's nickname and email.
Additional information is stored inside [`social-profile`][d9d6] instances.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-EMAIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](e800) `reblocks-auth/models:get-email` (user) (:email = nil)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-NICKNAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](fdc5) `reblocks-auth/models:get-nickname` (user) (:nickname)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AANONYMOUS-P-20FUNCTION-29"></a>

##### [function](f947) `reblocks-auth/models:anonymous-p` user

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-EMAIL-20FUNCTION-29"></a>

##### [function](9852) `reblocks-auth/models:change-email` user email

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-NICKNAME-20FUNCTION-29"></a>

##### [function](10ed) `reblocks-auth/models:change-nickname` new-nickname

Changes nickname of the current user.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACREATE-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](60e2) `reblocks-auth/models:create-social-user` service service-user-id &rest metadata &key email

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AFIND-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](c1b5) `reblocks-auth/models:find-social-user` service service-user-id

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-ALL-USERS-20FUNCTION-29"></a>

##### [function](a6a0) `reblocks-auth/models:get-all-users`

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-CURRENT-USER-20FUNCTION-29"></a>

##### [function](90f2) `reblocks-auth/models:get-current-user`

Returns current user or `NIL`.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-EMAIL-20FUNCTION-29"></a>

##### [function](a484) `reblocks-auth/models:get-user-by-email` email

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-NICKNAME-20FUNCTION-29"></a>

##### [function](07ca) `reblocks-auth/models:get-user-by-nickname` nickname

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AUSER-SOCIAL-PROFILES-20FUNCTION-29"></a>

##### [function](6ba7) `reblocks-auth/models:user-social-profiles` user

Returns a list of social profiles, bound to the user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FMODELS-3A-2AUSER-CLASS-2A-20-28VARIABLE-29-29"></a>

##### [variable](5909) `reblocks-auth/models:*user-class*` user

Allows to redefine a model, for users to be created by the reblocks-auth.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/MAILGUN

<a id="x-28-23A-28-2837-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-22-29-20PACKAGE-29"></a>

#### [package](dc7b) `reblocks-auth/providers/email/mailgun`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3ADEFINE-CODE-SENDER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](d553) `reblocks-auth/providers/email/mailgun:define-code-sender` NAME (FROM-EMAIL URL-VAR &KEY (SUBJECT "Authentication code")) &BODY HTML-TEMPLATE-BODY

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/MODELS

<a id="x-28-23A-28-2836-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-22-29-20PACKAGE-29"></a>

#### [package](60be) `reblocks-auth/providers/email/models`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-24REGISTRATION-CODE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### REGISTRATION-CODE

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-20CLASS-29"></a>

###### [class](92ca) `reblocks-auth/providers/email/models:registration-code` (serial-pk-mixin dao-class record-timestamps-mixin)

This model stores a code sent to an email for signup or log in.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](318d) `reblocks-auth/providers/email/models:registration-code` (registration-code) (:code)

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-EMAIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](458c) `reblocks-auth/providers/email/models:registration-email` (registration-code) (:email)

User's email.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AVALID-UNTIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](b97d) `reblocks-auth/providers/email/models:valid-until` (registration-code) (:valid-until)

Expiration time.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3ASEND-CODE-20FUNCTION-29"></a>

##### [function](e2d9) `reblocks-auth/providers/email/models:send-code` email &key retpath send-callback

Usually you should define a global callback using
[`reblocks-auth/providers/email/mailgun:define-code-sender`][f455] macro,
but you can provide an alternative function to handle
email sending.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3A-2ASEND-CODE-CALLBACK-2A-20-28VARIABLE-29-29"></a>

##### [variable](7dd0) `reblocks-auth/providers/email/models:*send-code-callback*` -unbound-

Set this variable to a function of one argument of class [`registration-code`][1573].
It should send a registration code using template, suitable for your website.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING

<a id="x-28-23A-28-2840-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-22-29-20PACKAGE-29"></a>

#### [package](fa57) `reblocks-auth/providers/email/processing`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-24REQUEST-CODE-FORM-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### REQUEST-CODE-FORM

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-20CLASS-29"></a>

###### [class](ab94) `reblocks-auth/providers/email/processing:request-code-form` (widget)

**Readers**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARETPATH-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [reader](f861) `reblocks-auth/providers/email/processing:retpath` (request-code-form) (:retpath)

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ASENT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [reader](6877) `reblocks-auth/providers/email/processing:sent` (request-code-form) (= nil)

**Accessors**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ASENT-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [accessor](6877) `reblocks-auth/providers/email/processing:sent` (request-code-form) (= nil)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AFORM-CSS-CLASSES-20GENERIC-FUNCTION-29"></a>

##### [generic-function](5ab8) `reblocks-auth/providers/email/processing:form-css-classes` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-EMAIL-INPUT-20GENERIC-FUNCTION-29"></a>

##### [generic-function](a7e1) `reblocks-auth/providers/email/processing:render-email-input` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-SENT-MESSAGE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](2ac9) `reblocks-auth/providers/email/processing:render-sent-message` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-SUBMIT-BUTTON-20GENERIC-FUNCTION-29"></a>

##### [generic-function](67e6) `reblocks-auth/providers/email/processing:render-submit-button` widget

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ARECAPTCHA-SECRET-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](bdc5) `reblocks-auth/providers/email/processing:*recaptcha-secret-key*` nil

Set this variable to a secret key, generated by Google reCaptcha.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ARECAPTCHA-SITE-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](e53c) `reblocks-auth/providers/email/processing:*recaptcha-site-key*` nil

Set this variable to a site key, generated by Google reCaptcha.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/RESEND

<a id="x-28-23A-28-2836-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-22-29-20PACKAGE-29"></a>

#### [package](90b2) `reblocks-auth/providers/email/resend`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3AMAKE-CODE-SENDER-20FUNCTION-29"></a>

##### [function](b4f5) `reblocks-auth/providers/email/resend:make-code-sender` thunk &key base-uri

Makes a function which will prepare params and call `THUNK` function with email and `URL`.

Usually you don't need to call this function directly and you can use just [`define-code-sender`][fc31] macro.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3ADEFINE-CODE-SENDER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](7837) `reblocks-auth/providers/email/resend:define-code-sender` NAME (FROM-EMAIL URL-VAR &KEY (SUBJECT "Authentication code")) &BODY HTML-TEMPLATE-BODY

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40ROADMAP-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Roadmap

* Add support for authentication by a link sent to the email.
* Add ability to bind multiple service providers to a single user.


[e462]: https://40ants.com/reblocks-auth/
[ac3a]: https://40ants.com/reblocks-auth/#x-28-23A-28-2813-29-20BASE-CHAR-20-2E-20-22reblocks-auth-22-29-20ASDF-2FSYSTEM-3ASYSTEM-29
[5d34]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FBUTTON-3ARENDER-20GENERIC-FUNCTION-29
[ac4c]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3A-2AENABLED-SERVICES-2A-20-28VARIABLE-29-29
[0dc2]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3ALOGIN-PROCESSOR-20CLASS-29
[4d0d]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3ALOGOUT-PROCESSOR-20CLASS-29
[8c78]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3AGET-CURRENT-USER-20FUNCTION-29
[d9d6]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-20CLASS-29
[05f7]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3AUSER-20CLASS-29
[f455]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3ADEFINE-CODE-SENDER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29
[1573]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-20CLASS-29
[fc31]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3ADEFINE-CODE-SENDER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29
[5f0d]: https://40ants.com/reblocks-navigation-widget/#x-28REBLOCKS-NAVIGATION-WIDGET-3ADEFROUTES-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29
[1668]: https://github.com/40ants/reblocks-auth
[2ba2]: https://github.com/40ants/reblocks-auth/actions
[594a]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/auth.lisp#L1
[d58e]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/auth.lisp#L8
[87d4]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/button.lisp#L1
[16bd]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/button.lisp#L10
[543b]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/conditions.lisp#L1
[a588]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/conditions.lisp#L10
[b751]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/core.lisp#L1
[9ed3]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/core.lisp#L143
[a864]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/core.lisp#L43
[70a7]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/core.lisp#L47
[df1b]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/core.lisp#L51
[75b0]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/core.lisp#L55
[eb29]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/core.lisp#L60
[fd01]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/core.lisp#L65
[5a82]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/core.lisp#L69
[6477]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/core.lisp#L80
[56f8]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/errors.lisp#L1
[1626]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/errors.lisp#L7
[0dfc]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/github.lisp#L1
[240d]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/github.lisp#L144
[3538]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/github.lisp#L149
[94cf]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/github.lisp#L36
[70ff]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/github.lisp#L40
[70d5]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/github.lisp#L44
[94a4]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/github.lisp#L82
[a769]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L1
[a6a0]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L106
[c1b5]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L110
[60e2]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L119
[90f2]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L146
[6ba7]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L152
[f947]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L165
[a484]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L169
[07ca]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L174
[10ed]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L179
[9852]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L193
[67cb]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L37
[fdc5]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L38
[e800]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L44
[5909]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L55
[ba9f]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L59
[001e]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L68
[cee2]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L74
[f37a]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/models.lisp#L77
[dc7b]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/mailgun.lisp#L1
[d553]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/mailgun.lisp#L44
[60be]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/models.lisp#L1
[7dd0]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/models.lisp#L21
[92ca]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/models.lisp#L43
[458c]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/models.lisp#L44
[318d]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/models.lisp#L48
[b97d]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/models.lisp#L52
[e2d9]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/models.lisp#L78
[fa57]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/processing.lisp#L1
[2ac9]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/processing.lisp#L159
[a7e1]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/processing.lisp#L175
[67e6]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/processing.lisp#L183
[5ab8]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/processing.lisp#L191
[e53c]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/processing.lisp#L44
[bdc5]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/processing.lisp#L47
[ab94]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/processing.lisp#L51
[f861]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/processing.lisp#L52
[6877]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/processing.lisp#L54
[90b2]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/resend.lisp#L1
[b4f5]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/resend.lisp#L16
[7837]: https://github.com/40ants/reblocks-auth/blob/9d432be6febe3704a60a2fd6ad91c5d20871d461/src/providers/email/resend.lisp#L44
[4f85]: https://github.com/40ants/reblocks-auth/issues
[c7c4]: https://github.com/fukamachi/mito
[8236]: https://quickdocs.org/alexandria
[2ecb]: https://quickdocs.org/cl-strings
[8347]: https://quickdocs.org/dexador
[6dd8]: https://quickdocs.org/jonathan
[46a1]: https://quickdocs.org/local-time
[7f8b]: https://quickdocs.org/log4cl
[ef16]: https://quickdocs.org/mailgun
[5b70]: https://quickdocs.org/mito
[2103]: https://quickdocs.org/quri
[184b]: https://quickdocs.org/reblocks
[28e0]: https://quickdocs.org/reblocks-lass
[4376]: https://quickdocs.org/reblocks-ui
[cd18]: https://quickdocs.org/secret-values
[c41d]: https://quickdocs.org/serapeum
[d6b3]: https://quickdocs.org/uuid
[aba2]: https://quickdocs.org/yason

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
