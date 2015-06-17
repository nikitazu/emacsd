;; OmniSharp
;;

(require 'omnisharp)

(when (eq system-type 'windows-nt)
  (setq omnisharp-server-executable-path "D:\\apps\\omnisharp\\OmniSharp.exe")
  (setq omnisharp--curl-executable-path "D:\\apps\\curl740\\curl.exe"))

(add-hook 'csharp-mode-hook 'omnisharp-mode)

(add-hook 'csharp-mode-hook
	  (lambda ()
	    (define-key omnisharp-mode-map (kbd "C-c u") 'omnisharp-find-usages)
	    (define-key omnisharp-mode-map (kbd "C-c i") 'omnisharp-find-implementations)
	    (define-key omnisharp-mode-map (kbd "C-c d") 'omnisharp-go-to-definition)
	    (define-key omnisharp-mode-map (kbd "C-c C-r") 'omnisharp-un-code-action-refactoring)
	    (define-key omnisharp-mode-map (kbd "C-c r") 'omnisharp-rename)
	    (define-key omnisharp-mode-map (kbd "C-c C-c") 'recompile)

	    (define-key omnisharp-mode-map (kbd "C-c f m") 'omnisharp-navigate-to-current-file-member)
	    (define-key omnisharp-mode-map (kbd "C-c f M") 'omnisharp-navigate-to-solution-member)
	    (define-key omnisharp-mode-map (kbd "C-c f f") 'omnisharp-navigate-to-solution-file)
	    (define-key omnisharp-mode-map (kbd "C-c f F") 'omnisharp-navigate-to-solution-file-then-file-member)

	    (define-key omnisharp-mode-map (kbd ".") 'omnisharp-add-dot-and-auto-complete)
	    (define-key omnisharp-mode-map (kbd "M-/") 'omnisharp-auto-complete)))
