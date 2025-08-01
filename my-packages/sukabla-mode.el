;;; sukabla-mode.el --- The sukabla language major mode -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 Nikita B. Zuev
;;
;; Author: Nikita B. Zuev <nikitazu@gmail.com>
;; Maintainer: Nikita B. Zuev <nikitazu@gmail.com>
;; Created: Jul 31, 2025
;; Version: 0.1
;; Keywords: sukabla, languages
;; URL: TBA
;; Package-Requires: ((emacs "26.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; `sukabla-mode' is an Emacs major mode for `sukabla' programming language.
;; This mode provides syntax highlighting for `.бля' files.
;;
;;; Code:

;;; The Customization Section
;;

(defgroup sukabla nil
  "Support for the sukabla programming language."
  :link '(url-link "TBA")
  :group 'language)

(defcustom sukabla-indent-level 2
  "Number of spaces for each indentation step in sukabla language."
  :type 'integer
  :group 'sukabla
  :safe 'integerp)

;;; Syntax Highlighting
;;

(defconst sukabla-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?/ ". 124b" table)
    (modify-syntax-entry ?* ". 23" table)
    (modify-syntax-entry ?\n "> b" table)
    table)
  "Syntax table for the sukabla language.
This provides special character treatment for comment sections.
The `/' character is treated as comment starter and finisher.
The `*' character is treated as part of a comment.
The `\n' character is treated as comment finisher.

The syntax string DSL makes no fucking sense,
so I used DeepSeek to generate and then explain
it to me line by line.")

(defconst sukabla-keyword-list
  '("сука" "бля" "типа" "если" "иначе" "вот" "пока" "всем" "бч" "мч" "числа")
  "List of sukabla language keywords.")

(defconst sukabla-constant-list
  '("да" "нет")
  "List of sukabla language literal constants.")

(defconst sukabla-type-list
  '("ц32" "текст")
  "List of sukabla built-in types.")

(defconst sukabla-font-lock-words
  (let ((keyword-re  (regexp-opt sukabla-keyword-list 'words))
        (constant-re (regexp-opt sukabla-constant-list 'words))
        (type-re     (regexp-opt sukabla-type-list 'words))
        (number-re   "\\<[0-9]+\\(\\.[0-9]+\\)?\\>"))
    (list (list keyword-re  0 font-lock-keyword-face)
          (list constant-re 0 font-lock-constant-face)
          (list type-re     0 font-lock-type-face)
          (list number-re   0 font-lock-constant-face)))
  "Font lock table for highlighting.")

;;; Indentation
;;

(defun sukabla-indent-line ()
  "Indent current line according to sukabla syntax.
WIP: This function is to silly yet!!!"
  (interactive)
  (let ((indent sukabla-indent-level))
    (indent-line-to indent)))

;;; Major Mode Definition
;;

(define-derived-mode sukabla-mode prog-mode "Sukabla Mode"
  "Major mode for coding in sukabla language."
  :syntax-table sukabla-mode-syntax-table
  (setq-local font-lock-defaults '(sukabla-font-lock-words))
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  ;; WIP: indentation function is not ready for production yet
  ;; (setq-local indent-line-function 'sukabla-indent-line)
  )

;; Register file extension
(add-to-list 'auto-mode-alist '("\\.бля" . sukabla-mode))

;; Provide the package
(provide 'sukabla-mode)
