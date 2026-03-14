# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About

**reblocks-auth** is a Common Lisp authentication library for [Reblocks](https://github.com/40ants/reblocks)-based web applications. It provides a pluggable authentication system supporting multiple providers (GitHub OAuth, Email with verification codes) with optional CAPTCHA support (Google reCAPTCHA v2/v3 and Yandex SmartCaptcha).

See `AGENTS.md` for a detailed architectural reference with component descriptions and integration patterns.

## Commands

### Running Tests

```lisp
(asdf:test-op :reblocks-auth)
```

Tests use the **rove** framework. Test files are in `t/`.

### Linting

```bash
qlot exec 40ants-linter --system "reblocks-auth, reblocks-auth-docs, reblocks-auth-tests" --imports
```

### Running the Example App

```lisp
(asdf:load-system :reblocks-auth-example)
(reblocks-auth-example/server:start :port 8080)
```

### Updating Dependencies

```bash
qlot update --no-deps
```

### Interactive Development

When a running Lisp image is available via the `eval_lisp_form` MCP tool, use it for interactive development. Wrap potentially blocking forms in `(sb-sys:with-deadline (:seconds 10) ...)`.

## Architecture

The system uses the **package-inferred ASDF system** style — each source file has its own package. The main ASDF system is `reblocks-auth` (defined in `reblocks-auth.asd`).

### Key Source Files

- `src/core.lisp` — `login-processor` and `logout-processor` widgets; `*enabled-services*`, `*login-hooks*`, `*allow-new-accounts-creation*` vars
- `src/auth.lisp` — `authenticate` generic function `(authenticate service) → (values user created-p)`
- `src/button.lisp` — `render` generic function for provider buttons
- `src/models.lisp` — Mito ORM models: `user` and `social-profile`; `get-current-user`, `find-social-user`, `create-social-user`
- `src/github.lisp` — GitHub OAuth 2.0 provider; `*client-id*`, `*secret*`, `*default-scopes*`
- `src/providers/email/models.lisp` — `registration-code` model; `*code-ttl*`, `*send-code-callback*`
- `src/providers/email/processing.lisp` — `request-code-form` widget; reCAPTCHA and SmartCaptcha verification
- `src/providers/email/mailgun.lisp` / `resend.lisp` — `define-code-sender` macro for email backends

### Adding a New Auth Provider

1. Create `src/providers/<name>.lisp` with its own package
2. Implement `(defmethod reblocks-auth/auth:authenticate ((service (eql :<name>)) &key ...) ...)`
3. Implement `(defmethod reblocks-auth/button:render ((service (eql :<name>))) ...)`
4. Add the provider keyword to `reblocks-auth:*enabled-services*`

## Common Lisp Style

- Define packages with `uiop:define-package`, explicit `:use #:cl`, and `#:` for package names.
- Prefer `:local-nicknames` over `:use` or `:import-from` for external packages; use `:import-from` only for frequently used symbols.
- List `:export` explicitly; only export symbols intended for end-users.
- Use `serapeum/types` `->` for function type declarations where the package is available.
- Use `defgeneric`/`defmethod` for polymorphic behavior; document with `:documentation`.
- Write a constructor function for each CLOS class (same name as the class) to hide `make-instance`.
- Use `define-condition` with slots and `:report` for project-specific errors.
- Use `ecase`/`etypecase` for exhaustive dispatch.
- Do not edit files inside `.qlot/` — those are third-party dependencies.
