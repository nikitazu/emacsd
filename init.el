;; -*- mode: elisp -*-

;; Файл настройки EMACS
;;
;; нашкодил Никита Б. Зуев <nikitazu@gmail.com>
;; вместо отпуска, т.к. очень захотелось
;;

;; Вспомогательные функции
;;

(defun nz/directory-get-subdirs (path)
  "Получить список полных имён директорий по указанному пути `path'."
  (if (file-directory-p path)
      (let* ((names (directory-files path))
             (names (seq-remove (lambda (x) (equal (string-match "^\\..*" x) 0)) names))
             (paths (mapcar (lambda (x) (file-name-concat path x)) names))
             (subdirs (seq-remove (lambda (x) (not (file-directory-p x))) paths)))
        subdirs)
    nil))

(defun nz/directory-get-files (path &optional mask-re)
  "Получить список полных имён файлов по указанному пути `path'.
Дополнительно имена файлов можно отфильтровать по указанной маске `mask-re'.
Маска сверяется с файлом с помошью функции `string-match' и может быть регулярным выражением."
  (if (file-directory-p path)
      (let* ((names (directory-files path))
             (names (seq-remove (lambda (x) (equal (string-match "^\\..*" x) 0)) names))
             (paths (mapcar (lambda (x) (file-name-concat path x)) names))
             (files (seq-remove (lambda (x) (file-directory-p x)) paths))
             (final-files (if (null mask-re)
                              files
                            (seq-remove (lambda (x) (null (string-match mask-re x)))
                                        files)))
             )
        final-files)
    nil))

(defmacro nz/list-push-items (lst items)
  "Добавляет элементы `items' в список `lst' (без повторов)."
  `(seq-do (lambda (x) (add-to-list ,lst x))
           ,items))

(defun nz/list-pick-random (lst)
  "Выбирает случайный элемент из списка `lst'."
  (nth (random (length lst))
       lst))

(defun nz/shift-line-up ()
  "Двигает текущую строку вверх."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun nz/shift-line-down ()
  "Двигает текущую строку вниз."
  (interactive)
  (forward-line)
  (transpose-lines 1)
  (forward-line -1))

(defun nz/kill-emacs ()
  "Выключает Emacs."
  (interactive)
  (let ((exit-code 1)
        (restart-flag nil))
    (kill-emacs exit-code restart-flag)))

;; Мои глобальные настройки путей
;;

(defvar nz/projects-directory "c:/prj"
  "Директория проектов.")

(defvar nz/projects-directories '()
  "Список вложенных директорий с проектами, внутри `nz/projects-directory'.")

(when (not (file-directory-p nz/projects-directory))
  (setq nz/projects-directory "~/prj"))

(nz/list-push-items 'nz/projects-directories
                    (nz/directory-get-subdirs nz/projects-directory))

(defvar nz/org-directory "c:/nz/notes/org"
  "Директория заметок ОРГ-режима.")

(defvar nz/org-publish-directory "c:/nz/notes/publish"
  "Директория публикации заметок ОРГ-режима.")

(defvar nz/org-files '()
  "Список файлов ОРГ-режима.

Создавался для повестки дня, сейчас по нему же прыгаем в заметки функцией `org'.
ДЕЛА: Сделать отдельную переменную для файлов повестки дня.
ДЕЛА: Сделать отдельную переменную ведущую на оглавдение заметок для функции `org'.")

(when (not (file-directory-p nz/org-directory))
  (setq nz/org-directory "~/notes/org"))

(when (not (file-directory-p nz/org-publish-directory))
  (setq nz/org-publish-directory "~/notes/publish"))

(defvar nz/org-capture-file
  (file-name-concat nz/org-directory "10-index.org")
  "Путь к файлу для захвата новых преходящих заметок.")

(nz/list-push-items 'nz/org-files
                    (nz/directory-get-files nz/org-directory "\\.org$"))

;; Woman (unix man pages)
;;
;; Для Windows самый простой способ обеспечения доступа к мануалам:
;;
;; 1. Зайти по ssh в линукс
;; 2. Установить нужные мануалы
;; 3. Скопировать через scp на Windows машину содержимое man страниц
;;    scp -r -B ao:/usr/share/man/man* c:/man
;;    (прим. просто вызвать `nz/woman-copy-man' передав параметром `ao')
;;
(require 'woman)
(defconst nz/woman-manpath "c:/man")
(when (file-directory-p nz/woman-manpath)
  (setq woman-manpath (list nz/woman-manpath)))

;; Ищет идентификатор под курсором в man страницах
(keymap-global-set "C-c w" 'woman-follow)


(defun nz/woman-copy-man (hostname)
  "Скачать мануалы с линуксового сервера `hostname'.

Примечание: scp ругается на некоторые файлы внутри /usr/share/man
            что вот не может их найти, но такие файлы пропускаются
            и большая часть мануалов скачивается успешно.
"
  (interactive "sHostname: ")
  (let ((process-name "nz/woman-copy-man")
        (buffer-name  "*nz/woman-copy-man-log*")
        (target-dir   nz/woman-manpath))
    (unless (file-directory-p target-dir)
      (error "WoMan manpath directory not found: %s" target-dir))
    (switch-to-buffer-other-window buffer-name)
    (insert (format "Start: %s\n" (current-time-string)))
    (start-process process-name
                   buffer-name
                   "scp" "-r" "-B" (format "%s:/usr/share/man/man*" hostname) target-dir)))

;; Путь к моим локальным пакетам
;;

(add-to-list 'load-path "~/.emacs.d/my-packages")

;; Пакет Custom
;;

(setq custom-file "~/.emacs.d/my-custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; Внешний вид
;;
;; C-x C-e Выполнить выражение под курсором
;; C-j     Выполнить выражение под курсором и добавить его результат строчкой ниже
;;

;; Шрифт
(set-face-attribute 'default nil
                    :font "Consolas"
                    :height 180)

(add-to-list 'default-frame-alist '(font . "Consolas-16"))

;; Запускать развёрнутым на весь экран
;(add-hook 'window-setup-hook 'toggle-frame-maximized t)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Отключить панель с кнопками сверху
(tool-bar-mode -1)

;; Отключить верхнее меню
(menu-bar-mode -1)

;; Отключить полосу прокрутки
(scroll-bar-mode -1)

;; Отображение номеров строк
(global-display-line-numbers-mode)

;; Скрытие отображения номеров строк для некоторых режимов
(dolist (mode '(dired-mode-hook
                eshell-mode-hook
                org-mode-hook
                shell-mode-hook
                term-mode-hook
                woman-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Отображение номера текущей колонки
(setq column-number-mode t)

;; Автоподсветка текущей строки
(global-hl-line-mode 1)

;; Тема оформления: подключение пути
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; Тема оформления: загрузка темы
;; Удобный способ применения изменений без перезагрузки
;; - это вычислить следующее выражение через <C-x C-e>
(load-theme 'dracula t)

;; Отображение непечатных символов
(global-whitespace-mode)
(setq whitespace-line-column 100)

;; UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)


;; Подсветка специальных слов
;;

(add-hook 'c-mode-hook
 (lambda ()
   (font-lock-add-keywords
    nil
    '(("\\<\\(TODO\\)" 1 font-lock-warning-face prepend)
      ("\\<\\(ДЕЛА\\)" 1 font-lock-warning-face prepend)
      ("\\<\\(ДУМА\\)" 1 font-lock-warning-face prepend)
      ("\\<\\(ЛАЖА\\)" 1 font-lock-warning-face prepend)
      ("\\<\\(and\\|or\\|not\\)\\>" . font-lock-keyword-face)))))


;; Навигация по буферам
;;

;; C-x b     Открыть буфер
;; C-x C-b   Список буферов
;; C-x k     Убить буфер
;; C-x C-s   Сохранить буфер
;; C-x C-w   Сохранить буфер как новый файл
;; C-x o     Переключиться на другое окно
;; C-x left  Переключиться на предыдущий буфер
;; C-x right Переключиться на следующий буфер

;; Переключиться на другое окно (альтернативный хоткей)
(keymap-global-set "M-o" 'other-window)

;; Убрать другие окна
(keymap-global-set "M-1" 'delete-other-windows)

;; Разделить окно горизонтально
(keymap-global-set "M-2" 'split-window-below)

;; Разделить окно вертикально
(keymap-global-set "M-3" 'split-window-right)

;; Уменьшить/увеличить окно вертикально
(keymap-global-set "M-[" 'shrink-window)
(keymap-global-set "M-]" 'enlarge-window)

;; Уменьшить/увеличить окно горизонтально
(keymap-global-set "M-{" 'shrink-window-horizontally)
(keymap-global-set "M-}" 'enlarge-window-horizontally)

(defun split-window-right-small ()
  "Разделить окно вертикально, сформировав окно справа.
Окно справа будет на 16 колонок меньше окна слева."
  (interactive)
  (split-window-right)
  (enlarge-window-horizontally 16))

(defun split-window-below-small ()
  "Разделить окно горизонтально, сформировав окно внизу.
Окно внизу будет на 16 строк меньше окна всерху."
  (interactive)
  (split-window-below)
  (enlarge-window 8))

(keymap-global-set "M-8" 'split-window-right-small)
(keymap-global-set "M-9" 'split-window-below-small)

;; Переключиться между буферами: назад / вперёд
(keymap-global-set "M-p" 'previous-buffer)
(keymap-global-set "M-n" 'next-buffer)

;; Завершить процесс Emacs
(keymap-global-set "C-q" 'nz/kill-emacs)

;; Зум
;;
;; По умолчанию уже есть
;; <C-wheel-up>
;; <C-wheel-down>
;; <C-x C-=>
;; <C-x C-->
;;
;; Для удобства добавляем
;;
(keymap-global-set "C-=" 'text-scale-increase)
(keymap-global-set "C--" 'text-scale-decrease)
(keymap-global-set "C-0" 'text-scale-set)

;; Редактирование текста
;;

;; Всегда использовать пробелы вместо табов
(setq-default indent-tabs-mode nil)

;; Установить отображаемый размер таба в 4 пробела
(setq-default tab-width 4)

;; Автоматическая подстановка парной скобки
(electric-pair-mode 1)

;; Отключить бекап-файлы
(setq make-backup-files nil)

;; Дубликация строки
(keymap-global-set "C-c d" 'duplicate-line)

;; Поиск с заменой
(keymap-global-set "C-h" 'query-replace)

(keymap-global-set "M-<up>" 'nz/shift-line-up)
(keymap-global-set "M-<down>" 'nz/shift-line-down)

;; C-M-b / C-M-p - прыгнуть к предыдущей паркной скобке
;; C-M-f / C-M-n - прыгнуть к следующей парной скобке

;; imenu
;; M-g i - запускает imenu,
;;         которое позволяет выбрать/найти имя функции и прыгнуть к ней

;; Отмена
;;
;; C-/ - отменить
;;
;; отменить отмену
(keymap-global-set "C-S-/" 'undo-redo)

;; Сокращения (Abbrev, они же снипеты)
;;
(add-hook 'c-mode-hook 'abbrev-mode)

(defun nz/c-define-struct ()
  "Вставляет определение структуры на языке C, предварительно запросив её название."
  (interactive)
  (let ((name (read-string "Enter struct name: ")))
    (insert (format "typedef struct %s\n{\n} %s;" name name)))
  (previous-line))

(define-abbrev-table 'c-mode-abbrev-table
  `(("cstruct" "" nz/c-define-struct)))

;; нам не нужно сохранять снипеты в файл, т.к. мы их определяем в конфиге
;; выражение ниже отключает диалог с вопросом о сохранении снипетов в файл,
;; который иначе выскакивает при закрытии emacs
(setq save-abbrevs nil)

;; Файловая навигация (dired)
;;
;; h - справка по режиму
;; n - след. файл
;; p - пред. файл
;; m - выделить файл
;; u - снять выделение
;; M - снять все выделения
;; t - инвертировать выделения
;; R - переименовать файл
;;
(defun nz/dired-mode-hook ()
  "Настройка всякого для Dired режима (файлового навигатора)."
  (whitespace-mode -1)
  (define-key dired-mode-map (kbd "b") 'dired-up-directory)
  (define-key dired-mode-map (kbd "C-<return>") 'dired-display-file))

(add-hook 'dired-mode-hook 'nz/dired-mode-hook)

;; ОРГ-Режим
;;
(require 'org)
(setq org-todo-keywords
      '((sequence "ДЕЛА" "ВРАБ" "ГОТВ")))

(defun zk-capture-note-location ()
  "Открывает новый файл с заметкой."
  (let* ((id (zk-new-id))
         (name (format "%s.org" id))
         (path (file-name-concat nz/org-directory "30-notes" name)))
    (find-file path))
  (goto-char (point-max)))

(defun zk-capture-note-template ()
  "Возвращает шаблон заметки."
  (with-temp-buffer
    (insert-file-contents (file-name-concat nz/org-directory "_setup" "note.template"))
    (buffer-string)))

(defun zk-capture-reference-location ()
  "Открывает новый файл с отсылкой."
  (let* ((id (zk-new-id))
         (name (format "%s.org" id))
         (path (file-name-concat nz/org-directory "20-refs" name)))
    (find-file path))
  (goto-char (point-max)))

(defun zk-capture-reference-template ()
  "Возвращает шаблон отсылки."
  (with-temp-buffer
    (insert-file-contents (file-name-concat nz/org-directory "_setup" "reference.template"))
    (buffer-string)))

(defun zk-convert-idea-to-file (file-name file-location template-text)
  "Конвертирует текущую идею в файл.

Имя файла генерируется из результата функции `zk-new-id' и параметра `file-name'
с расширением `.org'. Файл будет создан в директории `file-location'.
Текст файла будет состоять из строки `template-text' и содержимого текущей записи в `org-mode'.
"
  (let* ((id (zk-new-id))
         (note-title (org-get-heading))
         (note-title-prop (format "#+TITLE: %s" note-title))
         (note-entry (org-get-entry))
         (name (format "%s--%s.org" id file-name))
         (path (file-name-concat file-location name))
         (timestamp (format-time-string "%Y-%m-%d"))
         (template-text (replace-regexp-in-string "#\\+TITLE: TODO_PUT_TITLE"
                                                  note-title-prop
                                                  template-text
                                                  t))
         (template-text (replace-regexp-in-string "%U"
                                                  timestamp
                                                  template-text
                                                  t)))
    (find-file path)
    (goto-char (point-max))
    (insert template-text)
    (insert note-entry)))

(defun zk-convert-idea-to-note (file-name)
  "Конвертирует текущую идею в заметку."
  (interactive "sИмя файла: ")
  (zk-convert-idea-to-file file-name
                           (file-name-concat nz/org-directory "30-notes")
                           (zk-capture-note-template)))

(defun zk-convert-idea-to-reference (file-name)
  "Конвертирует текущую идею в отылку."
  (interactive "sИмя файла: ")
  (zk-convert-idea-to-file file-name
                           (file-name-concat nz/org-directory "20-refs")
                           (zk-capture-reference-template)))

(defun zk-add-current-buffer-to-index ()
  "Добавляет текущий буфер (заметку или отсылку) в индекс."
  (interactive)
  (let* ((path         (buffer-file-name))
         (id           (zk-get-id-from-file-path path))
         (title        (org-get-title))
         (link         (format "[[zk:%s][%s]]" id title))
         (buffer-err   "Текущий буфер не является заметкой или отсылкой")
         (heading-name (cond
                         ((string-match-p "20-refs" path) "Отсылки")
                         ((string-match-p "30-notes" path) "Заметки")
                         (t (error buffer-err)))))
    (org)
    (let ((ideas-marker (org-find-exact-headline-in-buffer heading-name)))
      (when (null ideas-marker)
        (error "Не удалось найти заголовок '%s' для вставки ссылки"
               heading-name))
      (goto-char ideas-marker)
      (org-insert-subheading nil)
      (insert link))))

(setq org-capture-templates
      '(("t" "Task (Задача)" entry
         (file+headline nz/org-capture-file "Задачи")
         "* ДЕЛА %?\n  %i\n  %a"
         :empty-lines-before 1)

        ("i" "Idea (Идея)" entry
         (file+headline nz/org-capture-file "Идеи")
         "\
* %?\n\n\
%i\n\
Записано: %T\n\
Контекст: %a\n"
         :empty-lines-before 1)

        ("n" "Note (Заметка)" plain
         (function zk-capture-note-location)
         (function zk-capture-note-template))

        ("r" "Reference (Отсылка)" plain
         (function zk-capture-reference-location)
         (function zk-capture-reference-template))

        ("e" "Experimental (Экспериментальная запись)" entry
         (file+headline nz/org-capture-file "Заметки")
         "\
* %?\n\n\
%i\n\
:PROPERTIES:\n\
:CreatedAt: %T\n\
:END:\n\n\
Записано: %T\n\
Контекст: %a\n\
Файл: %f\n\
ФАЙЛ: %F\n"
         :empty-lines-before 1)
        ))

(defun nz/org-agenda ()
  "Запуск повестки дня с явно указанными файлами из переменной `nz/org-files'."
  (interactive)
  (let ((org-agenda-files nz/org-files))
    (org-agenda)))

(keymap-global-set "C-c a" 'nz/org-agenda)
(keymap-global-set "C-c n n" 'org-capture)

(defun nz/org-mode-hook ()
  "Настройка всякого для ОРГ режима."
  (setq-local whitespace-line-column 500) ; для длинных ссылок
  (modify-syntax-entry ?< "." org-mode-syntax-table) ; фикс для < в лиспе в сорс блоках
  (modify-syntax-entry ?> "." org-mode-syntax-table) ; фикс для > в лиспе в сорс блоках
  (define-key org-mode-map (kbd "C-c x") 'org-toggle-checkbox)
  (define-key org-mode-map (kbd "C-c i") 'org-info))

(add-hook 'org-mode-hook 'nz/org-mode-hook)

(setq org-publish-project-alist
      `(("notes"
         :base-directory ,nz/org-directory
         :publishing-directory ,nz/org-publish-directory
         :recursive t
         :publishing-function org-html-publish-to-html)))




(org-link-set-parameters "zk"
                         :follow #'org-zk-open
                         :export #'org-zk-export
                         :store #'org-zk-store-link)

(defun zk (id)
  "Обработчик ссылок на заметки Zettelkasten."
  ;; ДЕЛА расширить АПИ чтобы после ID
  ;;      можно было указать поисковый терм по телу заметки
  ;;      аналогично файловым ссылкам
  (find-file (zk-find-file-path id)))

(defun zk-new-id ()
  "Создать новый ИД заметки."
  (format-time-string "%y%m%d%H%M%S"))

(defun zk-find-file-path (id)
  "Найти файл заметки по ИД `id' и вернуть его путь."
  (let* ((mask-re   (concat "/" id "[^.]+\\.org$"))
         (refs-dir  (file-name-concat nz/org-directory "20-refs"))
         (notes-dir (file-name-concat nz/org-directory "30-notes"))
         (files     (nz/directory-get-files refs-dir mask-re))
         (files     (if (null files)
                        (nz/directory-get-files notes-dir mask-re)
                      files)))
    (if (null files)
        (error "Заметка не найдена по ИД: %s" id)
      (car files))))

(defun zk-get-id-from-file-path (path)
  "Вычислить ИД на основе имени файла `path'."
  (let* ((name-ext (file-name-nondirectory path))
         (name     (file-name-sans-extension name-ext)))
    (substring name 0 12)))

(defcustom org-zk-command 'zk
  "The Emacs command to be used to display a Zettelkasten note."
  :group 'org-zk
  :type '(choice (const note) (const ref)))

(defun org-zk-open (path _)
  "Visit the note on PATH.
     PATH should be a Zettelkasten note ID."
  (funcall org-zk-command path))

(defun org-zk-store-link ()
  "Store a link to a Zettelkasten note."
  (when (memq major-mode '(org-mode))
    ;; This is a Zettelkasten note, we do make this link.
    (let* ((id (org-zk-get-id))
           (link (concat "zk:" page))
           (description (org-zk-get-title)))
      (org-link-store-props
       :type "zk"
       :link link
       :description description))))

(defun org-zk-get-id ()
  "Extract the note ID from the buffer name."
  ;; This works for `org-mode'.
  (let ((name (buffer-name)))
    (if (string-match "^\\([0-9]+\\)--" name)
        (match-string 1 name)
      (error "Cannot get note id from buffer name: %s" name))))

(defun org-zk-get-title ()
  "Extract the note title from the buffer name."
  ;; This works for `org-mode'.
  (let ((name (buffer-name)))
    (if (string-match "^\\([0-9]+\\)--\\([^\\.]+\\)\\.org$" name)
        (match-string 2 name)
      (error "Cannot get note title from buffer name: %s" name))))

(defun org-zk-export (link description format _)
  "Export a zettelkasten note link from Org files."
  ;; TODO: replace target file extension
  (let ((path (zk-find-file-path link))
        (desc (or description link)))
    (pcase format
      (`html (format "<a target=\"_blank\" href=\"%s\">%s</a>" path desc))
      (`latex (format "\\href{%s}{%s}" path desc))
      (`texinfo (format "@uref{%s,%s}" path desc))
      (`ascii (format "%s (%s)" desc path))
      (_ path))))




;; Пакетный менеджер
;;
;; Гайд https://stable.melpa.org/#/getting-started
;;
;; M-x package-refresh-contents  Обновить список пакетов
;; M-x package-list-packages     Показать список пакетов
;; M-x package-install           Установить пакет
;;
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; Автоустановка пакетов
;;
(unless (package-installed-p 'which-key)
  (package-refresh-contents)
  (package-install-selected-packages))

;; Фуззи-автокомплит
;; IVY (из пакета counsel)
;; Дока: https://elpa.gnu.org/packages/doc/ivy.html#Key-bindings
;;
(ivy-mode 1)
(setopt ivy-use-virtual-buffers t)
(setopt enable-recursive-minibuffers t)
(setopt ivy-count-format "(%d/%d) ")
(keymap-global-set "C-s" 'swiper-isearch)
(counsel-mode)


;; Работа с проектами
;; Дока: https://docs.projectile.mx/projectile/index.html
;;
(projectile-mode +1)
;; Комбинация, начинающаяя команды projectile
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-project-search-path nz/projects-directories)
(add-to-list 'projectile-globally-ignored-directories ".vs")

;; Экран запуска
;; Дока: https://github.com/emacs-dashboard/emacs-dashboard
;;
(require 'dashboard)
(dashboard-setup-startup-hook)
(setq dashboard-projects-backend 'projectile)
(setq dashboard-items '((recents   . 5)
                        (projects  . 5)
                        (agenda    . 5)
                                        ;(bookmarks . 5)
                                        ;(registers . 5)
                        ))
(setq dashboard-item-shortcuts '((recents   . "r")
                                 (projects  . "p")
                                 (agenda    . "a")
                                        ;(bookmarks . "m")
                                        ;(registers . "e")
                                 ))
(setq dashboard-startup-banner 'ascii)
(setq nz/dashboard-banner-ascii-1 "\
++---========================---++\n\
-=>> THE POWER OF LISP SYSTEM <<=-\n\
++---========================---++")
(setq nz/dashboard-banner-ascii-2 "\
⣿⣿⣿⣿⣿⣿⣿⣿⢁⠁⣿⠀⣿⣿⡏⣿⢸⡇⣿⣿⢸⢿⣿⣿⣿⠇⣿⡇⣜⣩⠽⠻⠿⣷⡀⣿⡇⣿⡧⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⣿⣿⣿⣿⣿⣿⣿⣿⢸⠀⣿⡇⣿⣿⡇⣿⢸⣷⢸⣿⡘⡘⣿⣿⣿⢰⣿⢱⢃⡀⠀⠀⠀⠈⠃⢹⠇⣿⠇⠆⡆⢰⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⣿⣿⣿⣿⣿⣿⣿⣿⢸⠀⢻⡇⢸⡟⣿⢸⡌⣿⡈⣿⡇⠇⣿⣿⣿⢸⠇⣾⣿⡇⢀⠀⠀⡷⢰⠸⢰⡿⠈⠀⡇⠘⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⣿⣿⣿⣿⣿⣿⣿⣿⡄⠰⠘⣇⠈⢧⠹⡄⠳⣘⣃⣹⣃⣀⣹⣿⣟⣘⣸⣿⣿⣿⣦⣭⣼⣷⣿⣿⠇⠠⠘⢰⠃⢀⡄⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠹⡐⡈⢆⠱⠸⣿⣿⣿⣿⣿⣿⣿⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⣀⠔⡀⡜⠀⢈⡇⡀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣤⡀⠈⢦⣀⠀⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⣬⠁⠌⠀⣰⠀⣼⡇⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡈⠍⢣⡈⢿⣿⣿⣿⣿⣝⣛⣿⣿⣻⣿⣿⣿⣿⡿⢋⡼⠃⠘⣠⣾⣿⠀⢿⣷⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⣿⣿⣿⣿⣦⣀⡑⠀⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠉⠀⠛⣡⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⣿⣿⣿⣿⣿⣿⣿⣿⠏⣴⣷⣦⡙⢿⣿⣿⣿⣿⣿⡆⢀⡀⣌⡉⠛⠿⠛⣋⣥⡆⡨⠐⢶⣿⣿⣿⣿⣿⣿⠟⣋⣥⣦⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣄⢛⠛⢿⣿⣿⡆⢆⢡⣬⡙⠗⣒⠻⢋⣥⡅⠔⠁⣾⣿⣿⡿⠿⠟⣡⣾⣿⣿⣿⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⣿⣿⣿⣿⣿⠟⡉⢡⡌⣿⣿⣿⣿⡇⣾⣿⡆⢨⣄⠲⢮⡀⢿⣿⣆⣿⣠⣿⠟⠁⣢⣶⣶⡌⡅⣶⣿⡆⣿⣿⣿⠿⡏⣼⢙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿\n\
⠀⠀⠈⠀⢡⡞⠡⢤⣆⢈⠍⣷⣬⡁⠙⢿⡇⡜⣿⣿⡦⠉⠀⡁⠀⠀⠀⢀⠈⠛⢿⣿⣿⢃⢣⣿⠟⠐⣋⣿⠀⢄⣤⣙⣀⠳⣌⣛⡛⠛⠛⠛⠛⠛⠛")
(setq nz/dashboard-banner-ascii-3 "\
⠀⠀⣠⣤⣄⣾⣿⡷⣠⣴⣶⣿⣿⣿⣿⣿⣿⣷⣶⣤⡀\n\
⠀⣼⠋⠀⣾⡟⣳⣾⣿⡿⣿⣿⣿⠟⣿⣿⣿⣿⣿⣿⣿⣷⣄\n\
⠀⡇⠀⠀⠉⢱⣿⣿⡿⢰⣿⣿⠃⢰⣿⣿⣿⣿⣿⡟⢿⣿⣿⣷\n\
⠀⠁⠀⠀⠀⣿⣿⣿⠇⣼⣿⠇⡀⢸⡿⣿⣿⣿⡿⠁⢸⣿⣿⣿⡇\n\
⠀⠀⠀⠀⢰⢰⣿⡿⢀⣸⣿⣤⣿⡈⡇⢿⣿⡿⢁⡎⢸⣿⡇⣿⣿\n\
⠀⠀⠀⠀⣼⢸⣿⡇⣸⣤⣶⣶⣤⣽⣷⣼⡯⠐⠿⢇⣿⡿⠀⣿⣿\n\
⠀⠀⠀⠀⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣹⡦⠂⣿⣿\n\
⠀⠀⠀⠀⣿⡁⣿⡇⠻⣿⣿⣿⣧⣙⠛⣛⣿⣿⣿⣿⣿⠡⠂⣿⡏\n\
⠀⠀⠀⠀⣿⣧⣙⡇⠲⢀⣉⠛⠛⠿⠿⠿⣿⣿⡿⠿⠋⣴⢀⣿⠃\n\
⠀⠀⠀⣸⣿⡿⣿⡟⢠⣿⣿⢷⣦⢠⣤⣤⣤⠰⣶⣶⣿⠃⣼⣡\n\
⠀⠀⢠⣿⡿⢠⣿⢡⣿⣿⠃⣾⡇⣸⢸⣿⣿⡇⡿⢿⣿⣿⣿⣿")
(setq nz/dashboard-banner-ascii-4 "\
⠄⢂⠢⢨⣶⡾⢷⣦⡅⡂⠅⡡⢁⠂⡂⡂⢅⢑⣴⣾⠾⣮⣌⢐⠠⠄\n\
⠄⢂⢊⢿⡏⠡⠂⢽⡗⢌⢂⠢⡁⠪⡐⠄⢕⢸⣿⠑⠡⢸⡿⢐⠨⠄\n\
⠄⠅⡢⡙⠿⣾⢼⠟⡕⡑⢔⠡⡊⢌⠢⡑⡑⡌⡻⢷⢷⠟⢍⠢⡁⠂\n\
⠄⠌⡂⡪⡑⡆⣇⣣⣱⣸⣰⣱⣜⣬⣪⣬⣦⣣⣎⣖⣔⣕⢅⢕⠨⠄\n\
⠄⡑⣬⣺⡾⣿⣿⣻⣯⣿⣟⣿⣽⣿⣻⣿⣾⢿⣻⣿⣻⣯⣿⣲⢅⠄\n\
⠄⢪⢗⣯⡏⠙⣯⣿⣯⣷⣿⣿⣽⣾⣿⢷⣿⡿⣿⣻⠝⢓⡷⡯⡣⠄\n\
⠄⠈⢝⢞⡿⣦⡀⠙⠯⢿⢷⣿⣽⢿⣾⢿⡯⡟⠏⢁⢤⡿⡝⡕⠁⠄\n\
⠄⠄⠄⠑⠝⣗⣟⡷⣤⣀⣁⠈⠈⠉⠊⣁⡠⣤⢶⣻⢽⠱⠑⠄⠄⠄\n\
⠄⠄⠄⠄⠄⠐⠸⠹⠽⡽⣽⣻⣻⣟⣟⣷⣻⢽⢫⠣⠃⠄⠄⠄⠄⠄\n\
⠄⠄⠄⠄⠄⠄⠄⠈⠁⠣⢣⢓⢗⢳⢹⢸⠸⠈⡀⠄⠄⠄⠄⠄⠄⠄")
(setq nz/dashboard-banner-ascii-5 "\
⠀⠀⠀⠀⣠⣾⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣶\n\
⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⣶⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿\n\
⠀⠀⣼⣿⣿⠋⠀⠀⠀⠀⠀⠛⠛⢻⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿\n\
⠀⢸⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿\n\
⠀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿\n\
⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡟⢹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿\n\
⠀⣿⣿⣷⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀⠀⢻⣿⣿⡄⠀⠀⠀⠀⠀⠀⣿⣿⡿\n\
⠀⢸⣿⣿⡆⠀⠀⠀⠀⣴⣿⡿⠃⠀⠀⠀⠈⢿⣿⣷⣤⣤⡆⠀⠀⣰⣿⣿\n\
⠀⠀⢻⣿⣿⣄⠀⠀⠾⠿⠿⠁⠀⠀⠀⠀⠀⠘⣿⣿⡿⠿⠛⠀⣰⣿⣿\n\
⠀⠀⠀⠻⣿⣿⣧⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠏\n\
⠀⠀⠀⠀⠈⠻⣿⣿⣷⣤⣄⡀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⠟")
(setq dashboard-banner-ascii
      (nz/list-pick-random
       (list nz/dashboard-banner-ascii-1
             nz/dashboard-banner-ascii-2
             nz/dashboard-banner-ascii-3
             nz/dashboard-banner-ascii-4
             nz/dashboard-banner-ascii-5)))

;(setq dashboard-week-agenda t)
;(setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)

(keymap-global-set "C-c d" 'dashboard-open)
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))


;; Подсветка цветовых литералов в текущем буфере
;;
;; Вызвать M-x rainbow-mode
;;


;; Редактирование кода C
;;

;; M-C-\       Отформатировать код в выделенном регионе
;; M-/         Автодополнить символ

;; Форматировать C код в стиле K&R
(setq c-default-style "k&r"
      c-basic-offset 4)

;; Хук от dumb-jump для кодонавигации
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)


;; Работа с гитом (magit)
;;
;; C-x g   Получить статус git (режим magit)
;;
;; В режиме magit
;;
;; n, p    Навигация по изменениям
;; s       Застейджить изменения
;; k       Отбросить изменения
;; i t     Заигнорить файл
;; C-c C-c Закоммитить
;; P u     Пушнуть
;;
(setq magit-display-buffer-function 'magit-display-buffer-fullframe-status-topleft-v1)
(setq magit-bury-buffer-function 'magit-restore-window-configuration)

(defun nz/magit-mode-hook ()
  "Настройка всякого для magit режима."
  (whitespace-mode -1))

(add-hook 'magit-mode-hook 'nz/magit-mode-hook)


;; Сборка и компиляция
;;

;; M-x compile Запуск компиляции из командной строки
;; C-c c       Запуск compile

(keymap-global-set "C-c c" 'compile)
(keymap-global-set "C-c e" 'eshell)


;; Редактирование многокурсорное
;;

;; RET Заканчивает мультикурсорность
;; C-g Тоже заканчивает мультикурсорность

(require 'multiple-cursors)

;; После выделения региона установить множественные курсоры
(keymap-global-set "C-S-c C-S-c" 'mc/edit-lines)

;; Создать курсор поиском слова под курсором
(keymap-global-set "C->" 'mc/mark-next-like-this)
(keymap-global-set "C-<" 'mc/mark-previous-like-this)
(keymap-global-set "C-c C-<" 'mc/mark-all-like-this)
(keymap-global-set "C-\"" 'mc/skip-to-next-like-this)
(keymap-global-set "C-:" 'mc/skip-to-previous-like-this)

;; Создать курсок кликнув мышкой в нужное место
(keymap-global-set "C-S-<mouse-1>" 'mc/add-cursor-on-click)


;; Справка по хоткеям
;;
;; При наборе неполной комбинации после задержки в 1 секунду
;; открывает минибуффер с подсказкой, о том, как можно данную
;; комбинацию продолжить.
;;
(require 'which-key)
(which-key-mode)
(setq which-key-side-window-location 'right)


;; Работа с тегами
;;

;; M-g g Перейти к строке по номер
;; M-.   Поиск идентификатора под курсором
;; M-,   Прыгнуть к последнему месту вызова M-.
;; C-M-, Прыгнуть к последнему месту вызова M-,
;; C-M-i Автокомплит

(defun tags-create (dir-path)
  "Создать файл тегов."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags -f TAGS -e -R %s" (directory-file-name dir-path))))

(defun config ()
  "Перейти к файлу конфигурации"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun org ()
  "Перейти к ОРГ файлу заметок"
  (interactive)
  (when (not (null nz/org-files))
    (find-file (car nz/org-files))))

(defun prj ()
  "Перейти к директории проектов"
  (interactive)
  (if (file-directory-p "C:/prj")
      (find-file "C:/prj/")
    (find-file "~/prj")))

(defun ag (term)
  "Поиск с помошью ag"
  (interactive "MTerm: ")
  (compile
   (format "ag --ignore-case --vimgrep %s %s" term default-directory)))

(defun git-grep (term)
  "Поиск с помошью гита"
  (interactive "MTerm: ")
  (compile (format "git --no-pager grep -n %s" term)))

(defun git-grep-id-at-point ()
  "Поиск с помошью гита ид под курсором"
  (interactive)
  (compile (format "git --no-pager grep -n %s" (thing-at-point 'symbol))))

(defun find-usages-at-point ()
  "Поиск с помошью xref ид под курсором"
  (interactive)
  (xref-find-apropos (thing-at-point 'symbol)))

(keymap-global-set "C-S-g" 'git-grep)
(keymap-global-set "C-c g" 'git-grep-id-at-point)
(keymap-global-set "C-c f" 'find-usages-at-point)


(defun nz/shell-command-to-string (cmd)
  (replace-regexp-in-string "\r?\n$" "" (shell-command-to-string cmd)))

(defun nz/build ()
  "Запуск скрипта компиляции"
  (interactive)
  (let ((project-dir (nz/shell-command-to-string "git rev-parse --show-toplevel")))
    (compile (format "cd %s && build.cmd" project-dir))))

(defun nz/run ()
  "Запуск скрипта запуска"
  (interactive)
  (let ((project-dir (nz/shell-command-to-string "git rev-parse --show-toplevel")))
    (compile (format "cd %s && run.cmd" project-dir))))

(defun nz/test ()
  "Запуск скрипта тестирования"
  (interactive)
  (let ((project-dir (nz/shell-command-to-string "git rev-parse --show-toplevel")))
    (compile (format "cd %s && test.cmd" project-dir))))

(defun nz/package ()
  "Запуск скрипта упаковки дистрибутива ПО"
  (interactive)
  (let ((project-dir (nz/shell-command-to-string "git rev-parse --show-toplevel")))
    (compile (format "cd %s && package.cmd" project-dir))))


(keymap-global-set "<f5>" 'nz/run)
(keymap-global-set "<f6>" 'nz/build)
(keymap-global-set "<f7>" 'nz/test)


;; Заметки - ЗАМОРОЖЕНО (будем юзать орг-режим)
;;

;; (defvar nz/note-root-dir "~/.emacs.d/my-notes"
;;   "Путь к папке с заметками")
;;
;; (setq nz/note-root-dir "c:/nz/notes")
;;
;; (defun nz/note-new ()
;;   "Создать заметку"
;;   (interactive)
;;   (when (not (file-directory-p nz/note-root-dir))
;;     (make-directory nz/note-root-dir))
;;   (let ((note-name (format-time-string "%Y-%m-%d_%H%M%S.temp")))
;;     (let ((note-path (format "%s/%s" nz/note-root-dir note-name)))
;;       (find-file note-path))))
;;
;; (defun nz/note-list ()
;;   "Показать заметки"
;;   (interactive)
;;   (dired nz/note-root-dir))
;;
;; (keymap-global-set "C-c n" 'nz/note-new)
;; (keymap-global-set "C-c C-n" 'nz/note-list)

;; Режим языка программирования `sukabla'
(require 'sukabla-mode)

;; Настройки для работы с ЯП `scheme'
;;

(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Switch to interactive Scheme buffer." t)
(setq auto-mode-alist (cons '("\\.ss" . scheme-mode) auto-mode-alist))


;; ДЕЛА хук на открытие файла - если он в заметках - добавлять в файл истории с датой открытия
;;      если он там уже есть то двигать наверх и обновлять дату
;; ДЕЛА просмотр истории
;; ДЕЛА поиск по истории
;; ДЕЛА открытие заметки напрямую из истории

;; ИДЕИ
;;
;; Оформить стартовую страничку
;; - Recent files
;; - List of projects
;;
;; Нормальное окно поиска файлов
;;

;; Отложено
;;
;; - eww: встроенный браузер
;;   причина: не умеет в яваскрипт, в современном говглвебе - не дееспособен
;;
