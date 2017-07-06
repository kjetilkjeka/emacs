;; Beggining  of .emacs file
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This file is the initialation file of emacs.
;; It specifies the custimazation of emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Some c-mode options
;;
;;;;;;;;;;;;;;;;;;;;;;,

(setq c-default-style "linux"
          c-basic-offset 4)



;; Add MELPA
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


;; Litt e-mail + gnus stuff
;;


;; Color and graphics custimazation
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(set-background-color "black")
(set-foreground-color "green")


;; General options
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(column-number-mode 1)
(tool-bar-mode -1) ;; removes the tool bar
;; (cua-mode 1) ;; Allows C-c, C-v and C-z for copy/paste
(scroll-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-startup-message t) ;; Don't show the lame upstart buffer
(fset 'yes-or-no-p 'y-or-n-p) ;; to lazy to write yes and no y-n instead

(require 'iso-transl)

;; Tex-command-list
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; The TeX-command-list is a list of commands executeable in TeX-mode.
;; C-c C-c and enter one of the commands.
;;
;; The structure of the commands is:
;; <Command-name> <Command> <Function> <Editable> <Accesible in>
;;
;; The Command name and Command is a string
;; The Function tells something about the output. Full description avilable in tex.el
;; Editable is true if the command should be able to be editted before execution
;; Accesable in is true if accesible in all modes, else it's a list of wich modes it should be accesible in
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq TeX-command-list
(list
(list "PDFLaTeX" "pdflatex '\\nonstopmode\\input{%t}'" 'TeX-run-TeX nil t)
(list "LaTeX" "latex '\\nonstopmode\\input{%t}'" 'TeX-run-TeX nil t)
(list "View" "%V" 'TeX-run-discard nil t)
(list "dvi2ps" "dvips %s.dvi" 'TeX-run-format nil t)
(list "dvi2pdf" "dvipdfm %s.dvi" 'TeX-run-format nil t)
(list "ps2pdf" "ps2pdf %s.ps" 'TeX-run-command nil t)
(list "ViewPDF" "evince %s.pdf" 'TeX-run-command nil t)
(list "ViewPS" "evince &s.ps" 'TeX-run-command nil t)
(list "Check" "lacheck %s" 'TeX-run-compile nil t)
(list "Other" "" 'TeX-run-command t t)
(list "Clean" "(TeX-clean t)" 'TeX-run-function nil t)
))


;; Latex-skeltons + abbrevs
;;
;;

(setq-default abbrev-mode t)
(setq save-abbrevs nil)

(define-skeleton latex-preamble-document-skeleton
"Inserts the LaTeX preamble to any document"
nil
"\\documentclass[11pt]{article}\n\n"

"\\usepackage[norsk]{babel}\n"
"\\usepackage[utf8]{inputenc}\n"
"\\usepackage{amsmath, amssymb, amsthm}\n"
"\\usepackage{graphicx, float}\n"
"\\usepackage{pstricks-add}\n\n\n"

"\\author{Kjetil Kjeka}\n"
"\\title{"_"}\n"
"\\date{\\today}\n\n\n"

"%Slik at matriser kan defineres med linjer\n"
"\\makeatletter\n"
"\\renewcommand*\\env@matrix[1][*\\c@MaxMatrixCols c]{%\n"
"  \\hskip -\\arraycolsep\n"
"  \\let\\@ifnextchar\\new@ifnextchar\n"
"  \\array{#1}}\n"
"\\makeatother\n\n\n\n\n"

"\\begin{document}\n\n\n\n\n\n\n\n\n\n\n"

"\\end{document}"
)



(define-skeleton latex-bf-skeleton
"Inserts textbf"
nil
"\\textbf{"_"}"
)

(define-abbrev-table 'LaTeX-mode-abbrev-table '(
("latexdocument" "" latex-preamble-document-skeleton 0)
("bf" "" latex-bf-skeleton 0)
))

;; fiks denne her

(add-hook 'LaTeX-mode-hook
	  (lambda ()
	    (setq local-abbrev-table LaTeX-mode-abbrev-table)))






;; Definere noen funksjoner??
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; duplicate linje eller region funksjon

(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Drag stuff
;;

(add-to-list 'load-path "~/emacs/drag-stuff")
(require 'drag-stuff)
(drag-stuff-global-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; Definere generelle keybindings?
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)
(global-set-key (kbd "C-+") 'expand-abbrev)
(global-set-key (kbd "C--") 'unexpand-abbrev)

;; ecb keybindings
(define-prefix-command 'ecb-keybindings)
(global-set-key (kbd "C-x C-e") 'ecb-keybindings)

(global-set-key (kbd "C-x C-e w") 'ecb-toggle-ecb-windows)
(global-set-key (kbd "C-x C-e 1") 'ecb-goto-window-edit1)
(global-set-key (kbd "C-x C-e d") 'ecb-goto-window-directories)
(global-set-key (kbd "C-x C-e s") 'ecb-goto-window-sources)
(global-set-key (kbd "C-x C-e m") 'ecb-goto-window-methods)


;; Litt andre ecb ting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;
;;
;;
;;
;; End of .emacs
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
