;; Provides a function that lets you jump to an org heading using
;; whatever you have set up for completing-read

(require 'cl-lib)
(defun org-nav-get-regex-ocurrences-with-positions (regexp string)
  (save-match-data
    (let ((pos 0)
          matches)
      (while (string-match regexp string pos)
        (setq pos (match-end 0))
        (push `(,(match-string 0 string) . ,pos) matches))
      matches)))

(defun org-nav-get-buffer-headings ()
  (nreverse (org-nav-get-regex-ocurrences-with-positions
             org-heading-regexp (buffer-string))))

(defun org-nav-jump-to-heading ()
  (interactive)
  (let* ((buffer-headings (org-nav-get-buffer-headings))
         (selected-heading (completing-read "Heading: " (org-nav-get-buffer-headings) nil t)))
    (goto-char (+ 1 (cdr (cl-find-if
                          (lambda (el)
                            (string-equal (car el) selected-heading))
                          buffer-headings))))
    (org-show-entry)))
