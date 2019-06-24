===========
 ChangeLog
===========

0.5.1
=====

* Supported recent change `of mito <https://github.com/fukamachi/mito/commit/be0ea57df921aa1beb2045b50a8c2e2e4f8b8955>`_ caused an error when searching a social user.

0.5.0
=====

* Added a ``weblocks-auth/models:change-email`` function.

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
