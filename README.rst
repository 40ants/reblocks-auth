=================
 weblocks-auth
=================

.. insert-your badges like that:

.. image:: https://travis-ci.org/40ants/weblocks-auth.svg?branch=master
    :target: https://travis-ci.org/40ants/weblocks-auth

.. Everything starting from this commit will be inserted into the
   index page of the HTML documentation.
.. include-from

Weblocks-auth is a system for adding authentication for your Weblocks
application. It allows users to login using multiple ways. Right now
GitHub is only supported but the list will be extended.

This system uses a `mito <https://github.com/fukamachi/mito>`_ as a
storage to store data about users and their data from service providers.
Each user has a unique nickname and an optional email. Also, one or more
identity providers can be bound to each user account.

Roadmap
=======

* Add support for authentication by a link sent to the email.
* Add ability to bind multiple service providers to a single user.

.. Everything after this comment will be omitted from HTML docs.
.. include-to

Building Documentation
======================

Provide instruction how to build or use your library.

How to build documentation
--------------------------

To build documentation, you need a Sphinx. It is
documentaion building tool written in Python.

To install it, you need a virtualenv. Read
this instructions
`how to install it
<https://virtualenv.pypa.io/en/stable/installation/#installation>`_.

Also, you'll need a `cl-launch <http://www.cliki.net/CL-Launch>`_.
It is used by documentation tool to run a script which extracts
documentation strings from lisp systems.

Run these commands to build documentation::

  virtualenv --python python2.7 env
  source env/bin/activate
  pip install -r docs/requirements.txt
  invoke build_docs

These commands will create a virtual environment and
install some python libraries there. Command ``invoke build_docs``
will build documentation and upload it to the GitHub, by replacing
the content of the ``gh-pages`` branch.

