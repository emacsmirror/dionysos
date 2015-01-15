;;; dionysos-files-mode.el --- Dionysos music files mode

;; Copyright (C) 2015 Nicolas Lamirault <nicolas.lamirault@gmail.com>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Commentary:

;;; Code:

(require 'cl-lib)
(require 'f)


(require 'dionysos-backend-vlc)
(require 'dionysos-mode)


;; Management

(defun dionysos-files-mode-start ()
  (interactive)
  (let ((filename (thing-at-point 'line)))
    (message "Playing : %s %s " filename (type-of filename))
    (dionysos--vlc-start (string-trim filename) 'next-action)))

(defun dionysos-files-mode-stop ()
  (interactive)
  (dionysos--vlc-stop))

(defun dionysos-files-mode-next ()
  (interactive)
  (beginning-of-line)
  (forward-line 1)
  (dionysos-files-mode-stop)
  (dionysos-files-mode-start))

(defun dionysos-files-mode-previous ()
  (interactive)
  (beginning-of-line)
  (forward-line -1)
  (dionysos-files-mode-stop)
  (dionysos-files-mode-start))

(defun next-action ()
  "Next action after process end."
  (dionysos-files-mode-next)
  (dionysos-files-mode-start))

(defun dionysos-files-mode-quit ()
  "Stop player and exit."
  (interactive)
  (dionysos-files-mode-stop)
  (kill-buffer "*Dionysos*"))


;; Mode

(defvar dionysos-files-mode-hook nil)

(defvar dionysos-files-mode-map
  (let ((map (make-keymap)))
    (define-key map (kbd "q") 'dionysos-files-mode-quit)
    (define-key map (kbd "p") 'dionysos-files-mode-previous)
    (define-key map (kbd "n") 'dionysos-files-mode-next)
    (define-key map (kbd "RET") 'dionysos-files-mode-start)
    (define-key map (kbd "SPC") 'dionysos-files-mode-stop)
    map)
  "Keymap for `dionysos-files-mode' major mode.")

(define-derived-mode dionysos-files-mode dionysos-mode "Dionysos Files"
  "Major mode for Dionysos files buffers."
  :group 'dionysos)

(put 'dionysos-files-mode 'mode-class 'special)

(defun dionysos--files-buffer ()
  "Return a Dionysos files buffer."
  "*Dionysos*")

(defvar dionysos-files-mode-history nil)

;;;###autoload
(defun dionysos-files (directory)
  "Switch to a Dionysos files buffer using `DIRECTORY'."
  (interactive
   (list (read-from-minibuffer "Music directory : "
                               (car dionysos-files-mode-history)
                               nil
                               nil
                               'dionysos-files-mode-history)))
  (pop-to-buffer (dionysos--files-buffer) nil)
  (mapc (lambda (filename)
          (insert
           (format "%s\n" filename)))
           ;;         (colorize-term filename 'green))))
        (dionysos--list-directory directory))
  (dionysos-files-mode))


(provide 'dionysos-files-mode)
;;; dionysos-files-mode.el ends here
