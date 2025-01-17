;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 22:26:38 Monday by ahei>

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

(defun replace-face-settings ()
  "Face settings for `replace'."
  (custom-set-faces
   '(match
     ((((class color) (min-colors 88) (background light))
       :background "yellow1")
      (((class color) (min-colors 88) (background dark))
       :background "RoyalBlue3" :foreground "cyan")
      (((class color) (min-colors 8) (background light))
       :background "yellow" :foreground "black")
      (((class color) (min-colors 8) (background dark))
       :background "blue" :foreground "white")
      (((type tty) (class mono))
       :inverse-video t)
      (t :background "gray")))))

(eval-after-load "replace"
  `(replace-face-settings))

(provide 'replace-face-settings)
