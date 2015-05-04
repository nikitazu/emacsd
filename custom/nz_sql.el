;; SQL mode
;;

(require 'sql)

(setq sql-mysql-program nz-emacs-sql-mysql-client-path)

(setq sql-user "root")
(setq sql-server "localhost")
(setq sql-mysql-options (list "--unbuffered"
			      "--force"
			      "--verbose"
			      "--default-character-set=utf8"))
