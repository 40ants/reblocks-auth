(defsystem reblocks-auth
  :version (:read-file-form "version.lisp-expr")
  :author ""
  :license ""
  :class :package-inferred-system
  :pathname "src"
  :depends-on ("reblocks-auth/core")
  :description "A system to add an authentication to the Weblocks based site."
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.rst"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq)
                (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op reblocks-auth-test))))

