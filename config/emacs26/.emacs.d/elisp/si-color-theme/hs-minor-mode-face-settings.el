;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-18 23:16:44 Saturday by taoshanwen>

;; This  file is free  software; you  can redistribute  it and/or
;; modify it under the terms of the GNU General Public License as
;; published by  the Free Software Foundation;  either version 3,
;; or (at your option) any later version.

;; This file is  distributed in the hope that  it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR  A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You  should have  received a  copy of  the GNU  General Public
;; License along with  GNU Emacs; see the file  COPYING.  If not,
;; write  to  the Free  Software  Foundation,  Inc., 51  Franklin
;; Street, Fifth Floor, Boston, MA 02110-1301, USA.

(defun hs-minor-mode-face-settings ()
  "Face settings for `hideshow'."
  (defface hs-block-flag-face
    '((((type tty pc)) :foreground "white" :background "red")
      (t :foreground "#AF210000AF21" :background "lightgreen" :box (:line-width -1 :style released-button)))
    "Face of hs minor mode block flag."))

(eval-after-load "hideshow"
  `(hs-minor-mode-face-settings))

(provide 'hs-minor-mode-face-settings)
