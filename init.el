;; Initial setup
;;
(setq user-full-name "Nikita B. Zuev")
(setq user-mail-address "nikitazu@gmail.com")

;; Highlight corresponding parentheses when cursor is on one
(show-paren-mode t)
;; Highlight tabulations
(setq-default highlight-tabs t)
;; Show trailing white spaces
(setq-default show-trailing-whitespace t)

;; Remove useless whitespace before saving a file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))


;; Package management
;;
(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'pallet)
(pallet-mode t)
(add-to-list 'load-path "~/.emacs.d/custom")

;; Packages
;;
(require 'ag)
(setq ag-highlight-search t)

(require 'neotree)
;; Toggle directory tree
(global-set-key (kbd "C-c d") 'neotree-toggle)

(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(projectile-global-mode)
(setq projectile-enable-caching t)
;; Fuzzy find
(global-set-key (kbd "C-c t") 'projectile-find-file)
;; Fuzzy switch buffer
(global-set-key (kbd "C-c p") 'projectile-switch-to-buffer)


;; Other bindings
(global-set-key (kbd "C-c s") 'shell)

;; At the end
(neotree-toggle)
