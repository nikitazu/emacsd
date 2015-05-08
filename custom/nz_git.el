;; Git version control integration
;;
(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")

(setenv "GIT_SSH" nz-emacs-git-plink-path)

(defun nz-git-launch-pageant ()
  "Runs putty agent to manage ssh session (Win32)."
  (interactive)
  (let ((proc (start-process "pageant"
			     nil
			     "cmd.exe"
			     "/C"
			     nz-emacs-git-pageant-win32-style-path
			     nz-emacs-git-ppk-win32-style-path)))
    (set-process-query-on-exit-flag proc nil)))

(global-set-key (kbd "C-c C-s") 'nz-git-launch-pageant)
(global-set-key (kbd "C-c s") 'magit-status)
