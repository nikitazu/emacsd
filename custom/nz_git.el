;; Git version control integration
;;
(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")
(global-set-key (kbd "C-c s") 'magit-status)

(defun nz-git-launch-pageant ()
  (interactive)
  (let ((proc (start-process "pageant" nil nz-emacs-git-pageant-path nz-emacs-git-ppk-path)))
    (set-process-query-on-exit-flag proc nil)))

(global-set-key (kbd "C-c C-s") 'nz-git-launch-pageant)
