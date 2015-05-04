;; Environment initialization
;;

(defvar nz-emacs-racket-enabled-p nil "Racket mode enabled")
(defvar nz-emacs-racket-racket nil "Path to racket interpreter")
(defvar nz-emacs-racket-raco nil "Path to racket build tool")

(defvar nz-emacs-ruby-enabled-p nil "Ruby mode enabled")
(defvar nz-emacs-ruby nil "Path to a ruby interpreter")

(load-custom "nz_environment_init.el")

(when (not (stringp nz-emacs-ruby))
  (error "Missing environment variable NZ_EMACS_RUBY"))
