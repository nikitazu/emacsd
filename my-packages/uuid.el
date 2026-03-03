;;; uuid.el --- UUID implementation (v4, v7) -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Nikita B. Zuev
;;
;; Author: Nikita B. Zuev <nikitazu@gmail.com>
;; Maintainer: Nikita B. Zuev <nikitazu@gmail.com>
;; Created: Oct 20, 2025
;; Version: 0.1
;; Keywords: uuid, guid
;; URL: TBA
;; Package-Requires: ((emacs "26.1"))
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; `UUID' package provides a set of helpful functions
;; for generation of GUID version 4 and 7
;; and also formatting them to a string representation.
;;
;; See also: RFC-4122 https://www.rfc-editor.org/rfc/rfc4122.txt
;;           RFC-9562 https://www.rfc-editor.org/rfc/rfc9562.txt

;;; Code:

;;;; Customization

(defgroup uuid nil
  "Настройки для пакета `uuid'."
  :link '(url-link "TBA")
  :group 'uuid)

(defcustom uuid-format-lowercase nil
  "Установка данного флага в `t'
приводит к генерации строкового представления UUID в нижнем регистре."
  :type 'boolean
  :group 'uuid
  :safe 'booleanp)

;;;; Constants

(defconst uuid-size-bytes 16
  "Размер UUID в байтах")

(defconst uuid-min (make-vector uuid-size-bytes #x00)
  "Минимальный UUID")

(defconst uuid-max (make-vector uuid-size-bytes #xFF)
  "Максимальный UUID")

;;;; Commands

;;;###autoload
(defun uuid-generate-v4 ()
  "Вставить UUID v4 в текущую позицию под курсором."
  (interactive)
  (insert (uuid-to-string (make-uuid-v4))))

;;;###autoload
(defun uuid-generate-v7 ()
  "Вставить UUID v7 в текущую позицию под курсором."
  (interactive)
  (insert (uuid-to-string (make-uuid-v7))))

;;;; Functions

;;;;; Public

(defun make-uuid-v4 ()
  "Cоздать объект UUID (v4).

Возвращает числовой вектор размера `uuid-size-bytes' (16 элементов),
где каждый элемент представляет из себя байт структуры UUID.

UUID v4 - псевдо-случаен.
"
  (let ((v (make-vector uuid-size-bytes #x00)))
    (uuid--set-random-bytes v)
    (uuid--set-version-v4-bits v)
    (uuid--set-reserved-rfc4122-bits v)
    v))

(defun make-uuid-v7 ()
  "Cоздать объект UUID (v7).

Возвращает числовой вектор размера `uuid-size-bytes' (16 элементов),
где каждый элемент представляет из себя байт структуры UUID.

UUID v7 - основан на метке времени UNIX в левой части
          и дополнен псевдо-случайным числом в правой.
"
  (let ((v (make-vector uuid-size-bytes #x00)))
    (uuid--set-random-bytes v)
    (uuid--set-unix-ts-bytes v)
    (uuid--set-version-v7-bits v)
    (uuid--set-reserved-rfc4122-bits v)
    v))

(defun uuid-p (val)
  "Проверить является ли значение `val' UUID?"
  (and (vectorp val)
       (= (length val)
          uuid-size-bytes)))

(defun uuid-princ (val &optional no-dashes)
  "Вывести строковое представление объекта UUID из параметра `val'.

Параметр `no-dashes' при установке в `t' отключает вывод разделителей.
"
  (when (not (uuid-p val))
    (error "Not a UUID %s" val))
  (let ((byte-format (if uuid-format-lowercase "%02x" "%02X")))
    (dotimes (i (length val))
      (when (and (not no-dashes)
                 (or (= i 4)
                     (= i 6)
                     (= i 8)
                     (= i 10)))
        (princ "-"))
      (princ (format byte-format (aref val i))))))

(defun uuid-to-string (val &optional no-dashes)
  "Возвращает строковое представление объекта UUID из параметра `val'.

Параметр `no-dashes' при установке в `t' отключает добавление разделителей.
"
  (with-output-to-string
    (uuid-princ val no-dashes)))

;;;;; Private

(defun uuid--set-version-v4-bits (target-vector)
  ;; set version as v4 (bits 12, 13, 14, 15)
  ;; 4 = 0000 0100
  (let* ((position       6)
         (target-byte    (aref target-vector position))
         (bit-mask-ones  #x40)  ;; 0100 0000
         (bit-mask-zeros #x4F)) ;; 0100 1111
    (aset target-vector position
          (logand (logior target-byte bit-mask-ones)
                  bit-mask-zeros))))

(defun uuid--set-version-v7-bits (target-vector)
  ;; set version as v7 (bits 12, 13, 14, 15)
  ;; 7 = 0000 0111
  (let* ((position       6)
         (target-byte    (aref target-vector position))
         (bit-mask-ones  #x70)  ;; 0111 0000
         (bit-mask-zeros #x7F)) ;; 0111 1111
    (aset target-vector position
          (logand (logior target-byte bit-mask-ones)
                  bit-mask-zeros))))

(defun uuid--set-reserved-rfc4122-bits (target-vector)
  ;; set reserved bits (bit 6 = 0, bit 7 = 1)
  ;;
  (let* ((position       8)
         (target-byte    (aref target-vector position))
         (bit-mask-ones  #x80)  ;; 1000 0000
         (bit-mask-zeros #xBF)) ;; 1011 1111
    (aset target-vector position
          (logand (logior target-byte bit-mask-ones)
                  bit-mask-zeros))))

(defun uuid--set-random-bytes (target-vector)
  ;; convert 128-bit number (a b)
  ;; to big-endian (network-order) byte vector
  (let* ((a (random #xFFFFFFFFFFFFFFFF))
         (b (random #xFFFFFFFFFFFFFFFF)))
    (dotimes (i 8)
      (aset target-vector (-  7 i) (logand a #xFF))
      (aset target-vector (- 15 i) (logand b #xFF))
      (setq a (ash a -8)
            b (ash b -8)))))

(defun uuid--set-unix-ts-bytes (target-vector)
  ;; set 64-bit unix timestamp as  big-endian (network-order)
  ;; bytes vector at the beginning of a vector
  (let* ((current-time-list nil)
         (ts (current-time))
         (ms (car ts)))
    (dotimes (i 8)
      (aset target-vector (- 7 i) (logand ms #xFF))
      (setq ms (ash ms -8)))))

;; Provide the package
(provide 'uuid)

;;; uuid.el ends here
