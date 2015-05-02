;; Enhanced Ruby Mode
;;

;; Path to ruby interpreter
(setq enh-ruby-program "~/.rbenv/versions/2.2.2/bin/ruby")

;; Mode title
(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)

;; Mode file extensions
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))

;; Ruby interpreter
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

;; Indentation
(setq enh-ruby-bounce-deep-indent t)
(setq enh-ruby-hanging-brace-indent-level 2)
