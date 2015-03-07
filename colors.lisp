(ql:quickload :cl-utilities)
(ql:quickload :cl-ppcre)

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
