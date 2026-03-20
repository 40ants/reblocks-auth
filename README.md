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

#### [package](0581) `reblocks-auth/auth`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FAUTH-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FAUTH-3AAUTHENTICATE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](6015) `reblocks-auth/auth:authenticate` service &rest params &key id first\_name last\_name username photo\_url auth\_date hash retpath code

Called when user had authenticated in the service and returned
to our site.

All `GET` arguments are collected into a plist and passed as params.

Should return two values a user and a flag denotifing if user was just created.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FBUTTON-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/BUTTON

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FBUTTON-22-29-20PACKAGE-29"></a>

#### [package](c1b8) `reblocks-auth/button`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FBUTTON-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FBUTTON-3ARENDER-20GENERIC-FUNCTION-29"></a>

##### [generic-function](b152) `reblocks-auth/button:render` service &key retpath

Renders a button for given service.
Service should be a keyword like :github or :facebook.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CONDITIONS

<a id="x-28-23A-28-2824-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCONDITIONS-22-29-20PACKAGE-29"></a>

#### [package](edb7) `reblocks-auth/conditions`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCONDITIONS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCONDITIONS-24UNABLE-TO-AUTHENTICATE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### UNABLE-TO-AUTHENTICATE

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-20CONDITION-29"></a>

###### [condition](5529) `reblocks-auth/conditions:unable-to-authenticate` ()

**Readers**

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](5529) `reblocks-auth/conditions:get-message` (unable-to-authenticate) (:message)

<a id="x-28REBLOCKS-AUTH-2FCONDITIONS-3AGET-REASON-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FCONDITIONS-3AUNABLE-TO-AUTHENTICATE-29-29"></a>

###### [reader](5529) `reblocks-auth/conditions:get-reason` (unable-to-authenticate) (:reason = 'nil)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/CORE

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FCORE-22-29-20PACKAGE-29"></a>

#### [package](cccd) `reblocks-auth/core`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-24LOGIN-PROCESSOR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LOGIN-PROCESSOR

<a id="x-28REBLOCKS-AUTH-2FCORE-3ALOGIN-PROCESSOR-20CLASS-29"></a>

###### [class](1784) `reblocks-auth/core:login-processor` (widget)

This widget should be rendered to process user's login.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FCORE-24LOGOUT-PROCESSOR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LOGOUT-PROCESSOR

<a id="x-28REBLOCKS-AUTH-2FCORE-3ALOGOUT-PROCESSOR-20CLASS-29"></a>

###### [class](0f9f) `reblocks-auth/core:logout-processor` (widget)

This widget should be rendered to process user's logout.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FCORE-3ARENDER-LOGIN-PAGE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](50d4) `reblocks-auth/core:render-login-page` app &key retpath

By default, renders a list of buttons for each allowed authentication method.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGIN-PROCESSOR-20FUNCTION-29"></a>

##### [function](bb71) `reblocks-auth/core:make-login-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3AMAKE-LOGOUT-PROCESSOR-20FUNCTION-29"></a>

##### [function](8cc5) `reblocks-auth/core:make-logout-processor`

<a id="x-28REBLOCKS-AUTH-2FCORE-3ARENDER-BUTTONS-20FUNCTION-29"></a>

##### [function](e5a1) `reblocks-auth/core:render-buttons` &key (retpath (get-path))

Renders a row of buttons for enabled service providers.

Optionally you can specify `RETPATH` argument with an `URI` to return user
after login.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FCORE-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2AALLOW-NEW-ACCOUNTS-CREATION-2A-20-28VARIABLE-29-29"></a>

##### [variable](0f49) `reblocks-auth/core:*allow-new-accounts-creation*` t

When True, a new account will be created. Otherwise only already existing users can log in.

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2AENABLED-SERVICES-2A-20-28VARIABLE-29-29"></a>

##### [variable](9d92) `reblocks-auth/core:*enabled-services*` (:github)

Set this variable to limit a services available to login through.

<a id="x-28REBLOCKS-AUTH-2FCORE-3A-2ALOGIN-HOOKS-2A-20-28VARIABLE-29-29"></a>

##### [variable](85b3) `reblocks-auth/core:*login-hooks*` nil

Append a funcallable handlers which accept single argument - logged user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FERRORS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/ERRORS

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FERRORS-22-29-20PACKAGE-29"></a>

#### [package](2b66) `reblocks-auth/errors`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FERRORS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FERRORS-24NICKNAME-IS-NOT-AVAILABLE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### NICKNAME-IS-NOT-AVAILABLE

<a id="x-28REBLOCKS-AUTH-2FERRORS-3ANICKNAME-IS-NOT-AVAILABLE-20CONDITION-29"></a>

###### [condition](1377) `reblocks-auth/errors:nickname-is-not-available` (error)

Signalled when there is already a user with given nickname.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FGITHUB-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/GITHUB

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FGITHUB-22-29-20PACKAGE-29"></a>

#### [package](036a) `reblocks-auth/github`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-SCOPES-20FUNCTION-29"></a>

##### [function](7ce8) `reblocks-auth/github:get-scopes`

Returns current user's scopes.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3AGET-TOKEN-20FUNCTION-29"></a>

##### [function](c9c4) `reblocks-auth/github:get-token`

Returns current user's GitHub token.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3ARENDER-BUTTON-20FUNCTION-29"></a>

##### [function](fdf4) `reblocks-auth/github:render-button` &KEY (CLASS "button small") (SCOPES \*DEFAULT-SCOPES\*) (TEXT "Grant permissions") (RETPATH (GET-URI))

Renders a button to request more scopes.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FGITHUB-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ACLIENT-ID-2A-20-28VARIABLE-29-29"></a>

##### [variable](7d39) `reblocks-auth/github:*client-id*` nil

`OA`uth client id

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ADEFAULT-SCOPES-2A-20-28VARIABLE-29-29"></a>

##### [variable](cb73) `reblocks-auth/github:*default-scopes*` ("user:email")

A listo of default scopes to request from GitHub.

<a id="x-28REBLOCKS-AUTH-2FGITHUB-3A-2ASECRET-2A-20-28VARIABLE-29-29"></a>

##### [variable](90a6) `reblocks-auth/github:*secret*` nil

`OA`uth secret. It might be a string or secret-values:secret-value.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/MODELS

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FMODELS-22-29-20PACKAGE-29"></a>

#### [package](a663) `reblocks-auth/models`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24SOCIAL-PROFILE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### SOCIAL-PROFILE

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-20CLASS-29"></a>

###### [class](b502) `reblocks-auth/models:social-profile` (serial-pk-mixin dao-class record-timestamps-mixin)

Represents a User's link to a social service.
User can be bound to multiple social services.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](1cbc) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

A hash table with lowercased strings as a key and values given from the authentication plroviders.s

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](f523) `reblocks-auth/models:profile-service` (social-profile) (:service)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-SERVICE-USER-ID-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader](d1da) `reblocks-auth/models:profile-service-user-id` (social-profile) (:service-user-id)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-USER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [reader] `reblocks-auth/models:profile-user` (social-profile) (:user)

A [`user`][05f7] instance, bound to the [`social-profile`][d9d6].

**Accessors**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3APROFILE-METADATA-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-29-29"></a>

###### [accessor](1cbc) `reblocks-auth/models:profile-metadata` (social-profile) (:metadata :params)

A hash table with lowercased strings as a key and values given from the authentication plroviders.s

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FMODELS-24USER-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### USER

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AUSER-20CLASS-29"></a>

###### [class](8fc9) `reblocks-auth/models:user` (serial-pk-mixin dao-class record-timestamps-mixin)

This class stores basic information about user - it's nickname and email.
Additional information is stored inside [`social-profile`][d9d6] instances.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-EMAIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](69ec) `reblocks-auth/models:get-email` (user) (:email = nil)

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-NICKNAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FMODELS-3AUSER-29-29"></a>

###### [reader](83c8) `reblocks-auth/models:get-nickname` (user) (:nickname)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AANONYMOUS-P-20FUNCTION-29"></a>

##### [function](a2a8) `reblocks-auth/models:anonymous-p` user

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-EMAIL-20FUNCTION-29"></a>

##### [function](b39f) `reblocks-auth/models:change-email` user email

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-NICKNAME-20FUNCTION-29"></a>

##### [function](04cc) `reblocks-auth/models:change-nickname` new-nickname

Changes nickname of the current user.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3ACREATE-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](d03f) `reblocks-auth/models:create-social-user` service service-user-id &rest kwargs &key email first-name last-name username photo-url

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AFIND-SOCIAL-USER-20FUNCTION-29"></a>

##### [function](4dd4) `reblocks-auth/models:find-social-user` service service-user-id

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-ALL-USERS-20FUNCTION-29"></a>

##### [function](d3d1) `reblocks-auth/models:get-all-users`

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-CURRENT-USER-20FUNCTION-29"></a>

##### [function](c26c) `reblocks-auth/models:get-current-user`

Returns current user or `NIL`.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-EMAIL-20FUNCTION-29"></a>

##### [function](2e03) `reblocks-auth/models:get-user-by-email` email

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-NICKNAME-20FUNCTION-29"></a>

##### [function](48bc) `reblocks-auth/models:get-user-by-nickname` nickname

Returns a user with given email.

<a id="x-28REBLOCKS-AUTH-2FMODELS-3AUSER-SOCIAL-PROFILES-20FUNCTION-29"></a>

##### [function](7d3e) `reblocks-auth/models:user-social-profiles` user

Returns a list of social profiles, bound to the user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FMODELS-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FMODELS-3A-2AUSER-CLASS-2A-20-28VARIABLE-29-29"></a>

##### [variable](5a03) `reblocks-auth/models:*user-class*` user

Allows to redefine a model, for users to be created by the reblocks-auth.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/MAILGUN

<a id="x-28-23A-28-2837-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-22-29-20PACKAGE-29"></a>

#### [package](f9eb) `reblocks-auth/providers/email/mailgun`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMAILGUN-3ADEFINE-CODE-SENDER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](a6fd) `reblocks-auth/providers/email/mailgun:define-code-sender` NAME (FROM-EMAIL URL-VAR &KEY (SUBJECT "Authentication code")) &BODY HTML-TEMPLATE-BODY

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/MODELS

<a id="x-28-23A-28-2836-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-22-29-20PACKAGE-29"></a>

#### [package](b94c) `reblocks-auth/providers/email/models`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-24REGISTRATION-CODE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### REGISTRATION-CODE

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-20CLASS-29"></a>

###### [class](6cf4) `reblocks-auth/providers/email/models:registration-code` (serial-pk-mixin dao-class record-timestamps-mixin)

This model stores a code sent to an email for signup or log in.

**Readers**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](50a1) `reblocks-auth/providers/email/models:registration-code` (registration-code) (:code)

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-EMAIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](74dd) `reblocks-auth/providers/email/models:registration-email` (registration-code) (:email)

User's email.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AVALID-UNTIL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3AREGISTRATION-CODE-29-29"></a>

###### [reader](3dea) `reblocks-auth/providers/email/models:valid-until` (registration-code) (:valid-until)

Expiration time.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3ASEND-CODE-20FUNCTION-29"></a>

##### [function](11c8) `reblocks-auth/providers/email/models:send-code` email &key retpath send-callback

Usually you should define a global callback using
[`reblocks-auth/providers/email/mailgun:define-code-sender`][f455] macro,
but you can provide an alternative function to handle
email sending.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3A-2ASEND-CODE-CALLBACK-2A-20-28VARIABLE-29-29"></a>

##### [variable](a4c8) `reblocks-auth/providers/email/models:*send-code-callback*` -unbound-

Set this variable to a function of one argument of class [`registration-code`][1573].
It should send a registration code using template, suitable for your website.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/PROCESSING

<a id="x-28-23A-28-2840-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-22-29-20PACKAGE-29"></a>

#### [package](d544) `reblocks-auth/providers/email/processing`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-24REQUEST-CODE-FORM-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### REQUEST-CODE-FORM

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-20CLASS-29"></a>

###### [class](5009) `reblocks-auth/providers/email/processing:request-code-form` (widget)

**Readers**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARETPATH-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [reader](0718) `reblocks-auth/providers/email/processing:retpath` (request-code-form) (:retpath)

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ASENT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [reader](c330) `reblocks-auth/providers/email/processing:sent` (request-code-form) (= nil)

**Accessors**

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ASENT-20-2840ANTS-DOC-2FLOCATIVES-3AACCESSOR-20REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-29-29"></a>

###### [accessor](c330) `reblocks-auth/providers/email/processing:sent` (request-code-form) (= nil)

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AFORM-CSS-CLASSES-20GENERIC-FUNCTION-29"></a>

##### [generic-function](8599) `reblocks-auth/providers/email/processing:form-css-classes` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-EMAIL-INPUT-20GENERIC-FUNCTION-29"></a>

##### [generic-function](9c4f) `reblocks-auth/providers/email/processing:render-email-input` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-SENT-MESSAGE-20GENERIC-FUNCTION-29"></a>

##### [generic-function](0c01) `reblocks-auth/providers/email/processing:render-sent-message` widget

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-SUBMIT-BUTTON-20GENERIC-FUNCTION-29"></a>

##### [generic-function](f07b) `reblocks-auth/providers/email/processing:render-submit-button` widget

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ARECAPTCHA-SECRET-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](abcf) `reblocks-auth/providers/email/processing:*recaptcha-secret-key*` nil

Set this variable to a secret key, generated by Google reCaptcha.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ARECAPTCHA-SITE-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](b9e7) `reblocks-auth/providers/email/processing:*recaptcha-site-key*` nil

Set this variable to a site key, generated by Google reCaptcha.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ASMARTCAPTCHA-CLIENT-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](a975) `reblocks-auth/providers/email/processing:*smartcaptcha-client-key*` nil

Set this variable to a client key, generated by Yandex SmartCaptcha.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ASMARTCAPTCHA-SERVER-KEY-2A-20-28VARIABLE-29-29"></a>

##### [variable](94b4) `reblocks-auth/providers/email/processing:*smartcaptcha-server-key*` nil

Set this variable to a server key, generated by Yandex SmartCaptcha.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/EMAIL/RESEND

<a id="x-28-23A-28-2836-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-22-29-20PACKAGE-29"></a>

#### [package](d178) `reblocks-auth/providers/email/resend`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3AMAKE-CODE-SENDER-20FUNCTION-29"></a>

##### [function](db97) `reblocks-auth/providers/email/resend:make-code-sender` thunk &key base-uri

Makes a function which will prepare params and call `THUNK` function with email and `URL`.

Usually you don't need to call this function directly and you can use just [`define-code-sender`][fc31] macro.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3ADEFINE-CODE-SENDER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](ffa3) `reblocks-auth/providers/email/resend:define-code-sender` NAME (FROM-EMAIL URL-VAR &KEY (SUBJECT "Authentication code")) &BODY HTML-TEMPLATE-BODY

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-40REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-AUTH/PROVIDERS/TELEGRAM

<a id="x-28-23A-28-2832-29-20BASE-CHAR-20-2E-20-22REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-22-29-20PACKAGE-29"></a>

#### [package](af4f) `reblocks-auth/providers/telegram`

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3ARENDER-BUTTON-20FUNCTION-29"></a>

##### [function](d1ac) `reblocks-auth/providers/telegram:render-button` &key retpath

Renders the Telegram Login Widget script tag.

<a id="x-28REBLOCKS-AUTH-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3FVariables-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Variables

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3A-2ABOT-TOKEN-2A-20-28VARIABLE-29-29"></a>

##### [variable](f9c9) `reblocks-auth/providers/telegram:*bot-token*` nil

Telegram bot token used to verify authentication data.
Can be a string or secret-values:secret-value.

<a id="x-28REBLOCKS-AUTH-2FPROVIDERS-2FTELEGRAM-3A-2ABOT-USERNAME-2A-20-28VARIABLE-29-29"></a>

##### [variable](d310) `reblocks-auth/providers/telegram:*bot-username*` nil

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
[0581]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/auth.lisp#L1
[6015]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/auth.lisp#L8
[c1b8]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/button.lisp#L1
[b152]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/button.lisp#L10
[edb7]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/conditions.lisp#L1
[5529]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/conditions.lisp#L10
[cccd]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/core.lisp#L1
[50d4]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/core.lisp#L147
[9d92]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/core.lisp#L46
[85b3]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/core.lisp#L50
[0f49]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/core.lisp#L54
[1784]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/core.lisp#L58
[0f9f]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/core.lisp#L63
[bb71]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/core.lisp#L68
[8cc5]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/core.lisp#L72
[e5a1]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/core.lisp#L83
[2b66]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/errors.lisp#L1
[1377]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/errors.lisp#L7
[036a]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/github.lisp#L1
[c9c4]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/github.lisp#L144
[7ce8]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/github.lisp#L149
[7d39]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/github.lisp#L36
[90a6]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/github.lisp#L40
[cb73]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/github.lisp#L44
[fdf4]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/github.lisp#L82
[a663]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L1
[d1da]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L102
[1cbc]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L105
[d3d1]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L132
[4dd4]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L136
[d03f]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L145
[c26c]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L190
[7d3e]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L196
[a2a8]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L209
[2e03]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L213
[48bc]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L218
[04cc]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L223
[b39f]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L237
[8fc9]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L39
[83c8]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L40
[69ec]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L46
[5a03]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L57
[b502]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L87
[f523]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/models.lisp#L96
[f9eb]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/mailgun.lisp#L1
[a6fd]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/mailgun.lisp#L44
[b94c]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/models.lisp#L1
[a4c8]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/models.lisp#L21
[6cf4]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/models.lisp#L43
[74dd]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/models.lisp#L44
[50a1]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/models.lisp#L48
[3dea]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/models.lisp#L52
[11c8]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/models.lisp#L78
[d544]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L1
[0c01]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L230
[9c4f]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L246
[f07b]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L254
[8599]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L262
[b9e7]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L50
[abcf]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L53
[a975]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L56
[94b4]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L59
[5009]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L66
[0718]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L67
[c330]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/processing.lisp#L69
[d178]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/resend.lisp#L1
[db97]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/resend.lisp#L16
[ffa3]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/email/resend.lisp#L44
[af4f]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/telegram.lisp#L1
[d310]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/telegram.lisp#L28
[f9c9]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/telegram.lisp#L31
[d1ac]: https://github.com/40ants/reblocks-auth/blob/91135821d9ff611fef0d1386299ce4344e85421b/src/providers/telegram.lisp#L64
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
