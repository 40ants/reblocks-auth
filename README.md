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
* Depends on: [alexandria][8236], [babel][3a1f], [cl-strings][2ecb], [dexador][8347], [ironclad][90b9], [jonathan][6dd8], [local-time][46a1], [log4cl][7f8b], [log4cl-extras][691c], [mailgun][ef16], [mito][5b70], [quri][2103], [reblocks][184b], [reblocks-lass][28e0], [reblocks-ui][4376], [secret-values][cd18], [serapeum][c41d], [uuid][d6b3], [yason][aba2]

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

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40TELEGRAM-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Telegram Authentication

Telegram authentication uses the [Telegram Login Widget][062e].
When a user clicks the widget, Telegram opens a confirmation dialog and then redirects back
to your server with signed user data. The server verifies the `HMAC-SHA256` signature using
the bot token before accepting the login.

<a id="setting-up-a-bot"></a>

### Setting Up a Bot

1. Open [@BotFather][fecf] in Telegram and send `/newbot`.
2. After the bot is created, send `/setdomain` and enter your website's domain
   (e.g. `example.com`). Telegram will reject logins from any other domain.
3. Copy the bot username (without `@`) and the bot token shown by BotFather.

<a id="configuration"></a>

### Configuration

```lisp
(setf reblocks-auth/providers/telegram:*bot-username* "MyAppBot")
(setf reblocks-auth/providers/telegram:*bot-token*
      (secret-values:conceal-value "123456:ABC-DEF..."))

(pushnew :telegram reblocks-auth:*enabled-services*)
```
Two variables control the provider:

* [`reblocks-auth/providers/telegram:*bot-username*`][17fb] — the bot username registered
  with BotFather (used to render the widget).
* [`reblocks-auth/providers/telegram:*bot-token*`][ad5b] — the bot token used server-side
  to verify the authentication hash. Never expose this value to the browser.
  Accepts a plain string or a `secret-values:secret-value`.

<a id="how-the-login-flow-works"></a>

### How the Login Flow Works

1. The widget script is rendered as a `<script>` tag with `data-auth-url` pointing
   to `/login?service=telegram`.
2. When a user clicks the widget, Telegram opens a confirmation dialog.
3. On success Telegram appends `id`, `first_name`, `last_name`, `username`,
   `photo_url`, `auth_date`, and `hash` to the `data-auth-url` and redirects
   the browser there.
4. The `login-processor` widget picks up the `service=telegram` parameter and
   calls `reblocks-auth/auth:authenticate`.
5. The server verifies the `HMAC-SHA256` signature and checks that `auth_date`
   is no older than 24 hours.
6. The user record is looked up or created and stored in the session.

<a id="testing-on-localhost"></a>

### Testing on Localhost

Telegram requires a real public domain — `localhost` is not accepted. For local
development, expose your server with a tunneling tool and register that domain
with BotFather:

```bash
# ngrok (free tier gives a random HTTPS URL each run)
ngrok http 8080

# localtunnel (fixed subdomain)
npx localtunnel --port 8080 --subdomain myapp
```
Then in BotFather send `/setdomain` with the tunnel hostname (e.g. `myapp.loca.lt`).
Open the app through the tunnel `URL` rather than `localhost:8080`.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40SMARTCAPTCHA-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Yandex SmartCaptcha Support

Yandex SmartCaptcha provides an alternative to Google `reCAPTCHA` for protecting
the email-based authentication form.

<a id="quick-start"></a>

### Quick Start

To enable Yandex SmartCaptcha, set following variables:

```lisp
(setf reblocks-auth/providers/email/processing:*smartcaptcha-client-key* "your-client-key")
(setf reblocks-auth/providers/email/processing:*smartcaptcha-server-key* "your-server-key")
```
<a id="getting-yandex-smart-captcha-keys"></a>

### Getting Yandex SmartCaptcha Keys

1. Go to [Yandex Cloud Console][8100]
2. Navigate to SmartCaptcha service
3. Create a new SmartCaptcha site
4. Copy **Client key** (for frontend) and **Server key** (for backend)
5. Add keys to your application configuration

<a id="how-it-works"></a>

### How It Works

1. User clicks "Email" login button
2. JavaScript loads `https://smartcaptcha.yandexcloud.net/captcha.js`
3. User solves captcha (automatic or manual)
4. Token is generated and sent to backend
5. Backend validates token via `https://smartcaptcha.yandexcloud.net/validate`
6. Email with login code is sent
7. User enters code to complete authentication

<a id="multiple-captcha-providers"></a>

### Multiple Captcha Providers

Yandex SmartCaptcha takes precedence when both Yandex SmartCaptcha
and Google `reCAPTCHA` are configured.

If only Google `reCAPTCHA` is configured, it will be used.

<a id="verification"></a>

### Verification

The server validates the captcha token via the `verify-smartcaptcha` function,
which `POST`s the token and server key to Yandex's validation endpoint.

Successful validation returns `{"status": "ok"}`.
Failed validation returns `{"status": "error"}`.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FAUTH-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/AUTH

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FAUTH-22-29-20PACKAGE-29"></a>

#### [package](2682) `reblocks-auth/auth`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FAUTH-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FAUTH-3AAUTHENTICATE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](3b33) `reblocks-auth/auth:authenticate` service &rest params &key id first\_name last\_name username photo\_url auth\_date hash retpath code

Called when user had authenticated in the service and returned
to our site.

All `GET` arguments are collected into a plist and passed as params.

Should return two values a user and a flag denotifing if user was just created.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FBUTTON-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/BUTTON

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FBUTTON-22-29-20PACKAGE-29"></a>

#### [package](4933) `reblocks-auth/button`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FBUTTON-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FBUTTON-3ARENDER-20GENERIC-FUNCTION-29"></a>

##### [generic-function](eac1) `reblocks-auth/button:render` service &key retpath

Renders a button for given service.
Service should be a keyword like :github or :facebook.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CONDITIONS

<a id="x-28-23A-28-2824-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCONDITIONS-22-29-20PACKAGE-29"></a>

#### [package](5b0a) `reblocks-auth/conditions`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCONDITIONS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-24UNABLE-TO-AUTHENTICATE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### UNABLE-TO-AUTHENTICATE

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-20CONDITION-29"></a>

###### [condition](5e3e) `reblocks-auth/conditions:unable-to-authenticate` ()

**Readers**

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](5e3e) `reblocks-auth/conditions:get-message` (unable-to-authenticate) (:message)

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-REASON-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](5e3e) `reblocks-auth/conditions:get-reason` (unable-to-authenticate) (:reason = 'nil)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CORE

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCORE-22-29-20PACKAGE-29"></a>

#### [package](010f) `reblocks-auth/core`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-24LOGIN-PROCESSOR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LOGIN-PROCESSOR

<a id="x-28REBLOCKS-AUTH-2FCORE-3ALOGIN-PROCESSOR-20CLASS-29"></a>

###### [class](71ec) `reblocks-auth/core:login-processor` (widget)

This widget should be rendered to process user's login.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-24LOGOUT-PROCESSOR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LOGOUT-PROCESSOR

<a id="x-28REBLOCKS-AUTH-2FCORE-3ALOGOUT-PROCESSOR-20CLASS-29"></a>

###### [class](75be) `reblocks-auth/core:logout-processor` (widget)

This widget should be rendered to process user's logout.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FCORE-3ARENDER-LOGIN-PAGE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](d05b) `reblocks-auth/core:render-login-page` app &key retpath

By default, renders a list of buttons for each allowed authentication method.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGIN-PROCESSOR-20FUNCTION-29"></a>

##### [function](14ea) `reblocks-auth/core:make-login-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGOUT-PROCESSOR-20FUNCTION-29"></a>

##### [function](1523) `reblocks-auth/core:make-logout-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3ARENDER-BUTTONS-20FUNCTION-29"></a>

##### [function](72a9) `reblocks-auth/core:render-buttons` &key retpath

Renders a row of buttons for enabled service providers.

Optionally you can specify `RETPATH` argument with an `URI` to return user
after login.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2AALLOW-NEW-ACCOUNTS-CREATION-2A-20-28VARIABLE-29-29"></a>

##### [variable](9b5b) `reblocks-auth/core:*allow-new-accounts-creation*` t

When True, a new account will be created. Otherwise only already existing users can log in.

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2AENABLED-SERVICES-2A-20-28VARIABLE-29-29"></a>

##### [variable](0951) `reblocks-auth/core:*enabled-services*` (:github)

Set this variable to limit a services available to login through.

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2ALOGIN-HOOKS-2A-20-28VARIABLE-29-29"></a>

##### [variable](5dce) `reblocks-auth/core:*login-hooks*` nil

Append a funcallable handlers which accept single argument - logged user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FERRORS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/ERRORS

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FERRORS-22-29-20PACKAGE-29"></a>

#### [package](3695) `reblocks-auth/errors`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FERRORS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FERRORS-24NICKNAME-IS-NOT-AVAILABLE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### NICKNAME-IS-NOT-AVAILABLE

<a id="x-28REBLOCKS-AUTH-2FERRORS-3ANICKNAME-IS-NOT-AVAILABLE-20CONDITION-29"></a>

###### [condition](31a7) `reblocks-auth/errors:nickname-is-not-available` (error)

Signalled when there is already a user with given nickname.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FGITHUB-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/GITHUB

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FGITHUB-22-29-20PACKAGE-29"></a>

#### [package](e97f) `reblocks-auth/github`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-SCOPES-20FUNCTION-29"></a>

##### [function](7d28) `reblocks-auth/github:get-scopes`

Returns current user's scopes.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-TOKEN-20FUNCTION-29"></a>

##### [function](fa3b) `reblocks-auth/github:get-token`

Returns current user's GitHub token.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3ARENDER-BUTTON-20FUNCTION-29"></a>

##### [function](07e4) `reblocks-auth/github:render-button` &KEY (CLASS "button small") (SCOPES \*DEFAULT-SCOPES\*) (TEXT "Grant permissions") (RETPATH (GET-URI))

Renders a button to request more scopes.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ACLIENT-ID-2A-20-28VARIABLE-29-29"></a>

##### [variable](c10e) `reblocks-auth/github:*client-id*` nil

`OA`uth client id

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ADEFAULT-SCOPES-2A-20-28VARIABLE-29-29"></a>

##### [variable](0597) `reblocks-auth/github:*default-scopes*` ("user:email")

A listo of default scopes to request from GitHub.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ASECRET-2A-20-28VARIABLE-29-29"></a>

##### [variable](5212) `reblocks-auth/github:*secret*` nil

`OA`uth secret. It might be a string or secret-values:secret-value.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/MODELS

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FMODELS-22-29-20PACKAGE-29"></a>

#### [package](1677) `reblocks-auth/models`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24SOCIAL-PROFILE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### SOCIAL-PROFILE

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-20CLASS-29"></a>

###### [class](4113) `reblocks-auth/models:social-profile` (serial-pk-mixin dao-class record-timestamps-mixin)

Represents a User's link to a social service.
User can be bound to multiple social services.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](66ec) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

A hash table with lowercased strings as a key and values given from the authentication plroviders.s

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](985f) `reblocks-auth/models:profile-service` (social-profile) (:service)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-USER-ID-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](9cd0) `reblocks-auth/models:profile-service-user-id` (social-profile) (:service-user-id)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-USER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader] `reblocks-auth/models:profile-user` (social-profile) (:user)

A [`user`][05f7] instance, bound to the [`social-profile`][d9d6].

**Accessors**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [accessor](66ec) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

A hash table with lowercased strings as a key and values given from the authentication plroviders.s

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24USER-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### USER

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AUSER-20CLASS-29"></a>

###### [class](e20a) `reblocks-auth/models:user` (serial-pk-mixin dao-class record-timestamps-mixin)

This class stores basic information about user - it's nickname and email.
Additional information is stored inside [`social-profile`][d9d6] instances.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-EMAIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](a36d) `reblocks-auth/models:get-email` (user) (:email = nil)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-NICKNAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](ede7) `reblocks-auth/models:get-nickname` (user) (:nickname)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AANONYMOUS-P-20FUNCTION-29"></a>

##### [function](5685) `reblocks-auth/models:anonymous-p` user

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-EMAIL-20FUNCTION-29"></a>

##### [function](ea31) `reblocks-auth/models:change-email` user email

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-NICKNAME-20FUNCTION-29"></a>

##### [function](4689) `reblocks-auth/models:change-nickname` new-nickname

Changes nickname of the current user.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACREATE-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](6d5a) `reblocks-auth/models:create-social-user` service service-user-id &rest metadata &key email first-name last-name username photo-url

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AFIND-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](73bf) `reblocks-auth/models:find-social-user` service service-user-id

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-ALL-USERS-20FUNCTION-29"></a>

##### [function](ba6d) `reblocks-auth/models:get-all-users`

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-CURRENT-USER-20FUNCTION-29"></a>

##### [function](d420) `reblocks-auth/models:get-current-user`

Returns current user or `NIL`.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-EMAIL-20FUNCTION-29"></a>

##### [function](0c04) `reblocks-auth/models:get-user-by-email` email

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-NICKNAME-20FUNCTION-29"></a>

##### [function](8efc) `reblocks-auth/models:get-user-by-nickname` nickname

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AUSER-SOCIAL-PROFILES-20FUNCTION-29"></a>

##### [function](950b) `reblocks-auth/models:user-social-profiles` user

Returns a list of social profiles, bound to the user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FMODELS-3A-2AUSER-CLASS-2A-20-28VARIABLE-29-29"></a>

##### [variable](c723) `reblocks-auth/models:*user-class*` user

Allows to redefine a model, for users to be created by the reblocks-auth.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/MAILGUN

<a id="x-28-23A-28-2837-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-22-29-20PACKAGE-29"></a>

#### [package](89b0) `reblocks-auth/providers/email/mailgun`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3ADEFINE-CODE-SENDER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](29aa) `reblocks-auth/providers/email/mailgun:define-code-sender` NAME (FROM-EMAIL URL-VAR &KEY (SUBJECT "Authentication code")) &BODY HTML-TEMPLATE-BODY

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/MODELS

<a id="x-28-23A-28-2836-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-22-29-20PACKAGE-29"></a>

#### [package](d3fc) `reblocks-auth/providers/email/models`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-24REGISTRATION-CODE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### REGISTRATION-CODE

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-20CLASS-29"></a>

###### [class](4c59) `reblocks-auth/providers/email/models:registration-code` (serial-pk-mixin dao-class record-timestamps-mixin)

This model stores a code sent to an email for signup or log in.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](5db3) `reblocks-auth/providers/email/models:registration-code` (registration-code) (:code)

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-EMAIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](aa69) `reblocks-auth/providers/email/models:registration-email` (registration-code) (:email)

User's email.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AVALID-UNTIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](eb9a) `reblocks-auth/providers/email/models:valid-until` (registration-code) (:valid-until)

Expiration time.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3ASEND-CODE-20FUNCTION-29"></a>

##### [function](eeb6) `reblocks-auth/providers/email/models:send-code` email &key retpath send-callback

Usually you should define a global callback using
[`reblocks-auth/providers/email/mailgun:define-code-sender`][f455] macro,
but you can provide an alternative function to handle
email sending.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3A-2ASEND-CODE-CALLBACK-2A-20-28VARIABLE-29-29"></a>

##### [variable](f7ac) `reblocks-auth/providers/email/models:*send-code-callback*` -unbound-

Set this variable to a function of one argument of class [`registration-code`][1573].
It should send a registration code using template, suitable for your website.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING

<a id="x-28-23A-28-2840-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-22-29-20PACKAGE-29"></a>

#### [package](9cfd) `reblocks-auth/providers/email/processing`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-24REQUEST-CODE-FORM-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### REQUEST-CODE-FORM

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-20CLASS-29"></a>

###### [class](2c76) `reblocks-auth/providers/email/processing:request-code-form` (widget)

**Readers**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARETPATH-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [reader](5bec) `reblocks-auth/providers/email/processing:retpath` (request-code-form) (:retpath)

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ASENT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [reader](7dbc) `reblocks-auth/providers/email/processing:sent` (request-code-form) (= nil)

**Accessors**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ASENT-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [accessor](7dbc) `reblocks-auth/providers/email/processing:sent` (request-code-form) (= nil)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AFORM-CSS-CLASSES-20GENERIC-FUNCTION-29"></a>

##### [generic-function](c98c) `reblocks-auth/providers/email/processing:form-css-classes` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-EMAIL-INPUT-20GENERIC-FUNCTION-29"></a>

##### [generic-function](2445) `reblocks-auth/providers/email/processing:render-email-input` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-SENT-MESSAGE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](f0fa) `reblocks-auth/providers/email/processing:render-sent-message` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-SUBMIT-BUTTON-20GENERIC-FUNCTION-29"></a>

##### [generic-function](f120) `reblocks-auth/providers/email/processing:render-submit-button` widget

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ARECAPTCHA-SECRET-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](01a0) `reblocks-auth/providers/email/processing:*recaptcha-secret-key*` nil

Set this variable to a secret key, generated by Google reCaptcha.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ARECAPTCHA-SITE-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](1240) `reblocks-auth/providers/email/processing:*recaptcha-site-key*` nil

Set this variable to a site key, generated by Google reCaptcha.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ASMARTCAPTCHA-CLIENT-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](34a8) `reblocks-auth/providers/email/processing:*smartcaptcha-client-key*` nil

Set this variable to a client key, generated by Yandex SmartCaptcha.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ASMARTCAPTCHA-SERVER-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](cbac) `reblocks-auth/providers/email/processing:*smartcaptcha-server-key*` nil

Set this variable to a server key, generated by Yandex SmartCaptcha.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/RESEND

<a id="x-28-23A-28-2836-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-22-29-20PACKAGE-29"></a>

#### [package](2bac) `reblocks-auth/providers/email/resend`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3AMAKE-CODE-SENDER-20FUNCTION-29"></a>

##### [function](7b15) `reblocks-auth/providers/email/resend:make-code-sender` thunk &key base-uri

Makes a function which will prepare params and call `THUNK` function with email and `URL`.

Usually you don't need to call this function directly and you can use just [`define-code-sender`][fc31] macro.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3ADEFINE-CODE-SENDER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](8f7c) `reblocks-auth/providers/email/resend:define-code-sender` NAME (FROM-EMAIL URL-VAR &KEY (SUBJECT "Authentication code")) &BODY HTML-TEMPLATE-BODY

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/TELEGRAM

<a id="x-28-23A-28-2832-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-22-29-20PACKAGE-29"></a>

#### [package](3d9a) `reblocks-auth/providers/telegram`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3ARENDER-BUTTON-20FUNCTION-29"></a>

##### [function](6dc3) `reblocks-auth/providers/telegram:render-button` &key retpath

Renders the Telegram Login Widget script tag.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3A-2ABOT-TOKEN-2A-20-28VARIABLE-29-29"></a>

##### [variable](5446) `reblocks-auth/providers/telegram:*bot-token*` nil

Telegram bot token used to verify authentication data.
Can be a string or secret-values:secret-value.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3A-2ABOT-USERNAME-2A-20-28VARIABLE-29-29"></a>

##### [variable](e835) `reblocks-auth/providers/telegram:*bot-username*` nil

Telegram bot username (without @). Required for the login widget.

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
[ad5b]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3A-2ABOT-TOKEN-2A-20-28VARIABLE-29-29
[17fb]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3A-2ABOT-USERNAME-2A-20-28VARIABLE-29-29
[5f0d]: https://40ants.com/reblocks-navigation-widget/#x-28REBLOCKS-NAVIGATION-WIDGET-3ADEFROUTES-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29
[8100]: https://console.cloud.yandex.com/
[062e]: https://core.telegram.org/widgets/login
[1668]: https://github.com/40ants/reblocks-auth
[2ba2]: https://github.com/40ants/reblocks-auth/actions
[2682]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/auth.lisp#L1
[3b33]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/auth.lisp#L8
[4933]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/button.lisp#L1
[eac1]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/button.lisp#L10
[5b0a]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/conditions.lisp#L1
[5e3e]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/conditions.lisp#L10
[010f]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/core.lisp#L1
[d05b]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/core.lisp#L143
[0951]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/core.lisp#L43
[5dce]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/core.lisp#L47
[9b5b]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/core.lisp#L51
[71ec]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/core.lisp#L55
[75be]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/core.lisp#L60
[14ea]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/core.lisp#L65
[1523]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/core.lisp#L69
[72a9]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/core.lisp#L80
[3695]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/errors.lisp#L1
[31a7]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/errors.lisp#L7
[e97f]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/github.lisp#L1
[fa3b]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/github.lisp#L144
[7d28]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/github.lisp#L149
[c10e]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/github.lisp#L36
[5212]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/github.lisp#L40
[0597]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/github.lisp#L44
[07e4]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/github.lisp#L82
[1677]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L1
[9cd0]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L102
[66ec]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L105
[ba6d]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L132
[73bf]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L136
[6d5a]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L145
[d420]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L185
[950b]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L191
[5685]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L204
[0c04]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L208
[8efc]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L213
[4689]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L218
[ea31]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L232
[e20a]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L39
[ede7]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L40
[a36d]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L46
[c723]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L57
[4113]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L87
[985f]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/models.lisp#L96
[89b0]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/mailgun.lisp#L1
[29aa]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/mailgun.lisp#L44
[d3fc]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/models.lisp#L1
[f7ac]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/models.lisp#L21
[4c59]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/models.lisp#L43
[aa69]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/models.lisp#L44
[5db3]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/models.lisp#L48
[eb9a]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/models.lisp#L52
[eeb6]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/models.lisp#L78
[9cfd]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L1
[f0fa]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L230
[2445]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L246
[f120]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L254
[c98c]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L262
[1240]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L50
[01a0]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L53
[34a8]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L56
[cbac]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L59
[2c76]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L66
[5bec]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L67
[7dbc]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/processing.lisp#L69
[2bac]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/resend.lisp#L1
[7b15]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/resend.lisp#L16
[8f7c]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/email/resend.lisp#L44
[3d9a]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/telegram.lisp#L1
[e835]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/telegram.lisp#L28
[5446]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/telegram.lisp#L31
[6dc3]: https://github.com/40ants/reblocks-auth/blob/5a023c9ffc5041e7574e01be200c39a38cd6aa04/src/providers/telegram.lisp#L64
[4f85]: https://github.com/40ants/reblocks-auth/issues
[c7c4]: https://github.com/fukamachi/mito
[8236]: https://quickdocs.org/alexandria
[3a1f]: https://quickdocs.org/babel
[2ecb]: https://quickdocs.org/cl-strings
[8347]: https://quickdocs.org/dexador
[90b9]: https://quickdocs.org/ironclad
[6dd8]: https://quickdocs.org/jonathan
[46a1]: https://quickdocs.org/local-time
[7f8b]: https://quickdocs.org/log4cl
[691c]: https://quickdocs.org/log4cl-extras
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
[fecf]: https://t.me/BotFather

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
