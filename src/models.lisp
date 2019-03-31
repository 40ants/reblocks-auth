(defpackage #:weblocks-auth/models
  (:use #:cl)
  (:import-from #:jonathan)
  (:import-from #:weblocks/session)
  (:import-from #:alexandria
                #:make-keyword)
  (:import-from #:mito
                #:includes
                #:save-dao
                #:delete-dao
                #:select-dao
                #:create-dao)
  (:export #:find-social-user
           #:create-social-user
           #:get-all-users
           #:get-email
           #:get-nickname
           #:get-current-user
           #:anonymous-p))
(in-package weblocks-auth/models)


(defclass user ()
  ((nickname :col-type (:text)
             :initarg :nickname
             :reader get-nickname)
   (email :col-type (or (:varchar 255)
                        :null)
          :initarg :email
          :initform nil
          :reader get-email))
  (:metaclass mito:dao-table-class)
  (:unique-keys email nickname))


(defclass social-profile ()
  ((user :col-type user
         :initarg :user
         :accessor get-user)
   (service :col-type (:text)
            :initarg :service
            :reader get-service
            :inflate (lambda (text)
                       (make-keyword (string-upcase text)))
            :deflate #'symbol-name)
   (service-user-id :col-type (:text)
                    :initarg :service-user-id
                    :reader get-service-user-id)
   (metadata :col-type (:jsonb)
             :initarg :params
             :accessor get-metadata
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
            (get-service obj)
            (get-service-user-id obj))))

(defun get-all-users ()
  (mito:select-dao 'user))


(defun find-social-user (service service-user-id)
  (let* ((profile (mito:find-dao 'social-profile
                                 :service (etypecase service
                                            (symbol (symbol-name service))
                                            (string service))
                                 :service-user-id service-user-id)))
    (when profile
      (get-user profile))))


(defun create-social-user (service
                           service-user-id
                           &rest metadata
                           &key email)

  (check-type service-user-id string)
  (check-type email (or string
                        null))
  
  (let ((user (mito:create-dao 'user
                               :nickname service-user-id)))
      
    (mito:create-dao 'social-profile
                     :user user
                     :service service
                     :service-user-id service-user-id
                     :metadata metadata)
    (values user)))


(defun get-current-user ()
  (weblocks/session:get-value
   :user))


(defun (setf get-current-user) (user)
  (setf (weblocks/session:get-value
         :user)
        user))


(defun anonymous-p (user)
  (null user))
