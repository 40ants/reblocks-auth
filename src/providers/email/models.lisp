(uiop:define-package #:reblocks-auth/providers/email/models
  (:use #:cl)
  (:import-from #:log4cl)
  (:import-from #:mailgun)
  (:import-from #:local-time
                #:timestamp<
                #:timestamp+
                #:now)
  (:import-from #:uuid
                #:make-v4-uuid)
  (:import-from #:mito
                #:find-dao
                #:create-dao)
  (:export #:registration-code
           #:*send-code-callback*
           #:registration-email
           #:valid-until
           #:send-code))
(in-package #:reblocks-auth/providers/email/models)


(defvar *send-code-callback*)
(setf (documentation '*send-code-callback* 'variable)
      "Set this variable to a function of one argument of class REGISTRATION-CODE.
It should send a registration code using template, suitable for your website.")


(defvar *code-ttl* (* 60 60)
  "Time to live for authentication code.")


(define-condition code-unknown (error)
  ((code :initarg :code
         :reader get-code))
  (:documentation "Signalled when code was not found in the database."))


(define-condition code-expired (error)
  ((code :initarg :code
         :reader get-code))
  (:documentation "Signalled when code was found but already expired."))


(defclass registration-code ()
  ((email :col-type (:varchar 255)
          :initarg :email
          :reader registration-email
          :documentation "User's email.")
   (code :col-type (:varchar 255)
         :initarg :code
         :reader registration-code
         :documentaion "Code need to login.")
   (valid-until :col-type :timestamp
                :initarg :valid-until
                :reader valid-until
                :documentation "Expiration time."))
  
  (:documentation "This model stores a code sent to an email for signup or log in.")
  (:metaclass mito:dao-table-class))


(defmethod print-object ((obj registration-code) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "email=~A code=~A"
            (registration-email obj)
            (registration-code obj))))


(defun make-registration-code (email &key (ttl *code-ttl*))
  (let* ((now (now))
         (valid-until (timestamp+ now ttl :sec))
         (code (uuid:print-bytes nil (make-v4-uuid))))
    (create-dao 'registration-code
                :email email
                :code code
                :valid-until valid-until)))


(defun send-code (email &key retpath send-callback)
  "Usually you should define a global callback using
   REBLOCKS-AUTH/PROVIDERS/EMAIL/MAILGUN:DEFINE-CODE-SENDER macro,
   but you can provide an alternative function to handle
   email sending."
  (log:info "Sending auth code to" email)
  
  (let* ((code (make-registration-code email)))
    (cond
      (send-callback
       (funcall send-callback
                code
                :retpath retpath))
      ((boundp '*send-code-callback*)
       (funcall *send-code-callback*
                code
                :retpath retpath))
      (t (log:warn "New registration code \"~A\" was generated but we weren't able to send it. Use REBLOCKS-AUTH/PROVIDERS/EMAIL/MAILGUN:DEFINE-CODE-SENDER to define a template for sending an email."
                   code)))))


;; (defgeneric authenticate (code-or-user)
;;   (:documentation "Processes user authentication. First called with the code, and makes inner call to itself with a user bound to this code."))


;; (defmethod authenticate ((code string))
;;   "Authenticates a user.

;;    If code wasn't found, then condition code-unknown will be raised.
;;    If code is expired, then condition code-expired will be raised.
   
;;    Возвращает пользователя, а вторым значением t если пользователь уже был
;;    и nil если это новая учётка."

;;   (let ((registration-code (mito:find-dao 'registration-code
;;                                           :code code)))
;;     (unless registration-code
;;       (error 'code-unknown :code code))

;;     ;; Теперь проверим, что код не просрочен
;;     (when (timestamp< (valid-until registration-code)
;;                       (now))
;;       (error 'code-expired :code code))

;;     ;; Ну а теперь можно попробовать залогинить пользователя
;;     ;; Для начала, попробуем найти его по email
;;     (let* ((email (get-email registration-code))
;;            (_ (log:info "Creating a user with" email))
;;            (user (or (get-user-by-email email)
;;                      (mito:create-dao *user-class*
;;                                       :email email))))
;;       (declare (ignorable _))
;;       (authenticate user))))


;; (defmethod authenticate ((user user-with-email))
;;   "Authenticates a user."
;;   (log:error "No authentication method was defined. Please, define mito-email-auth/models:authenticate method.")
;;   (error "Please, define an authenticate method for you a concrete class, derived from user-with-email."))


;; (defgeneric anonymous-p (user)
;;   (:documentation "Returns t if user is not authenticated.")
  
;;   (:method ((user t))
;;     t)
;;   (:method ((user user-with-email))
;;     (unless (get-email user)
;;       t)))


(defun check-registration-code (code)
  "Authenticates a user.

   If code wasn't found, then condition code-unknown will be raised.
   If code is expired, then condition code-expired will be raised.
   
   Возвращает пользователя, а вторым значением t если пользователь уже был
   и nil если это новая учётка."

  (check-type code string)

  (let ((registration-code (mito:find-dao 'registration-code
                                          :code code)))
    (unless registration-code
      (error 'code-unknown :code code))

    ;; Теперь проверим, что код не просрочен
    (when (timestamp< (valid-until registration-code)
                      (now))
      (error 'code-expired :code code))

    (values registration-code)))

