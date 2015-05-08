;; Autoclose parenthesis, brackets, quotes, tags, etc..
;;

(require 'smartparens-config)
(require 'smartparens-ruby)

(smartparens-global-mode)
(show-smartparens-global-mode t)

(sp-with-modes '(rhtml-mode)
  (sp-local-pair "<" ">")
  (sp-local-pair "<%" "%>"))

(sp-with-modes '(racket-mode)
  ;; disable ', it's the quote character!
  (sp-local-pair "'" nil :actions nil))
