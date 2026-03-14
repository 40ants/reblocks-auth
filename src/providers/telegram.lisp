(uiop:define-package #:reblocks-auth/providers/telegram
  (:use #:cl)
  (:import-from #:ironclad)
  (:import-from #:babel)
  (:import-from #:log)
  (:import-from #:alexandria
                #:remove-from-plist)
  (:import-from #:reblocks-auth/auth)
  (:import-from #:reblocks-auth/button)
  (:import-from #:reblocks/html
                #:with-html)
  (:import-from #:reblocks/response
                #:make-uri
                #:add-retpath-to)
  (:import-from #:reblocks-auth/conditions
                #:unable-to-authenticate)
  (:import-from #:reblocks-auth/models
                #:find-social-user
                #:create-social-user)
  (:import-from #:secret-values
                #:ensure-value-revealed)
  (:export #:*bot-username*
           #:*bot-token*
           #:render-button))
(in-package #:reblocks-auth/providers/telegram)


(defvar *bot-username* nil
  "Telegram bot username (without @). Required for the login widget.")

(defvar *bot-token* nil
  "Telegram bot token used to verify authentication data.
   Can be a string or secret-values:secret-value.")


(defun verify-telegram-hash (telegram-params hash)
  "Verify Telegram authentication data integrity.

   TELEGRAM-PARAMS is a plist of fields received from Telegram (without :hash).
   HASH is the hex-encoded HMAC-SHA256 hash string received from Telegram.

   Algorithm: sort fields alphabetically, join as 'key=value\\n...',
   compute HMAC-SHA256 with SHA256(bot-token) as key, compare hex digests."
  (let* ((fields (loop for (key value) on telegram-params by #'cddr
                       when value
                       collect (cons (string-downcase (symbol-name key)) value)))
         (sorted-fields (sort fields #'string< :key #'car))
         (data-check-string
           (format nil "~{~A~^~%~}"
                   (mapcar (lambda (pair)
                             (format nil "~A=~A" (car pair) (cdr pair)))
                           sorted-fields)))
         (token-bytes (babel:string-to-octets
                       (ensure-value-revealed *bot-token*)
                       :encoding :utf-8))
         (secret-key (ironclad:digest-sequence :sha256 token-bytes))
         (hmac (ironclad:make-hmac secret-key :sha256))
         (data-bytes (babel:string-to-octets data-check-string :encoding :utf-8)))
    (ironclad:update-hmac hmac data-bytes)
    (string= (ironclad:byte-array-to-hex-string (ironclad:hmac-digest hmac))
             hash)))


(defun render-button (&key retpath)
  "Renders the Telegram Login Widget script tag."
  (with-html ()
    (if *bot-username*
        (let* ((base-url (make-uri "/login?service=telegram"))
               (auth-url (if retpath
                             (add-retpath-to base-url :retpath retpath)
                             base-url)))
          (:script :async ""
                   :src "https://telegram.org/js/telegram-widget.js?22"
                   :data-telegram-login *bot-username*
                   :data-size "large"
                   :data-auth-url auth-url
                   :data-request-access "write"))
        (:a :href ""
            :class "button"
            "Please, set reblocks-auth/providers/telegram:*bot-username*"))))


(defmethod reblocks-auth/button:render ((service (eql :telegram)) &key retpath)
  (render-button :retpath retpath))


(defmethod reblocks-auth/auth:authenticate ((service (eql :telegram))
                                            &rest params
                                            &key id first_name last_name username
                                                 photo_url auth_date hash retpath)
  (declare (ignorable params retpath photo_url))

  (unless id
    (error 'unable-to-authenticate
           :message "Missing Telegram user ID."))

  (unless hash
    (error 'unable-to-authenticate
           :message "Missing Telegram authentication hash."))

  (unless *bot-token*
    (error 'unable-to-authenticate
           :message "Telegram bot token is not configured. Please set reblocks-auth/providers/telegram:*bot-token*."))

  ;; Validate auth_date freshness (must be within 24 hours)
  (when auth_date
    (let* (;; Universal time epoch difference: CL uses 1900, Unix uses 1970
           (unix-epoch-offset 2208988800)
           (unix-now (- (get-universal-time) unix-epoch-offset))
           (auth-unix (parse-integer auth_date))
           (age-seconds (- unix-now auth-unix)))
      (when (> age-seconds (* 24 60 60))
        (error 'unable-to-authenticate
               :message "Telegram authentication data has expired. Please try again."))))

  ;; Verify hash using all Telegram params except :hash itself and our own :retpath
  (let ((telegram-params (remove-from-plist params :hash :retpath)))
    (unless (verify-telegram-hash telegram-params hash)
      (log:error "Telegram hash verification failed for user id=~A" id)
      (error 'unable-to-authenticate
             :message "Telegram authentication verification failed.")))

  (let* ((id-string (princ-to-string id))
         (user (find-social-user :telegram id-string)))
    (cond
      (user (values user nil))
      (t (values (create-social-user :telegram
                                     id-string
                                     :first-name first_name
                                     :last-name last_name
                                     :username username
                                     :photo-url photo_url)
                 t)))))
