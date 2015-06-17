;; ELisp Mode
;;

(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (define-key emacs-lisp-mode-map (kbd "C-c C-c") 'eval-buffer)))
