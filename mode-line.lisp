(in-package :stumpwm)
(loop for file in '("cpu" "disk" "net" "wifi" "battery-portable")
   do (load-module file))

(defun read-ml-file (s)
  (read-file (str "/dev/shm/" s)))

(defun color-ping (s)
  (if (equal s "")
      ""
      (let* ((words (cl-ppcre:split "\\s+" s))
             (ping (nth 5 words))
             (color (bar-zone-color (read-from-string ping)
                                    300 700 1000))
             (colored-ping (format nil "^[~A~3D^]" color ping)))
        (cl-ppcre:regex-replace ping s colored-ping))))

(defun colour (key)
  (let ((colours '(:base03 #x002b36
                   :base02 #x073642
                   :base01 #x586e75
                   :base00 #x657b83
                   :blue0 #x373b43
                   :ypnose #x1c2027
                   :ypnosebl #x3e7ef3
                   :ypnosecy #x30a8e0
                   :blue1 #x242931
                   :base2 #xeee8d5
                   :base3 #xfdf6e3
                   :yellow #x99ad6a
                   :orange #xcb4b16
                   :red #xdc322f
                   :magenta #xd33682
                   :violet #x6c71c4
                   :blue #x268bd2
                   :cyan #x87ceeb
                   :dfx #x14db49
                   :pnevma #x000000
                   :green #x8ae234)))
    (getf colours key)))

(setf *time-modeline-string* "%a %m-%d ^5*^B%l:%M^b^n")

(setq stumpwm:*mode-line-position* :top)
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
       "^5*/^n ^7*^B%W^b^n "
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


(defcommand uaml () ()
  ""
  (update-all-mode-lines))

(dolist (head
          (list (first (screen-heads (current-screen)))) ; first
         ;; (screen-heads (current-screen)) ; all
         )
  (enable-mode-line (current-screen) head
                    t *screen-mode-line-format*))
