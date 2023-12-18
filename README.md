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

#### [package](353f) `reblocks-auth/auth`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FAUTH-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FAUTH-3AAUTHENTICATE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](b483) `reblocks-auth/auth:authenticate` service &rest params &key code

Called when user had authenticated in the service and returned
to our site.

All `GET` arguments are collected into a plist and passed as params.

Should return two values a user and a flag denotifing if user was just created.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FBUTTON-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/BUTTON

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FBUTTON-22-29-20PACKAGE-29"></a>

#### [package](f14f) `reblocks-auth/button`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FBUTTON-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FBUTTON-3ARENDER-20GENERIC-FUNCTION-29"></a>

##### [generic-function](0659) `reblocks-auth/button:render` service &key retpath

Renders a button for given service.
Service should be a keyword like :github or :facebook.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CONDITIONS

<a id="x-28-23A-28-2824-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCONDITIONS-22-29-20PACKAGE-29"></a>

#### [package](ff1e) `reblocks-auth/conditions`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCONDITIONS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-24UNABLE-TO-AUTHENTICATE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### UNABLE-TO-AUTHENTICATE

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-20CONDITION-29"></a>

###### [condition](2ffd) `reblocks-auth/conditions:unable-to-authenticate` ()

**Readers**

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](2ffd) `reblocks-auth/conditions:get-message` (unable-to-authenticate) (:message)

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-REASON-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](2ffd) `reblocks-auth/conditions:get-reason` (unable-to-authenticate) (:reason = 'nil)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CORE

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCORE-22-29-20PACKAGE-29"></a>

#### [package](e034) `reblocks-auth/core`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-24LOGIN-PROCESSOR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LOGIN-PROCESSOR

<a id="x-28REBLOCKS-AUTH-2FCORE-3ALOGIN-PROCESSOR-20CLASS-29"></a>

###### [class](7c73) `reblocks-auth/core:login-processor` (widget)

This widget should be rendered to process user's login.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-24LOGOUT-PROCESSOR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LOGOUT-PROCESSOR

<a id="x-28REBLOCKS-AUTH-2FCORE-3ALOGOUT-PROCESSOR-20CLASS-29"></a>

###### [class](f6e4) `reblocks-auth/core:logout-processor` (widget)

This widget should be rendered to process user's logout.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FCORE-3ARENDER-LOGIN-PAGE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](bf77) `reblocks-auth/core:render-login-page` app &key retpath

By default, renders a list of buttons for each allowed authentication method.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGIN-PROCESSOR-20FUNCTION-29"></a>

##### [function](baf3) `reblocks-auth/core:make-login-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGOUT-PROCESSOR-20FUNCTION-29"></a>

##### [function](1e87) `reblocks-auth/core:make-logout-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3ARENDER-BUTTONS-20FUNCTION-29"></a>

##### [function](9cf1) `reblocks-auth/core:render-buttons` &key retpath

Renders a row of buttons for enabled service providers.

Optionally you can specify `RETPATH` argument with an `URI` to return user
after login.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2AALLOW-NEW-ACCOUNTS-CREATION-2A-20-28VARIABLE-29-29"></a>

##### [variable](785a) `reblocks-auth/core:*allow-new-accounts-creation*` t

When True, a new account will be created. Otherwise only already existing users can log in.

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2AENABLED-SERVICES-2A-20-28VARIABLE-29-29"></a>

##### [variable](1cb1) `reblocks-auth/core:*enabled-services*` (:github)

Set this variable to limit a services available to login through.

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2ALOGIN-HOOKS-2A-20-28VARIABLE-29-29"></a>

##### [variable](15ed) `reblocks-auth/core:*login-hooks*` nil

Append a funcallable handlers which accept single argument - logged user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FERRORS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/ERRORS

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FERRORS-22-29-20PACKAGE-29"></a>

#### [package](7b54) `reblocks-auth/errors`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FERRORS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FERRORS-24NICKNAME-IS-NOT-AVAILABLE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### NICKNAME-IS-NOT-AVAILABLE

<a id="x-28REBLOCKS-AUTH-2FERRORS-3ANICKNAME-IS-NOT-AVAILABLE-20CONDITION-29"></a>

###### [condition](0dd9) `reblocks-auth/errors:nickname-is-not-available` (error)

Signalled when there is already a user with given nickname.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FGITHUB-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/GITHUB

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FGITHUB-22-29-20PACKAGE-29"></a>

#### [package](e95e) `reblocks-auth/github`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-SCOPES-20FUNCTION-29"></a>

##### [function](4019) `reblocks-auth/github:get-scopes`

Returns current user's scopes.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-TOKEN-20FUNCTION-29"></a>

##### [function](29bb) `reblocks-auth/github:get-token`

Returns current user's GitHub token.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3ARENDER-BUTTON-20FUNCTION-29"></a>

##### [function](cdbf) `reblocks-auth/github:render-button` &KEY (CLASS "button small") (SCOPES \*DEFAULT-SCOPES\*) (TEXT "Grant permissions") (RETPATH (GET-URI))

Renders a button to request more scopes.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ACLIENT-ID-2A-20-28VARIABLE-29-29"></a>

##### [variable](92c7) `reblocks-auth/github:*client-id*` nil

`OA`uth client id

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ADEFAULT-SCOPES-2A-20-28VARIABLE-29-29"></a>

##### [variable](1aba) `reblocks-auth/github:*default-scopes*` ("user:email")

A listo of default scopes to request from GitHub.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ASECRET-2A-20-28VARIABLE-29-29"></a>

##### [variable](0378) `reblocks-auth/github:*secret*` nil

`OA`uth secret. It might be a string or secret-values:secret-value.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/MODELS

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FMODELS-22-29-20PACKAGE-29"></a>

#### [package](2bfd) `reblocks-auth/models`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24SOCIAL-PROFILE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### SOCIAL-PROFILE

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-20CLASS-29"></a>

###### [class](ffbd) `reblocks-auth/models:social-profile` (serial-pk-mixin dao-class record-timestamps-mixin)

Represents a User's link to a social service.
User can be bound to multiple social services.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](6376) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](520a) `reblocks-auth/models:profile-service` (social-profile) (:service)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-USER-ID-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](4073) `reblocks-auth/models:profile-service-user-id` (social-profile) (:service-user-id)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-USER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader] `reblocks-auth/models:profile-user` (social-profile) (:user)

A [`user`][05f7] instance, bound to the [`social-profile`][d9d6].

**Accessors**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [accessor](6376) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24USER-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### USER

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AUSER-20CLASS-29"></a>

###### [class](77aa) `reblocks-auth/models:user` (serial-pk-mixin dao-class record-timestamps-mixin)

This class stores basic information about user - it's nickname and email.
Additional information is stored inside [`social-profile`][d9d6] instances.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-EMAIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](c3e5) `reblocks-auth/models:get-email` (user) (:email = nil)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-NICKNAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](d944) `reblocks-auth/models:get-nickname` (user) (:nickname)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AANONYMOUS-P-20FUNCTION-29"></a>

##### [function](1c38) `reblocks-auth/models:anonymous-p` user

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-EMAIL-20FUNCTION-29"></a>

##### [function](99f0) `reblocks-auth/models:change-email` user email

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-NICKNAME-20FUNCTION-29"></a>

##### [function](ab1c) `reblocks-auth/models:change-nickname` new-nickname

Changes nickname of the current user.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACREATE-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](53ef) `reblocks-auth/models:create-social-user` service service-user-id &rest metadata &key email

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AFIND-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](7311) `reblocks-auth/models:find-social-user` service service-user-id

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-ALL-USERS-20FUNCTION-29"></a>

##### [function](d087) `reblocks-auth/models:get-all-users`

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-CURRENT-USER-20FUNCTION-29"></a>

##### [function](bc29) `reblocks-auth/models:get-current-user`

Returns current user or `NIL`.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-EMAIL-20FUNCTION-29"></a>

##### [function](bb7d) `reblocks-auth/models:get-user-by-email` email

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-NICKNAME-20FUNCTION-29"></a>

##### [function](621b) `reblocks-auth/models:get-user-by-nickname` nickname

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AUSER-SOCIAL-PROFILES-20FUNCTION-29"></a>

##### [function](8b7a) `reblocks-auth/models:user-social-profiles` user

Returns a list of social profiles, bound to the user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FMODELS-3A-2AUSER-CLASS-2A-20-28VARIABLE-29-29"></a>

##### [variable](1977) `reblocks-auth/models:*user-class*` user

Allows to redefine a model, for users to be created by the reblocks-auth.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/MAILGUN

<a id="x-28-23A-28-2837-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-22-29-20PACKAGE-29"></a>

#### [package](7880) `reblocks-auth/providers/email/mailgun`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3ADEFINE-CODE-SENDER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](f8af) `reblocks-auth/providers/email/mailgun:define-code-sender` NAME (FROM-EMAIL URL-VAR &KEY (SUBJECT "Authentication code")) &BODY HTML-TEMPLATE-BODY

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/MODELS

<a id="x-28-23A-28-2836-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-22-29-20PACKAGE-29"></a>

#### [package](e755) `reblocks-auth/providers/email/models`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-24REGISTRATION-CODE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### REGISTRATION-CODE

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-20CLASS-29"></a>

###### [class](edd9) `reblocks-auth/providers/email/models:registration-code` (serial-pk-mixin dao-class record-timestamps-mixin)

This model stores a code sent to an email for signup or log in.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](5c26) `reblocks-auth/providers/email/models:registration-code` (registration-code) (:code)

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-EMAIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](0d73) `reblocks-auth/providers/email/models:registration-email` (registration-code) (:email)

User's email.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AVALID-UNTIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](d992) `reblocks-auth/providers/email/models:valid-until` (registration-code) (:valid-until)

Expiration time.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3ASEND-CODE-20FUNCTION-29"></a>

##### [function](9470) `reblocks-auth/providers/email/models:send-code` email &key retpath send-callback

Usually you should define a global callback using
[`reblocks-auth/providers/email/mailgun:define-code-sender`][f455] macro,
but you can provide an alternative function to handle
email sending.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3A-2ASEND-CODE-CALLBACK-2A-20-28VARIABLE-29-29"></a>

##### [variable](42fa) `reblocks-auth/providers/email/models:*send-code-callback*` -unbound-

Set this variable to a function of one argument of class [`registration-code`][1573].
It should send a registration code using template, suitable for your website.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING

<a id="x-28-23A-28-2840-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-22-29-20PACKAGE-29"></a>

#### [package](daed) `reblocks-auth/providers/email/processing`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-24REQUEST-CODE-FORM-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### REQUEST-CODE-FORM

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-20CLASS-29"></a>

###### [class](db4f) `reblocks-auth/providers/email/processing:request-code-form` (widget)

**Readers**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARETPATH-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [reader](422b) `reblocks-auth/providers/email/processing:retpath` (request-code-form) (:retpath)

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ASENT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [reader](bdd5) `reblocks-auth/providers/email/processing:sent` (request-code-form) (= nil)

**Accessors**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ASENT-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [accessor](bdd5) `reblocks-auth/providers/email/processing:sent` (request-code-form) (= nil)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AFORM-CSS-CLASSES-20GENERIC-FUNCTION-29"></a>

##### [generic-function](78e1) `reblocks-auth/providers/email/processing:form-css-classes` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-EMAIL-INPUT-20GENERIC-FUNCTION-29"></a>

##### [generic-function](8f48) `reblocks-auth/providers/email/processing:render-email-input` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-SENT-MESSAGE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](ff95) `reblocks-auth/providers/email/processing:render-sent-message` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-SUBMIT-BUTTON-20GENERIC-FUNCTION-29"></a>

##### [generic-function](8866) `reblocks-auth/providers/email/processing:render-submit-button` widget

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ARECAPTCHA-SECRET-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](c9af) `reblocks-auth/providers/email/processing:*recaptcha-secret-key*` nil

Set this variable to a secret key, generated by Google reCaptcha.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ARECAPTCHA-SITE-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](45c3) `reblocks-auth/providers/email/processing:*recaptcha-site-key*` nil

Set this variable to a site key, generated by Google reCaptcha.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/RESEND

<a id="x-28-23A-28-2836-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-22-29-20PACKAGE-29"></a>

#### [package](59d6) `reblocks-auth/providers/email/resend`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3AMAKE-CODE-SENDER-20FUNCTION-29"></a>

##### [function](083e) `reblocks-auth/providers/email/resend:make-code-sender` thunk &key base-uri

Makes a function which will prepare params and call `THUNK` function with email and `URL`.

Usually you don't need to call this function directly and you can use just [`define-code-sender`][fc31] macro.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3ADEFINE-CODE-SENDER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](d306) `reblocks-auth/providers/email/resend:define-code-sender` NAME (FROM-EMAIL URL-VAR &KEY (SUBJECT "Authentication code")) &BODY HTML-TEMPLATE-BODY

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
[353f]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/auth.lisp#L1
[b483]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/auth.lisp#L8
[f14f]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/button.lisp#L1
[0659]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/button.lisp#L10
[ff1e]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/conditions.lisp#L1
[2ffd]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/conditions.lisp#L10
[e034]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/core.lisp#L1
[bf77]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/core.lisp#L143
[1cb1]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/core.lisp#L43
[15ed]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/core.lisp#L47
[785a]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/core.lisp#L51
[7c73]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/core.lisp#L55
[f6e4]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/core.lisp#L60
[baf3]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/core.lisp#L65
[1e87]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/core.lisp#L69
[9cf1]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/core.lisp#L80
[7b54]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/errors.lisp#L1
[0dd9]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/errors.lisp#L7
[e95e]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/github.lisp#L1
[29bb]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/github.lisp#L144
[4019]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/github.lisp#L149
[92c7]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/github.lisp#L36
[0378]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/github.lisp#L40
[1aba]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/github.lisp#L44
[cdbf]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/github.lisp#L82
[2bfd]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L1
[d087]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L106
[7311]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L110
[53ef]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L119
[bc29]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L146
[8b7a]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L152
[1c38]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L165
[bb7d]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L169
[621b]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L174
[ab1c]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L179
[99f0]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L193
[77aa]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L37
[d944]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L38
[c3e5]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L44
[1977]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L55
[ffbd]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L59
[520a]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L68
[4073]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L74
[6376]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/models.lisp#L77
[7880]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/mailgun.lisp#L1
[f8af]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/mailgun.lisp#L44
[e755]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/models.lisp#L1
[42fa]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/models.lisp#L21
[edd9]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/models.lisp#L43
[0d73]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/models.lisp#L44
[5c26]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/models.lisp#L48
[d992]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/models.lisp#L52
[9470]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/models.lisp#L78
[daed]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/processing.lisp#L1
[ff95]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/processing.lisp#L157
[8f48]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/processing.lisp#L173
[8866]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/processing.lisp#L181
[78e1]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/processing.lisp#L189
[45c3]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/processing.lisp#L42
[c9af]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/processing.lisp#L45
[db4f]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/processing.lisp#L49
[422b]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/processing.lisp#L50
[bdd5]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/processing.lisp#L52
[59d6]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/resend.lisp#L1
[083e]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/resend.lisp#L16
[d306]: https://github.com/40ants/reblocks-auth/blob/d183768f110f65474f0afb6ec04affd259eab558/src/providers/email/resend.lisp#L44
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
