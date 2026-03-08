# Professional Common Lisp Style

You are a professional Common Lisp programmer. Use best practices, build clear abstractions (including with macros), and write idiomatic code consistent with this project.

## Architecture Overview

Reblocks-auth is a authentication system for Reblocks-based web applications. It provides a pluggable architecture for multiple authentication providers (GitHub, Email, etc.) with support for OAuth flows and email-based authentication with optional reCAPTCHA protection.

### Core Components

- **`src/core.lisp`** - Main entry point with widget processors
  - `login-processor` widget - Handles login requests from authentication providers
  - `logout-processor` widget - Handles logout by clearing session
  - `render-buttons` - Renders login buttons for all enabled services
  - `*enabled-services*` - List of enabled auth providers (default: `:github`)
  - `*login-hooks*` - Hooks executed after successful login
  - `*allow-new-accounts-creation*` - Control whether new accounts can be created

- **`src/auth.lisp`** - Authentication protocol
  - `authenticate` generic function - Extensible protocol for authentication providers
  - Returns: `(values user created-p)` where `created-p` is T if user was just created
  - Each provider implements method for their service keyword (`:github`, `:email`, etc.)

- **`src/button.lisp`** - Button rendering protocol
  - `render` generic function - Renders login button for each provider
  - Service should be a keyword like `:github` or `:email`

### Data Models (`src/models.lisp`)

Uses Mito ORM with two primary models:

- **`user` class** - Basic user information
  - Slots: `nickname` (text, unique), `email` (varchar 255, nullable, unique)
  - Metaclass: `mito:dao-table-class`
  - Customizable via `*user-class*` variable
  - Functions: `get-current-user`, `get-user-by-email`, `get-user-by-nickname`, `change-nickname`, `change-email`, `anonymous-p`, `user-social-profiles`

- **`social-profile` class** - Links users to external services
  - Slots: `user` (foreign key), `service` (text, inflates to keyword), `service-user-id` (text), `metadata` (jsonb)
  - Unique constraint: `(user-id service service-user-id)`
  - Functions: `find-social-user`, `create-social-user`

### Authentication Providers

#### GitHub Provider (`src/github.lisp`)

OAuth 2.0 integration with GitHub:
- `*client-id*` - OAuth client ID
- `*secret*` - OAuth secret (can be `secret-values:secret-value`)
- `*default-scopes*` - Default scopes to request (default: `"user:email"`)
- `render-button` - Renders "Grant permissions" button with OAuth flow
- `get-token` / `get-scopes` - Retrieve current user's GitHub token and scopes
- Flow: Redirect to GitHub → User approves → Exchange code for token → Fetch user info → Create/find user

#### Email Provider (`src/providers/email/`)

Email-based authentication with code verification:

**`models.lisp`** - Email authentication data
- `registration-code` class - Stores temporary auth codes
  - Slots: `email` (varchar 255), `code` (varchar 255), `valid-until` (timestamp)
  - Functions: `make-registration-code`, `send-code`, `check-registration-code`
  - `*code-ttl*` - Time to live for auth codes (default: 1 hour)
  - `*send-code-callback*` - Custom callback for sending emails

**`processing.lisp`** - Form processing with reCAPTCHA support
- `request-code-form` widget - Form to request auth code via email
- `request-code-form-for-popup` - Popup version of the form
- `verify-recaptcha` - Verifies Google reCAPTCHA tokens
   - POST to `https://www.google.com/recaptcha/api/siteverify`
   - Checks `*recaptcha-secret-key*` for verification
- `verify-smartcaptcha` - Verifies Yandex SmartCaptcha tokens
   - POST to `https://smartcaptcha.yandexcloud.net/validate`
   - Checks `*smartcaptcha-server-key*` for verification
- `*recaptcha-site-key*` - Google reCAPTCHA site key (v2/v3)
- `*recaptcha-secret-key*` - Google reCAPTCHA secret key
- `*smartcaptcha-client-key*` - Yandex SmartCaptcha client key
- `*smartcaptcha-server-key*` - Yandex SmartCaptcha server key
- Recaptcha verification flow:
  1. Client calls `grecaptcha.execute()` with site key and action
  2. Token is included in form submission
  3. Server verifies token via Google API with secret key
  4. Authentication proceeds only if verification succeeds
- SmartCaptcha verification flow:
  1. Client loads `https://smartcaptcha.yandexcloud.net/captcha.js`
  2. Client calls `smartcaptcha.execute(clientKey)` which returns token Promise
  3. Token is included in form submission as `captcha-token`
  4. Server verifies token via Yandex API with server key
  5. Response: `{"status": "ok"}` on success, `{"status": "error"}` on failure
  6. Authentication proceeds only if verification succeeds
- Yandex SmartCaptcha takes precedence when both are configured
- Condition: `new-accounts-are-prohibited` - Signaled when account creation is disabled
- Flow: User enters email → (Optional: captcha verify) → Code sent → User clicks link → Authenticated

**`mailgun.lisp` / `resend.lisp`** - Email sending backends
- `define-code-sender` macro - Defines email template for auth codes
- Parameters: `from-email`, `url-var`, `subject` (default: "Authentication code")
- Generates HTML email body with authentication link

### Session Management

- Uses Reblocks session to store authenticated user
- `get-current-user` / `(setf get-current-user)` - Session accessors
- GitHub token and scopes stored separately in session
- `anonymous-p` - Check if user is not authenticated

### Error Handling

**`src/conditions.lisp`** - General authentication conditions
- `unable-to-authenticate` - Generic auth failure with message and reason slots

**`src/errors.lisp`** - User-related errors
- `nickname-is-not-available` - Raised when nickname already exists

**Email provider conditions** (`src/providers/email/models.lisp`)
- `code-unknown` - Registration code not found in database
- `code-expired` - Registration code has passed `valid-until` timestamp

### Utilities (`src/utils.lisp`)

- `keywordify` - Convert string to keyword (uppercase)
- `to-plist` - Convert alist to plist with optional key filtering

### Authentication Flow Diagram

```
User → Login Page → Click Provider Button
   ├─ GitHub: Redirect → GitHub OAuth → Auth Page → Redirect with code → authenticate(:github) → User created/found → Session stored
   └─ Email: Enter email → (Optional: SmartCaptcha/reCAPTCHA verify) → send-code() → Email with link → Click link → authenticate(:email, code=...) → User created/found → Session stored
```

### Integration Pattern

```lisp
;; Setup
(setf reblocks-auth:*enabled-services* '(:github :email))

;; Google reCAPTCHA
(setf reblocks-auth/providers/email/processing:*recaptcha-secret-key* "...")
(setf reblocks-auth/providers/email/processing:*recaptcha-site-key* "...")

;; Yandex SmartCaptcha (takes precedence)
(setf reblocks-auth/providers/email/processing:*smartcaptcha-client-key* "...")
(setf reblocks-auth/providers/email/processing:*smartcaptcha-server-key* "...")

;; Define routes
(defroutes routes
  ("/login" (reblocks-auth:make-login-processor))
  ("/logout" (reblocks-auth:make-logout-processor)))

;; Check current user
(let ((user (reblocks-auth/models:get-current-user)))
  (if user
      (reblocks-auth/models:get-nickname user)
      "Anonymous"))

;; Email sending template
(reblocks-auth/providers/email/resend:define-code-sender send-code 
  ("noreply@example.com" url :subject "Your login code")
  (:p "Click this link to login:")
  (:a :href url (:code url)))
```

## Packages and files

- Use package-inferred ASDF system style to specify dependencies between files - each file should have its own package.
- Define packages with `uiop:define-package`, explicit `:use #:cl`, and `#:` for package names.
- If there are many symbols used.
- Prefer to use `:local-nicknames` instead of `:use` or `:import-from`.
- For external symbols used very often, add `:import-from` to import them.
- List `:export` explicitly.
- Do not export symbols which should not be used by end-users of the library.
- Do not try to edit files inside `.qlot` directory - they are third-party dependencies.


## Types and declarations

- Use `serapeum/types` `->` for function type declarations when the package is available.
- Prefer `(declare (ignore var))` for unused parameters in methods/lambdas.

## Control flow and iteration

- Use `loop` without keyword style (`while`, `do`, `finally`, `repeat`, `for`) for iteration.
- Use `ecase` / `etypecase` for exhaustive dispatch; signal clear errors with `format` (e.g. `"Unknown TL constructor ID: #x~8,'0X"`).

## Abstractions and macros

- Prefer defining macros for repetitive or boilerplate-heavy patterns (e.g. `define-tl-type`, `define-tl-method`).
- Keep macros small and readable; generate code that matches the project's existing style.
- Use `defgeneric` / `defmethod` for polymorphic behavior; document with `:documentation`.

## Error handling and conditions

- Use `define-condition` with slots and `:report` for project-specific errors (e.g. `rpc-error`, `security-error`).
- Use `error` with a format string and arguments rather than raw strings.

## Style alignment with this project

- Prefer `defun`/`defgeneric`/`defmethod` with type declarations where used in the codebase.
- Use `let`/`let*` for locals; use `shiftf` and `mod` where they clarify numeric logic.
- Prefer explicit slot accessors with `:initarg` keywords; use `defclass` with `:reader`/`:accessor` as in the project.
- Write a function-constructor for each CLOS class to hide `make-instance` and make required arguments positional and optional arguments keyword. Name these functions the same as a class name.

## Interactive development

- Work with running lisp image via `eval_lisp_form` mcp tool, if it is available.
- To not wait for lisp form eternally, wrap it into `(sb-sys:with-deadline (:seconds 10) ..body..)` form.
