;; Go languages
;;

(when (eq system-type 'windows-nt)
  (setenv "GOROOT"
	  "d:/apps/go142")
  (setenv "GOPATH"
	  "d:/prj/go")
  (setenv "PATH"
	  (concat "d:/apps/go142/bin;"
		  (getenv "PATH"))))

(add-hook 'go-mode-hook
	  (lambda ()
	    (add-hook 'before-save-hook 'gofmt-before-save)
	    (setq tab-width 2)
	    (setq indent-tabs-mode 1)))
