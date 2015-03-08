(in-package :stumpwm)
(loop for file in '("cpu" "disk" "net" "wifi" "battery-portable")
   do (load-module file))

(setf *time-modeline-string* "%a %m-%d ^5*^B%l:%M^b^n"
      *mode-line-position* :top)

(setf stumpwm:*screen-mode-line-format*
      (list
       "^B[^b"
       "^2*%n^n"
       "^B]^b "
       ;; "^7*^B%W^b^n "
       ;; " ^5*/home:^n "
       ;; '(:eval (read-file ".dfhome"))
       ;; "^5*/^n ^6 Running:^n "
       ;; '(:eval (read-file ".inxin"))
       "^5*/^n ^7*^n%W^b^n "
       "^>" ; right align
       ;;"^6*"
       ;;'(:eval (format-gmail nil))
       ;;"^n" ;;;" ^4[^6*^B%g^b^4]^n < "
       ;; "^B|^b "
       ;; "MIX:^5 "
       ;; '(:eval (read-file "/home/alvin/.amix"))
       "^n^B | ^b"
       "%C" ; cpu
       "^B | ^b"
       "^6*[^n^B%I^b^6*]^n"
       "^B | ^b"
       "%l" ; net
       ;; "^B | ^b "
       ;; ;;"^7*^Bµ^b^n "
       ;; '(:eval (read-file "/home/alvin/.inet"))
       "^B | ^b"
       ;; "%D" ; disk
       ;; "^B | ^b"
       ;; "%B" ; battery
       ;; "^B | ^b"
       '(:eval (string-right-trim '(#\Newline) (run-shell-command "date +'^B%m-%d ^6*%R ^b'" t)))
       ))

(defcommand mode-line-update () ()
  "Update all mode lines."
  (update-all-mode-lines))

(dolist (head
          (list (first (screen-heads (current-screen)))) ; first
         ;; (screen-heads (current-screen)) ; all
         )
  (enable-mode-line (current-screen) head
                    t *screen-mode-line-format*))
