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
;(setq projectile-switch-project-action 'neotree-projectile-action)


;; ignore some folders
(defun nz-projectile-add-to-ignore-directories (ignore-list)
  (dolist (item ignore-list)
    (add-to-list 'projectile-globally-ignored-files item)
    (add-to-list 'ido-ignore-directories item)))

(nz-projectile-add-to-ignore-directories '(".hg" ".git" ".sync"))

(setq projectile-enable-caching t)
(setq projectile-indexing-method 'alien)
(setq ido-ignore-extensions t)
