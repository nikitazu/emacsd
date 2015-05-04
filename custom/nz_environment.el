;; Environment initialization
;;

(defvar nz-emacs-racket-enabled-p nil "Racket mode enabled")
(defvar nz-emacs-racket-racket nil "Path to racket interpreter")
(defvar nz-emacs-racket-raco nil "Path to racket build tool")

(defvar nz-emacs-ruby-enabled-p nil "Ruby mode enabled")
(defvar nz-emacs-ruby nil "Path to a ruby interpreter")

(defvar nz-emacs-git-pageant-path nil "Path to putty session agent")
(defvar nz-emacs-git-ppk-path nil "Path to putty compatible private key")
(defvar nz-emacs-git-plink-path nil "Path to putty ssh link")

(load-custom "nz_environment_init.el")

(when (and nz-emacs-ruby-enabled-p (not (stringp nz-emacs-ruby)))
  (error "Missing environment setup for Ruby mode"))

(when (and nz-emacs-racket-enabled-p (or (not (stringp nz-emacs-racket-racket))
					 (not (stringp nz-emacs-racket-raco))))
  (error "Missing environment setup for Racket mode"))
