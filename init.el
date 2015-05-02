;; Initial setup
;;
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

;; Package management
;;
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

(defun load-custom (name)
  (load (concat "~/.emacs.d/custom/" name)))

(load-custom "nz_git.el")
(load-custom "nz_project.el")
(load-custom "nz_search.el")
(load-custom "zzz_last.el")
