<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-40README-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# reblocks-auth - A system to add an authentication to the Reblocks based web-site.

<a id="reblocks-auth-asdf-system-details"></a>

## REBLOCKS-AUTH ASDF System Details

* Version: 0.6.0

* Description: A system to add an authentication to the Reblocks based web-site.

* Licence: Unlicense

* Author: Alexander Artemenko <svetlyak.40wt@gmail.com>

* Homepage: [https://40ants.com/reblocks-auth/][e462]

* Bug tracker: [https://github.com/40ants/reblocks-auth/issues][4f85]

* Source control: [GIT][1668]

* Depends on: [alexandria][8236], [cl-strings][2ecb], [dexador][8347], [jonathan][6dd8], [log4cl][7f8b], [mito][5b70], [quri][2103], [reblocks][184b], [secret-values][cd18]

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
<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40ROADMAP-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Roadmap

* Add support for authentication by a link sent to the email.

* Add ability to bind multiple service providers to a single user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CORE

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCORE-22-29-20PACKAGE-29"></a>

#### [package](2803) `reblocks-auth/core`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGIN-PROCESSOR-20FUNCTION-29"></a>

##### [function](dfa3) `reblocks-auth/core:make-login-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGOUT-PROCESSOR-20FUNCTION-29"></a>

##### [function](1b6f) `reblocks-auth/core:make-logout-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3ARENDER-BUTTONS-20FUNCTION-29"></a>

##### [function](53a8) `reblocks-auth/core:render-buttons` &key retpath

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2AENABLED-SERVICES-2A-20-28VARIABLE-29-29"></a>

##### [variable](ac64) `reblocks-auth/core:*enabled-services*` (:github)

Set this variable to limit a services available to login through.

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2ALOGIN-HOOKS-2A-20-28VARIABLE-29-29"></a>

##### [variable](04c4) `reblocks-auth/core:*login-hooks*` nil

Append a funcallable handlers which accept single argument - logged user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FUTILS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/UTILS

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FUTILS-22-29-20PACKAGE-29"></a>

#### [package](b6ae) `reblocks-auth/utils`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FUTILS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FUTILS-3AKEYWORDIFY-20FUNCTION-29"></a>

##### [function](39c6) `reblocks-auth/utils:keywordify` string

<a id="x-28REBLOCKS-AUTH-2FUTILS-3ATO-PLIST-20FUNCTION-29"></a>

##### [function](fa03) `reblocks-auth/utils:to-plist` alist &key without

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FGITHUB-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/GITHUB

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FGITHUB-22-29-20PACKAGE-29"></a>

#### [package](e9af) `reblocks-auth/github`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-SCOPES-20FUNCTION-29"></a>

##### [function](fec4) `reblocks-auth/github:get-scopes`

Returns current user's scopes.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-TOKEN-20FUNCTION-29"></a>

##### [function](4356) `reblocks-auth/github:get-token`

Returns current user's GitHub token.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3ARENDER-BUTTON-20FUNCTION-29"></a>

##### [function](cdf5) `reblocks-auth/github:render-button` &KEY (CLASS "button small") (SCOPES \*DEFAULT-SCOPES\*) (TEXT "Grant permissions") (RETPATH (GET-URI))

Renders a button to request more scopes.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ACLIENT-ID-2A-20-28VARIABLE-29-29"></a>

##### [variable](169b) `reblocks-auth/github:*client-id*` nil

`OA`uth client id

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ADEFAULT-SCOPES-2A-20-28VARIABLE-29-29"></a>

##### [variable](8821) `reblocks-auth/github:*default-scopes*` ("user:email")

A listo of default scopes to request from GitHub.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ASECRET-2A-20-28VARIABLE-29-29"></a>

##### [variable](2fbc) `reblocks-auth/github:*secret*` nil

`OA`uth secret. It might be a string or secret-values:secret-value.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FAUTH-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/AUTH

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FAUTH-22-29-20PACKAGE-29"></a>

#### [package](744e) `reblocks-auth/auth`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FAUTH-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FAUTH-3AAUTHENTICATE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](f212) `reblocks-auth/auth:authenticate` service &rest params &key code

Called when user had authenticated in the service and returned
to our site.

All `GET` arguments are collected into a plist and passed as params.

Should return two values a user and a flag denotifing if user was just created.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FBUTTON-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/BUTTON

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FBUTTON-22-29-20PACKAGE-29"></a>

#### [package](7bab) `reblocks-auth/button`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FBUTTON-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FBUTTON-3ARENDER-20GENERIC-FUNCTION-29"></a>

##### [generic-function](ab24) `reblocks-auth/button:render` service &key retpath

Renders a button for given service.
Service should be a keyword like :github or :facebook.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/MODELS

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FMODELS-22-29-20PACKAGE-29"></a>

#### [package](43a4) `reblocks-auth/models`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24SOCIAL-PROFILE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### SOCIAL-PROFILE

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-20CLASS-29"></a>

###### [class](1703) `reblocks-auth/models:social-profile` (serial-pk-mixin dao-class record-timestamps-mixin)

Represents a User's link to a social service.
User can be bound to multiple social services.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](d9c1) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](af96) `reblocks-auth/models:profile-service` (social-profile) (:service)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-USER-ID-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](746e) `reblocks-auth/models:profile-service-user-id` (social-profile) (:service-user-id)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-USER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader] `reblocks-auth/models:profile-user` (social-profile) (:user)

A [`user`][05f7] instance, bound to the [`social-profile`][d9d6].

**Accessors**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [accessor](d9c1) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24USER-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### USER

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AUSER-20CLASS-29"></a>

###### [class](b9fa) `reblocks-auth/models:user` (serial-pk-mixin dao-class record-timestamps-mixin)

This class stores basic information about user - it's nickname and email.
Additional information is stored inside [`social-profile`][d9d6] instances.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-EMAIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](0e6f) `reblocks-auth/models:get-email` (user) (:email = nil)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-NICKNAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](98a0) `reblocks-auth/models:get-nickname` (user) (:nickname)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AANONYMOUS-P-20FUNCTION-29"></a>

##### [function](848d) `reblocks-auth/models:anonymous-p` user

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-EMAIL-20FUNCTION-29"></a>

##### [function](9fb8) `reblocks-auth/models:change-email` user email

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACREATE-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](8ff8) `reblocks-auth/models:create-social-user` service service-user-id &rest metadata &key email

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AFIND-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](8e59) `reblocks-auth/models:find-social-user` service service-user-id

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-ALL-USERS-20FUNCTION-29"></a>

##### [function](1e0f) `reblocks-auth/models:get-all-users`

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-CURRENT-USER-20FUNCTION-29"></a>

##### [function](db01) `reblocks-auth/models:get-current-user`

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-EMAIL-20FUNCTION-29"></a>

##### [function](f421) `reblocks-auth/models:get-user-by-email` email

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-NICKNAME-20FUNCTION-29"></a>

##### [function](01c2) `reblocks-auth/models:get-user-by-nickname` nickname

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CONDITIONS

<a id="x-28-23A-28-2824-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCONDITIONS-22-29-20PACKAGE-29"></a>

#### [package](1193) `reblocks-auth/conditions`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCONDITIONS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-24UNABLE-TO-AUTHENTICATE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### UNABLE-TO-AUTHENTICATE

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-20CONDITION-29"></a>

###### [condition](4cd7) `reblocks-auth/conditions:unable-to-authenticate` ()

**Readers**

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](4cd7) `reblocks-auth/conditions:get-message` (unable-to-authenticate) (:message)

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-REASON-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](4cd7) `reblocks-auth/conditions:get-reason` (unable-to-authenticate) (:reason = 'nil)


[e462]: https://40ants.com/reblocks-auth/
[d9d6]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-20CLASS-29
[05f7]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3AUSER-20CLASS-29
[1668]: https://github.com/40ants/reblocks-auth
[2ba2]: https://github.com/40ants/reblocks-auth/actions
[744e]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/auth.lisp#L1
[f212]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/auth.lisp#L8
[7bab]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/button.lisp#L1
[ab24]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/button.lisp#L10
[1193]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/conditions.lisp#L1
[4cd7]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/conditions.lisp#L10
[2803]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/core.lisp#L1
[ac64]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/core.lisp#L36
[04c4]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/core.lisp#L40
[dfa3]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/core.lisp#L55
[1b6f]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/core.lisp#L59
[53a8]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/core.lisp#L70
[e9af]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/github.lisp#L1
[4356]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/github.lisp#L144
[fec4]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/github.lisp#L149
[169b]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/github.lisp#L36
[2fbc]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/github.lisp#L40
[8821]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/github.lisp#L44
[cdf5]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/github.lisp#L82
[43a4]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L1
[8ff8]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L106
[db01]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L126
[848d]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L137
[f421]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L141
[01c2]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L146
[9fb8]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L151
[b9fa]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L32
[98a0]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L33
[0e6f]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L36
[1703]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L47
[af96]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L55
[746e]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L61
[d9c1]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L64
[1e0f]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L93
[8e59]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/models.lisp#L97
[b6ae]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/utils.lisp#L1
[39c6]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/utils.lisp#L11
[fa03]: https://github.com/40ants/reblocks-auth/blob/54eb8b2626132ecc3a0d1cfa134e3b469496f026/src/utils.lisp#L16
[4f85]: https://github.com/40ants/reblocks-auth/issues
[c7c4]: https://github.com/fukamachi/mito
[8236]: https://quickdocs.org/alexandria
[2ecb]: https://quickdocs.org/cl-strings
[8347]: https://quickdocs.org/dexador
[6dd8]: https://quickdocs.org/jonathan
[7f8b]: https://quickdocs.org/log4cl
[5b70]: https://quickdocs.org/mito
[2103]: https://quickdocs.org/quri
[184b]: https://quickdocs.org/reblocks
[cd18]: https://quickdocs.org/secret-values

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
