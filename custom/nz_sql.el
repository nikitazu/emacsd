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



(defun nz-mysql-describe-table (table)
  "Send sql command to get table description"
  (interactive "MTable name:")
  (let ((query (format "show create table `%s`;"
		       table)))
    (sql-send-string query)))
