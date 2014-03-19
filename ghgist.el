

(require 'oauth2)
(require 'json)


(defvar my-token
  (make-oauth2-token :access-token ""))

(defvar user-data
  (with-current-buffer
      (oauth2-url-retrieve-synchronously my-token "https://api.github.com/user")
    (goto-char url-http-end-of-headers)
    (json-read)))




(replace-regexp-in-string "{/gist_id}" "" (cdr (assoc 'gists_url user-data)))


;; Working
(defvar sachin-data
  (with-current-buffer (url-retrieve-synchronously "https://api.github.com/users/psachin/gists")
    (goto-char (+ 1 url-http-end-of-headers))
    (json-read)))


(cdr (assoc 'url (elt sachin-data 0)))	;gist url

(defvar gist-content
  (with-current-buffer (url-retrieve-synchronously (cdr (assoc 'url (elt sachin-data 0))))
    (goto-char (+ 1 url-http-end-of-headers))
    (json-read)))


(cdr (assoc 'content (elt (assoc 'files gist-content) 1))) ;gist content

