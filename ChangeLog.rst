===========
 ChangeLog
===========

0.4.0
=====

* Added a new variable ``weblocks-auth/core:*login-hooks*``.
* A variable ``weblocks-auth/core:*enabled-services*`` was exported.
* A function ``weblocks-auth/core:render-buttons`` was exported.

0.3.0
=====

* Now classes ``user`` and ``social-profile`` are exported from ``weblocks-auth/models`` system.
* New function were added: ``weblocks-auth/models:get-user-by-email`` and ``weblocks-auth/models:get-user-by-nickname``.

0.2.0
=====

* Now only ``user:email`` scope is required for authentication
  via github.
* And ``weblocks-auth/github:render-button`` ``weblocks-auth/github:get-scopes``
  functions was added to request more scopes if required.

0.1.0
=====

* First version with GitHub authentication.
