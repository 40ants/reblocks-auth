(uiop:define-package #:reblocks-auth-ci/ci
  (:use #:cl)
  (:import-from #:40ants-ci/jobs/linter)
  (:import-from #:40ants-ci/jobs/autotag)
  (:import-from #:40ants-ci/jobs/run-tests
                #:run-tests)
  (:import-from #:40ants-ci/jobs/docs
                #:build-docs)
  (:import-from #:40ants-ci/workflow
                #:defworkflow))
(in-package #:reblocks-auth-ci/ci)


(defworkflow release
  :on-push-to "master"
  :jobs ((40ants-ci/jobs/autotag:autotag)))


(defworkflow linter
  :on-push-to "master"
  :by-cron "0 10 * * 1"
  :on-pull-request t
  :cache t
  :jobs ((40ants-ci/jobs/linter:linter
          :asdf-systems ("reblocks-auth"
                         "reblocks-auth-docs"
                         "reblocks-auth-tests")
          :check-imports t)))

(defworkflow docs
  :on-push-to "master"
  :by-cron "0 10 * * 1"
  :on-pull-request t
  :cache t
  :jobs ((build-docs :asdf-system "reblocks-auth-docs")))


(defworkflow ci
  :on-push-to "master"
  :by-cron "0 10 * * 1"
  :on-pull-request t
  :cache t
  :jobs ((run-tests
          :asdf-system "reblocks-auth"
          :lisp ("sbcl-bin"
                 ;; Issue https://github.com/roswell/roswell/issues/534
                 ;; is still reproduces on 2023-02-06:
                 "ccl-bin/1.12.0")
          :coverage t)))
