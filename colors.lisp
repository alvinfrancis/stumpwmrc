(ql:quickload :cl-utilities)
(ql:quickload :cl-ppcre)

(defun xr-color (label)
  (let* ((query (format nil "xrdb -query | grep ~a: | head -1" label))
         (match (run-shell-command query t))
         (pattern (format nil "^~a:\\s*(\#[a-fA-F0-9]{6})" label))
         (extract (nth-value 1 (cl-ppcre:scan-to-strings pattern match))))
    (when extract
      (elt extract 0))))

;; Use X resources to match colors
(labels ((list< (a b)
           (<= (parse-integer (first a))
               (parse-integer (first b)))))
  (let* ((input (cl-utilities:split-sequence
                 #\Newline (run-shell-command "xrdb -query | grep *color" t)))
         (pattern "^\*color([0-9]|10):\\s*(\#[a-fA-F0-9]{6})")
         (idx-colors (sort
                      (loop for color in input
                         when (coerce (nth-value 1 (cl-ppcre:scan-to-strings pattern color)) 'list)
                         collect it)
                      #'list<))
         (colors (mapcar #'second idx-colors)))
    (setf *colors* colors)))

(update-color-map (current-screen))
(let ((x-background (xr-color "\\*background"))
      (x-foreground (xr-color "\\*foreground"))
      (x-black (xr-color "\\*color0"))
      (x-bright-black (xr-color "\\*color8"))
      (x-red (xr-color "\\*color1")))
  (set-bg-color x-background)
  (set-border-color x-background)
  (set-fg-color x-foreground)
  (set-win-bg-color x-background)
  (set-focus-color x-foreground)
  (set-unfocus-color x-background)
  (setf *mode-line-background-color* x-background
        *mode-line-foreground-color* x-foreground
        *mode-line-border-color* x-black))
