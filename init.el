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
(add-to-list 'load-path "~/.emacs.d/custom")

;; Packages
;;

;; Search
;;
(require 'ag)
(setq ag-highlight-search t)

;; Folders tree
;;
(require 'neotree)
;; Toggle directory tree
(global-set-key (kbd "C-c d") 'neotree-toggle)
;; Show current file at directory tree
(global-set-key (kbd "C-c g")
		(lambda ()
		  (interactive)
		  (call-interactively 'neotree-find)
		  (call-interactively 'other-window)))

;; Fuzzy search
;;
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; The notion of current project with file search inside
;;
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)
;; Fuzzy find
(global-set-key (kbd "C-c t") 'projectile-find-file)
;; Fuzzy switch buffer
(global-set-key (kbd "C-c p") 'projectile-switch-to-buffer)
;; refresh tree when swithing a project
(setq projectile-switch-project-action 'neotree-projectile-action)

;; Git version control integration
;;
(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")
(global-set-key (kbd "C-c s") 'magit-status)


;; At the end
(neotree-show)
