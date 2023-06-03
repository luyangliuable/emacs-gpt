;;; packages.el --- luyang-spaceline-placeholder layer packages
;;
;; Copyright (c) 2012-2022
;;
;; Author: Luyang Liu <blackfish@Luyangs-MacBook-Pro.local>
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;; Code:

(require 'url)
(require 'request)

(defconst emacs-gpt-packages
  '())

(defun emacs-gpt ()
  (interactive)
  (message "Hello World"))

(defun my-error-callback (&rest args)
  "Error callback function, gets called when an error occurs in the HTTP request."
  (let ((error-buffer (generate-new-buffer "*Error Buffer*")))
    (with-current-buffer error-buffer
      (insert (format "Error occurred: %S" args)))
    (switch-to-buffer-other-window error-buffer)))

(defun openai-api-call ()
  (interactive)
  (let ((url "https://api.openai.com/v1/chat/completions")
        (mycontent (concat "Give feedback on code: " ( buffer-string )))
        (new-buffer (generate-new-buffer "New Buffer"))
        (api-key "")) ; Replace with your OpenAI API key

    (with-current-buffer new-buffer
      (insert mycontent))
    (switch-to-buffer new-buffer)

    (request
     url
     :type "POST"
     :headers `(("Content-Type" . "application/json")
                ("Authorization" . ,(concat "Bearer " api-key)))
     :data (json-encode `(("model" . "gpt-3.5-turbo")
                          ("messages" . [(("role" . "user") ("content" . ,mycontent))])))
     :parser 'json-read
     :success (cl-function
               (lambda (&key data &allow-other-keys)
                 (with-output-to-temp-buffer "*temp*"
                   (print data))))
     :error #'my-error-callback)))

(defun copy-buffer-to-new ()
  "Copy the current buffer's contents to a new buffer."
  (interactive)
  (let ((content (buffer-string))
        (new-buffer (generate-new-buffer "New Buffer")))
    (switch-to-buffer new-buffer)
    (insert content)))
