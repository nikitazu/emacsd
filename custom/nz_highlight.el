;; Highlight identation
;;

(require 'highlight-indentation)

(set-face-background 'highlight-indentation-face "LightYellow2")
(set-face-background 'highlight-indentation-current-column-face "LightYellow2")

(add-hook 'enh-ruby-mode-hook (lambda () (highlight-indentation-current-column-mode)))
(add-hook 'coffee-mode-hook (lambda () (highlight-indentation-current-column-mode)))
