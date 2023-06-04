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

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40INSTALLATION-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Installation

You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :reblocks-auth)
```
<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CORE

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCORE-22-29-20PACKAGE-29"></a>

#### [package](af95) `reblocks-auth/core`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGIN-PROCESSOR-20FUNCTION-29"></a>

##### [function](d50c) `reblocks-auth/core:make-login-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGOUT-PROCESSOR-20FUNCTION-29"></a>

##### [function](5bff) `reblocks-auth/core:make-logout-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3ARENDER-BUTTONS-20FUNCTION-29"></a>

##### [function](82c2) `reblocks-auth/core:render-buttons` &key retpath

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2AENABLED-SERVICES-2A-20-28VARIABLE-29-29"></a>

##### [variable](4fa5) `reblocks-auth/core:*enabled-services*` (:github)

Set this variable to limit a services available to login through.

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2ALOGIN-HOOKS-2A-20-28VARIABLE-29-29"></a>

##### [variable](6274) `reblocks-auth/core:*login-hooks*` nil

Append a funcallable handlers which accept single argument - logged user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FUTILS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/UTILS

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FUTILS-22-29-20PACKAGE-29"></a>

#### [package](1234) `reblocks-auth/utils`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FUTILS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FUTILS-3AKEYWORDIFY-20FUNCTION-29"></a>

##### [function](8f6b) `reblocks-auth/utils:keywordify` string

<a id="x-28REBLOCKS-AUTH-2FUTILS-3ATO-PLIST-20FUNCTION-29"></a>

##### [function](8aff) `reblocks-auth/utils:to-plist` alist &key without

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FGITHUB-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/GITHUB

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FGITHUB-22-29-20PACKAGE-29"></a>

#### [package](59e5) `reblocks-auth/github`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-SCOPES-20FUNCTION-29"></a>

##### [function](b0a8) `reblocks-auth/github:get-scopes`

Returns current user's scopes.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-TOKEN-20FUNCTION-29"></a>

##### [function](085f) `reblocks-auth/github:get-token`

Returns current user's GitHub token.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3ARENDER-BUTTON-20FUNCTION-29"></a>

##### [function](d400) `reblocks-auth/github:render-button` &KEY (CLASS "button small") (SCOPES \*DEFAULT-SCOPES\*) (TEXT "Grant permissions") (RETPATH (GET-URI))

Renders a button to request more scopes.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ACLIENT-ID-2A-20-28VARIABLE-29-29"></a>

##### [variable](dae2) `reblocks-auth/github:*client-id*` nil

`OA`uth client id

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ADEFAULT-SCOPES-2A-20-28VARIABLE-29-29"></a>

##### [variable](6734) `reblocks-auth/github:*default-scopes*` ("user:email")

A listo of default scopes to request from GitHub.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ASECRET-2A-20-28VARIABLE-29-29"></a>

##### [variable](8fee) `reblocks-auth/github:*secret*` nil

`OA`uth secret. It might be a string or secret-values:secret-value.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FAUTH-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/AUTH

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FAUTH-22-29-20PACKAGE-29"></a>

#### [package](281a) `reblocks-auth/auth`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FAUTH-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FAUTH-3AAUTHENTICATE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](bddd) `reblocks-auth/auth:authenticate` service &rest params &key code

Called when user had authenticated in the service and returned
to our site.

All `GET` arguments are collected into a plist and passed as params.

Should return two values a user and a flag denotifing if user was just created.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FBUTTON-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/BUTTON

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FBUTTON-22-29-20PACKAGE-29"></a>

#### [package](4495) `reblocks-auth/button`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FBUTTON-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FBUTTON-3ARENDER-20GENERIC-FUNCTION-29"></a>

##### [generic-function](9002) `reblocks-auth/button:render` service &key retpath

Renders a button for given service.
Service should be a keyword like :github or :facebook.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/MODELS

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FMODELS-22-29-20PACKAGE-29"></a>

#### [package](d793) `reblocks-auth/models`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24SOCIAL-PROFILE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### SOCIAL-PROFILE

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-20CLASS-29"></a>

###### [class](51a1) `reblocks-auth/models:social-profile` (serial-pk-mixin dao-class record-timestamps-mixin)

Represents a User's link to a social service.
User can be bound to multiple social services.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](5259) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](6a50) `reblocks-auth/models:profile-service` (social-profile) (:service)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-USER-ID-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](9cf9) `reblocks-auth/models:profile-service-user-id` (social-profile) (:service-user-id)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-USER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader] `reblocks-auth/models:profile-user` (social-profile) (:user)

**Accessors**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [accessor](5259) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-USER-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [accessor] `reblocks-auth/models:profile-user` (social-profile) (:user)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24USER-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### USER

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AUSER-20CLASS-29"></a>

###### [class](ec57) `reblocks-auth/models:user` (serial-pk-mixin dao-class record-timestamps-mixin)

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-EMAIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](fb6b) `reblocks-auth/models:get-email` (user) (:email = nil)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-NICKNAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](e45e) `reblocks-auth/models:get-nickname` (user) (:nickname)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AANONYMOUS-P-20FUNCTION-29"></a>

##### [function](539b) `reblocks-auth/models:anonymous-p` user

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-EMAIL-20FUNCTION-29"></a>

##### [function](22cf) `reblocks-auth/models:change-email` user email

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACREATE-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](679b) `reblocks-auth/models:create-social-user` service service-user-id &rest metadata &key email

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AFIND-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](fa95) `reblocks-auth/models:find-social-user` service service-user-id

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-ALL-USERS-20FUNCTION-29"></a>

##### [function](a3b4) `reblocks-auth/models:get-all-users`

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-CURRENT-USER-20FUNCTION-29"></a>

##### [function](e4a3) `reblocks-auth/models:get-current-user`

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-EMAIL-20FUNCTION-29"></a>

##### [function](c102) `reblocks-auth/models:get-user-by-email` email

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-NICKNAME-20FUNCTION-29"></a>

##### [function](782e) `reblocks-auth/models:get-user-by-nickname` nickname

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CONDITIONS

<a id="x-28-23A-28-2824-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCONDITIONS-22-29-20PACKAGE-29"></a>

#### [package](d44e) `reblocks-auth/conditions`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCONDITIONS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-24UNABLE-TO-AUTHENTICATE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### UNABLE-TO-AUTHENTICATE

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-20CONDITION-29"></a>

###### [condition](9ec5) `reblocks-auth/conditions:unable-to-authenticate` ()

**Readers**

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](9ec5) `reblocks-auth/conditions:get-message` (unable-to-authenticate) (:message)

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-REASON-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](9ec5) `reblocks-auth/conditions:get-reason` (unable-to-authenticate) (:reason = 'nil)


[e462]: https://40ants.com/reblocks-auth/
[1668]: https://github.com/40ants/reblocks-auth
[2ba2]: https://github.com/40ants/reblocks-auth/actions
[281a]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/auth.lisp#L1
[bddd]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/auth.lisp#L8
[4495]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/button.lisp#L1
[9002]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/button.lisp#L10
[d44e]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/conditions.lisp#L1
[9ec5]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/conditions.lisp#L10
[af95]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/core.lisp#L1
[4fa5]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/core.lisp#L36
[6274]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/core.lisp#L40
[d50c]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/core.lisp#L55
[5bff]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/core.lisp#L59
[82c2]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/core.lisp#L70
[59e5]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/github.lisp#L1
[085f]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/github.lisp#L144
[b0a8]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/github.lisp#L149
[dae2]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/github.lisp#L36
[8fee]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/github.lisp#L40
[6734]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/github.lisp#L44
[d400]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/github.lisp#L82
[d793]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L1
[679b]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L100
[e4a3]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L120
[539b]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L131
[c102]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L135
[782e]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L140
[22cf]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L145
[ec57]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L32
[e45e]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L33
[fb6b]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L36
[51a1]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L45
[6a50]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L49
[9cf9]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L55
[5259]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L58
[a3b4]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L87
[fa95]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/models.lisp#L91
[1234]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/utils.lisp#L1
[8f6b]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/utils.lisp#L11
[8aff]: https://github.com/40ants/reblocks-auth/blob/6f9d1d438aee249d52eaa2f42b105b6f225917ec/src/utils.lisp#L16
[4f85]: https://github.com/40ants/reblocks-auth/issues
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
