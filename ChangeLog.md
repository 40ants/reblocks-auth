<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-40CHANGELOG-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# ChangeLog

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E6-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.6.0 (2021-01-24)

* Added support for `secret-values` in [`*secret*`][d659].

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E5-2E1-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.5.1 (2019-06-24)

* Supported recent change [of mito][fd4e]
caused an error when searching a social user.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E5-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.5.0 (2019-06-22)

* Added a [`change-email`][f951] function.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E4-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.4.0 (2019-06-20)

* Added a new variable [`*login-hooks*`][0e88].

* A variable [`*enabled-services*`][ac4c] was exported.

* A function [`render-buttons`][69ac] was exported.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E3-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.3.0 (2019-04-18)

* Now classes [`user`][05f7] and [`social-profile`][d9d6] are exported from `reblocks-auth/models` system.

* New function were added: [`get-user-by-email`][85b4] and [`get-user-by-nickname`][6ced].

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E2-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.2.0 (2019-04-17)

* Now only `user:email` scope is required for authentication
  via github.

* And [`render-button`][b194] [`get-scopes`][e605]
  functions was added to request more scopes if required.

<a id="x-28REBLOCKS-AUTH-DOCS-2FCHANGELOG-3A-3A-7C0-2E1-2E0-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## 0.1.0 (2019-03-31)

* First version with GitHub authentication.


[ac4c]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3A-2AENABLED-SERVICES-2A-20-28VARIABLE-29-29
[0e88]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3A-2ALOGIN-HOOKS-2A-20-28VARIABLE-29-29
[69ac]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FCORE-3ARENDER-BUTTONS-20FUNCTION-29
[d659]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FGITHUB-3A-2ASECRET-2A-20-28VARIABLE-29-29
[e605]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FGITHUB-3AGET-SCOPES-20FUNCTION-29
[b194]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FGITHUB-3ARENDER-BUTTON-20FUNCTION-29
[f951]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3ACHANGE-EMAIL-20FUNCTION-29
[85b4]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-EMAIL-20FUNCTION-29
[6ced]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3AGET-USER-BY-NICKNAME-20FUNCTION-29
[d9d6]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3ASOCIAL-PROFILE-20CLASS-29
[05f7]: https://40ants.com/reblocks-auth/#x-28REBLOCKS-AUTH-2FMODELS-3AUSER-20CLASS-29
[fd4e]: https://github.com/fukamachi/mito/commit/be0ea57df921aa1beb2045b50a8c2e2e4f8b8955

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]