;; Environment initialization
;;

(defvar nz-emacs-ruby-enabled-p nil "Should we load ruby specific stuff?")
(defvar nz-emacs-ruby nil "Path to a ruby interpreter")

(load-custom "nz_environment_init.el")

(when (not (stringp nz-emacs-ruby))
  (error "Missing environment variable NZ_EMACS_RUBY"))
