;; Racket mode
;;

(setq racket-racket-program nz-emacs-racket-racket)
(setq racket-raco-program nz-emacs-racket-raco)

(defun nz-racket-run-async ()
  "Runs racket with current file in a subprocess."
  (interactive)
  (when (get-process "RacketAsync")
    (delete-process "RacketAsync"))
  (let ((proc (start-process "RacketAsync"
			     "*Racket Async*"
			     nz-emacs-racket-racket
			     (buffer-file-name))))
    (set-process-query-on-exit-flag proc nil)))


(add-hook 'racket-mode-hook
	  (lambda ()
	    (define-key racket-mode-map (kbd "C-c C-c") 'racket-run)
	    (define-key racket-mode-map (kbd "C-\\") 'racket-insert-lambda)
	    (define-key racket-mode-map (kbd "C-c C-a") 'nz-racket-run-async)))

(add-hook 'racket-mode-hook      #'racket-unicode-input-method-enable)
(add-hook 'racket-repl-mode-hook #'racket-unicode-input-method-enable)
