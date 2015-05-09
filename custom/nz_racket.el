;; Racket mode
;;

(setq racket-racket-program nz-emacs-racket-racket)
(setq racket-raco-program nz-emacs-racket-raco)

(add-hook 'racket-mode-hook
	  (lambda ()
	    (define-key racket-mode-map (kbd "C-c C-c") 'racket-run)
	    (define-key racket-mode-map (kbd "C-\\") 'racket-insert-lambda)))

(add-hook 'racket-mode-hook      #'racket-unicode-input-method-enable)
(add-hook 'racket-repl-mode-hook #'racket-unicode-input-method-enable)
