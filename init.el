;; Initial setup
;;

(package-initialize)

(setq user-full-name "Nikita B. Zuev")
(setq user-mail-address "nikitazu@gmail.com")

;; Visuals
(show-paren-mode t)
(setq-default highlight-tabs t)
(setq-default show-trailing-whitespace t)

;; Remove useless whitespace before saving a file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))

;; Set locale to UTF8
(set-language-environment 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Text edit helpers
;;
(defun nz-eol-newline-and-indent ()
  "Go to end of line, insert newline and indent."
  (interactive)
  (end-of-line)
  (newline-and-indent))

(global-set-key (kbd "C-<return>") 'nz-eol-newline-and-indent)


;; Package management
;;
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

(defun load-custom (name)
  (load (concat "~/.emacs.d/custom/" name)))

(load-custom "nz_environment.el")
(load-custom "nz_autocomplete.el")
(load-custom "nz_git.el")
(load-custom "nz_project.el")
(load-custom "nz_search.el")
(load-custom "nz_sql.el")
(when nz-emacs-racket-enabled-p
  (load-custom "nz_racket.el"))
(when nz-emacs-ruby-enabled-p
  (load-custom "nz_ruby.el"))
(load-custom "nz_coffee.el")
(load-custom "nz_web.el")
(load-custom "nz_smartparens.el")
(load-custom "nz_highlight.el")
(load-custom "zzz_last.el")




;; *******************
;; Auto-generated code
;; *******************

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(package-selected-packages
   (quote
    (racket-mode coffee-mode highlight-indentation smartparens auto-complete enh-ruby-mode web-mode projectile pallet neotree magit flx-ido ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
