;;; gh-api.el --- GitHub client for Emacs

;; Copyright (C) 2014 by Sachin Patil

;; Author: Sachin Patil <isachin@iitb.ac.in>
;; URL: http://github.com/psachin/gh-api
;; Keywords: github, api, tool, convenience
;; Version: 0.9

;; This file is NOT a part of GNU Emacs.

;; `gh-api' is free software distributed under the terms of the GNU
;; General Public License, version 3 or later. For details, see the
;; file COPYING.

;;; Commentary:
;; GitHub client for Emacs
;; URL: http://github.com/psachin/gh-api

;;; Code:

(require 'oauth2)
(require 'json)
(require 'url)

;; (defvar my-token
;;   (make-oauth2-token :access-token "GITHUB TOKEN HERE"))

;; (defvar user-data
;;   (with-current-buffer
;;       (oauth2-url-retrieve-synchronously my-token "https://api.github.com/user")
;;     (goto-char url-http-end-of-headers)
;;     (json-read)))

;; (replace-regexp-in-string "{/gist_id}" "" (cdr (assoc 'gists_url user-data)))


;; Working
;; (defvar sachin-data
;;   (with-current-buffer (url-retrieve-synchronously "https://api.github.com/users/psachin/gists")
;;     (goto-char (+ 1 url-http-end-of-headers))
;;     (json-read)))


;; (cdr (assoc 'url (elt sachin-data 0)))	;gist url

;; (defvar gist-content
;;   (with-current-buffer (url-retrieve-synchronously (cdr (assoc 'url (elt sachin-data 0))))
;;     (goto-char (+ 1 url-http-end-of-headers))
;;     (json-read)))


;; (cdr (assoc 'content (elt (assoc 'files gist-content) 1))) ;gist content

(defun gh-api-authenticate (token)
  "Authenticate GitHub user."
  (interactive "sGitHub token: ")
  (gh-api-save-token token "~/.gh-api")
  (message "%s" token)
  )

(defun gh-api-save-token (token gh-api-token-file)
  "Save token to file."
  (with-temp-buffer
    (insert token)
    (when (file-writable-p gh-api-token-file)
      (write-region (point-min)
		    (point-max)
		    gh-api-token-file))))


(defun gh-api-read-token-file (gh-api-token-file)
  "Read token from file."
  (with-temp-buffer
    (insert-file-contents gh-api-token-file)
    (buffer-string)))

;; (gh-api-read-token-file "~/.gh-api")


(defun gh-api-json (gh-api-url)
  "Get JSON object"
  (with-current-buffer (url-retrieve-synchronously gh-api-url)
    (goto-char (+ 1 url-http-end-of-headers))
    (json-read)))


;;(setq gist-obj (gh-api-json "https://api.github.com/users/psachin/gists"))



;;;###autoload
(defun gh-api-check-token ()
  "Check existing GitHub token."
  (if (file-exists-p "~/.gh-api")
      (progn (let* ((token (gh-api-read-token-file "~/.gh-api"))
		    (my-token (make-oauth2-token :access-token token)))


	       (setq user-data
	       	     (with-current-buffer
	       		 (oauth2-url-retrieve-synchronously
	       		  my-token "https://api.github.com/user")
	       	       (goto-char url-http-end-of-headers)
	       	       (json-read)))
	       
	       (setq gist-url (replace-regexp-in-string "{/gist_id}" "" (cdr (assoc 'gists_url user-data))))
	       (message "%s" gist-url)

	       (setq gist-obj (gh-api-json gist-url))
	       ;; (setq gist (gh-api-json (cdr (assoc 'url (elt gist-obj 0)))))
	       ;; (setq gh-files (assoc 'files gist))
	       ;; (setq gh-content (assoc 'content (elt gh-files 1)))
	       
	       );let
	     )
    (gh-api-authenticate)))

(gh-api-check-token)


