<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-40CHANGELOG-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# ChangeLog

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E11-2E1-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.11.1 (2025-02-15)

<a id="fixed"></a>

### Fixed

* Email provider form rendering was fixed to work with Reblocks changes introduced in [PR57][fff6].

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E11-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.11.0 (2023-12-18)

<a id="added"></a>

### Added

* [`reblocks-auth/core:render-login-page`][5588] generic-function was added allowing to make a custom.
  Widget class [`reblocks-auth/providers/email/processing:request-code-form`][a366], [`reblocks-auth/providers/email/processing:render-submit-button`][1fdc] generic-function, [`reblocks-auth/providers/email/processing:render-email-input`][fc5a] generic-function, [`reblocks-auth/providers/email/processing:form-css-classes`][11c6] generic-function and [`reblocks-auth/providers/email/processing:render-sent-message`][e8ad] generic-function were added to allow login page customizations.
* Added [`reblocks-auth/core:*allow-new-accounts-creation*`][89ea] variable to control if new accounts can be registered.
* Added [`reblocks-auth/models:*user-class*`][9da0] variable. This allows to make a custom user model with additional fields.

<a id="changed"></a>

### Changed

* Now when user authenticates using email, we fill email column.
* Function [`reblocks-auth/providers/email/models:send-code`][0ce2] now accepts `SEND-CALLBACK` argument. This argument can be used when you need to send login code with a custom email markup. For example, this way a special welcome email can be sent when a new user was added by a site admin.
* Function [`reblocks-auth/providers/email/resend:make-code-sender`][4fbd] now accepts additional argument `BASE-URI`.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E10-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.10.0 (2023-10-22)

Experimental reCaptcha support was added into email provider.

Set [`reblocks-auth/providers/email/processing:*recaptcha-site-key*`][c547]
and [`reblocks-auth/providers/email/processing:*recaptcha-secret-key*`][6c07]
variables to try it.

Note: this version requires a new Reblocks, where was added get-remote-ip function.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E9-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.9.0 (2023-10-01)

Email authentication provider now is able to use Resend `API`. Load `reblocks-auth/providers/email/resend` `ASDF` system to enable this feature.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E8-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.8.0 (2023-08-04)

New authentication provider was added. It will send an authentication `URL` to user's email.

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
(define-code-sender send-code ("Ultralisp.org <noreply@ultralisp.org>" url)
  (:p ("To log into [Ultralisp.org](~A), follow [this link](~A)."
       url
       url))
  (:p "Hurry up! This link will expire in one hour."))
```
Here is how to provide credentials to make sending work:

```
(setf mailgun:*domain* "mg.ultralisp.org")

(setf mailgun:*api-key*
      (secret-values:conceal-value
       "********************************-*********-*********"))
```
To supply an alternative sending method, define a function of two arguments: email and url.
Set [`reblocks-auth/providers/email/models:*send-code-callback*`][342f] variable to the value
of this function.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E7-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.7.0 (2022-06-07)

* Added documentation and an example application.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E6-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.6.0 (2021-01-24)

* Added support for `secret-values` in [`reblocks-auth/github:*secret*`][d659].

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E5-2E1-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.5.1 (2019-06-24)

* Supported recent change [of mito][fd4e]
caused an error when searching a social user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E5-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.5.0 (2019-06-22)

* Added a [`reblocks-auth/models:change-email`][f951] function.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E4-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.4.0 (2019-06-20)

* Added a new variable [`reblocks-auth/core:*login-hooks*`][0e88].
* A variable [`reblocks-auth/core:*enabled-services*`][ac4c] was exported.
* A function [`reblocks-auth/core:render-buttons`][69ac] was exported.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E3-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.3.0 (2019-04-18)

* Now classes [`reblocks-auth/models:user`][05f7] and [`reblocks-auth/models:social-profile`][d9d6] are exported from `reblocks-auth/models` system.
* New function were added: [`reblocks-auth/models:get-user-by-email`][85b4] and [`reblocks-auth/models:get-user-by-nickname`][6ced].

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E2-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.2.0 (2019-04-17)

* Now only `user:email` scope is required for authentication
  via github.
* And [`reblocks-auth/github:render-button`][b194], [`reblocks-auth/github:get-scopes`][e605]
  functions was added to request more scopes if required.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E1-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.1.0 (2019-03-31)

* First version with GitHub authentication.


[89ea]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3A-2AALLOW-NEW-ACCOUNTS-CREATION-2A-20-28VARIABLE-29-29
[ac4c]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3A-2AENABLED-SERVICES-2A-20-28VARIABLE-29-29
[0e88]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3A-2ALOGIN-HOOKS-2A-20-28VARIABLE-29-29
[69ac]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3ARENDER-BUTTONS-20FUNCTION-29
[5588]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3ARENDER-LOGIN-PAGE-20GENERIC-FUNCTION-29
[d659]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FGITHUB-3A-2ASECRET-2A-20-28VARIABLE-29-29
[e605]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FGITHUB-3AGET-SCOPES-20FUNCTION-29
[b194]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FGITHUB-3ARENDER-BUTTON-20FUNCTION-29
[9da0]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3A-2AUSER-CLASS-2A-20-28VARIABLE-29-29
[f951]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-EMAIL-20FUNCTION-29
[85b4]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-EMAIL-20FUNCTION-29
[6ced]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-NICKNAME-20FUNCTION-29
[d9d6]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-20CLASS-29
[05f7]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3AUSER-20CLASS-29
[342f]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3A-2ASEND-CODE-CALLBACK-2A-20-28VARIABLE-29-29
[0ce2]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FMODELS-3ASEND-CODE-20FUNCTION-29
[6c07]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ARECAPTCHA-SECRET-KEY-2A-20-28VARIABLE-29-29
[c547]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3A-2ARECAPTCHA-SITE-KEY-2A-20-28VARIABLE-29-29
[11c6]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AFORM-CSS-CLASSES-20GENERIC-FUNCTION-29
[fc5a]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-EMAIL-INPUT-20GENERIC-FUNCTION-29
[e8ad]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-SENT-MESSAGE-20GENERIC-FUNCTION-29
[1fdc]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3ARENDER-SUBMIT-BUTTON-20GENERIC-FUNCTION-29
[a366]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FPROCESSING-3AREQUEST-CODE-FORM-20CLASS-29
[4fbd]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FPROVIDERS-2FEMAIL-2FRESEND-3AMAKE-CODE-SENDER-20FUNCTION-29
[fff6]: https://github.com/40ants/reblocks/pull/57
[fd4e]: https://github.com/fukamachi/mito/commit/be0ea57df921aa1beb2045b50a8c2e2e4f8b8955

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
