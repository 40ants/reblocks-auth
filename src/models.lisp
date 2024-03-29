(uiop:define-package #:reblocks-auth/models
  (:use #:cl)
  (:import-from #:jonathan)
  (:import-from #:reblocks/session)
  (:import-from #:alexandria
                #:make-keyword)
  (:import-from #:mito
                #:includes
                #:save-dao
                #:delete-dao
                #:select-dao
                #:create-dao)
  (:import-from #:reblocks-auth/errors
                #:nickname-is-not-available)
  (:export #:find-social-user
           #:create-social-user
           #:user
           #:social-profile
           #:get-all-users
           #:get-email
           #:get-nickname
           #:get-current-user
           #:get-user-by-email
           #:get-user-by-nickname
           #:change-email
           #:anonymous-p
           #:profile-service-user-id
           #:profile-metadata
           #:profile-service
           #:profile-user
           #:user-social-profiles
           #:change-nickname
           #:*user-class*))
(in-package #:reblocks-auth/models)


(defclass user ()
  ((nickname :col-type (:text)
             :initarg :nickname
             :reader get-nickname)
   ;; TODO: think how to make this column unique
   ;; and what to do when there is already a user with
   ;; given email but without a :email social_profile
   (email :col-type (or (:varchar 255)
                        :null)
          :initarg :email
          :initform nil
          :reader get-email))
  (:documentation "This class stores basic information about user - it's nickname and email.
                   Additional information is stored inside SOCIAL-PROFILE instances.")
  (:metaclass mito:dao-table-class)
  (:unique-keys email nickname))


(defvar *user-class* 'user
  "Allows to redefine a model, for users to be created by the reblocks-auth.")


(defclass social-profile ()
  ;; TODO: I need to understand how to make MITO use *user-class* instead of 'user here:
  ((user :col-type user
         :initarg :user
         ;; No source location found for reference 
         ;; warning from 40ants-doc for this method because,
         ;; it is generated by Mito and has no source information
         :reader profile-user
         :documentation "A USER instance, bound to the SOCIAL-PROFILE.")
   (service :col-type :text
            :initarg :service
            :reader profile-service
            :inflate (lambda (text)
                       (make-keyword (string-upcase text)))
            :deflate #'symbol-name)
   (service-user-id :col-type :text
                    :initarg :service-user-id
                    :reader profile-service-user-id)
   (metadata :col-type :jsonb
             :initarg :params
             :accessor profile-metadata
             :deflate #'jonathan:to-json
             :inflate (lambda (text)
                        (jonathan:parse
                         ;; Jonathan for some reason is unable to work with
                         ;; `base-string' type, returned by database
                         (coerce text 'simple-base-string)))))
  (:documentation "Represents a User's link to a social service.
                   User can be bound to multiple social services.")
  (:unique-keys (user-id service service-user-id))
  (:metaclass mito:dao-table-class))


(defmethod print-object ((obj user) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "nickname=~S email=~S"
            (get-nickname obj)
            (get-email obj))))


(defmethod print-object ((obj social-profile) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "service=~A user-id=~S"
            (profile-service obj)
            (profile-service-user-id obj))))


(defun get-all-users ()
  (mito:select-dao *user-class*))


(defun find-social-user (service service-user-id)
  (check-type service keyword)
  (let* ((profile (mito:find-dao 'social-profile
                                 :service service
                                 :service-user-id service-user-id)))
    (when profile
      (profile-user profile))))


(defun create-social-user (service
                           service-user-id
                           &rest metadata
                           &key email)

  (check-type service-user-id string)
  (check-type email (or string
                        null))

  ;; I tried to do this, but then internal user addition does not work
  ;; so we have to disable it on form
  ;; (unless (symbol-value (uiop:find-symbol* :*allow-new-accounts-creation*
  ;;                                          :reblocks-auth/core))
  ;;   (error 'new-accounts-are-prohibited))
  
  (let ((user (mito:create-dao *user-class*
                               :nickname service-user-id
                               :email email)))
      
    (mito:create-dao 'social-profile
                     :user user
                     :service service
                     :service-user-id service-user-id
                     :metadata metadata)
    (values user)))


(defun get-current-user ()
  "Returns current user or NIL."
  (reblocks/session:get-value
   :user))


(defun user-social-profiles (user)
  "Returns a list of social profiles, bound to the user."
  (check-type user user)
  (mito:retrieve-dao 'social-profile
                     :user-id (mito:object-id user)))


(defun (setf get-current-user) (user)
  (setf (reblocks/session:get-value
         :user)
        user))


(defun anonymous-p (user)
  (null user))


(defun get-user-by-email (email)
  "Returns a user with given email."
  (mito:find-dao *user-class* :email email))


(defun get-user-by-nickname (nickname)
  "Returns a user with given email."
  (mito:find-dao *user-class* :nickname nickname))


(defun change-nickname (new-nickname)
  "Changes nickname of the current user."
  (let ((user (get-current-user)))
    (when user
      ;; First, check if nickname is available
      (when (get-user-by-nickname new-nickname)
        (error 'nickname-is-not-available))
      
      (setf (slot-value user 'nickname)
            new-nickname)
      (mito:save-dao user)))
  (values))


(defun change-email (user email)
  (check-type user user)
  (check-type email (or string null))

  ;; TODO: Add a check that no other users has same email
  ;; and raise appropriate error
  ;; TODO: Send a verification email to a new address
  ;; and mark email as validated after the click to the link
  (setf (slot-value user 'email)
        email)
  (mito:save-dao user))
