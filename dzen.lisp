(in-package :stumpwm)

(defparameter *dzen-timeout* 1)
(defparameter *dzen-bg* "#000")
(defparameter *dzen-fg* "#fff")
(defparameter *dzen-height* 15)
(defparameter *dzen-font* "-*-montecarlo-medium-r-normal-*-11-*-*-*-*-*-*-*")
(defparameter *dzen-alignment* "c") ;; l for left, r for right, c for center
(defparameter *dzen-separator* " | ")
(defparameter *dzen-format*
  '(
    (:group
     (:color "#b50077")
     (:icon "/home/alvin/.local/share/subtle/icons/battery_vert3.xbm")
     (:color "#E0E0E0")
     (:fun fmt-charge-now))
    ;; (:group
    ;;  (:color "#ff3500")
    ;;  (:icon "/home/alvin/.local/share/subtle/icons/memory.xbm")
    ;;  (:color "#E0E0E0"))
    (:exec "date +\"%m/%d/%Y\"")
    (:group
     (:color "#5496ff")
     (:exec "date +\"%H:%M\""))))

(defun fmt-charge-now ()
  (format nil "~D%" (round (charge-now))))

(defun charge-now ()
  (* 100
     (/
      (parse-integer (run-shell-command "cat /sys/class/power_supply/BAT0/charge_now" t))
      (parse-integer (run-shell-command "cat /sys/class/power_supply/BAT0/charge_full" t)))))

(defun interpret-dzen-format (fmt)
  (case (first fmt)
    (:group (let ((res (mapcar #'interpret-dzen-format (rest fmt))))
              (format nil "~{~a~}^fg(white)" res)))
    (:exec (let* ((res (run-shell-command (second fmt) t))
                  (newline-pos (position #\Newline res)))
             (if newline-pos
                 (subseq res 0 newline-pos)
                 res)))
    (:color (format nil "^fg(~a)" (second fmt)))
    (:fun (apply (second fmt) (cddr fmt)))
    (:string (second fmt))
    (:icon (format nil "^i(~a) " (second fmt)))
    (:sysctl
     (interpret-dzen-format
      `(:exec ,(format nil "sysctl ~a | cut -d' ' -f2"
                       (second fmt)))))))

(defun get-mode-line-str ()
  (format nil (concat "~{~a~#[~:;" *dzen-separator* "~]~}")
          (mapcar #'interpret-dzen-format *dzen-format*)))

(let ((dzen-process nil))
  (defun launch-dzen2 ()
    (sb-thread:make-thread
     (lambda ()
       (resize-head 0 0 *dzen-height*
                    (head-width (current-head))
                    (- (head-height (current-head)) *dzen-height*))
       (let ((process (sb-ext:run-program "dzen2"
                                          (list "-bg" *dzen-bg* "-fg" *dzen-fg*
                                                "-h" (format nil "~d" *dzen-height*)
                                                "-fn" *dzen-font*
                                                "-ta" *dzen-alignment*
                                                "-e" "'button2=;'")
                                          :input :stream
                                          :wait nil
                                          :search t)))
         (setf dzen-process process)
         ;; TODO: when dzen get killed, stop the loop
         (with-open-stream (input (sb-ext:process-input process))
           (handler-case
               (loop while (sb-ext:process-alive-p process) do
                    (princ (get-mode-line-str) input)
                    (terpri input)
                    (force-output input)
                    (sleep *dzen-timeout*))
             (sb-int:simple-stream-error () (setf dzen-process nil))))))
     :name "dzen2-thread"))

  (defun kill-dzen2 ()
    (when dzen-process
      ;; Send the TERM signal
      (sb-ext:process-kill dzen-process 15)
      (close (sb-ext:process-input dzen-process))
      (setf dzen-process nil)
      (resize-head 0 0 0
                   (screen-width (current-screen))
                   (screen-height (current-screen)))))

  (defun toggle-dzen2 ()
    (if dzen-process
        (kill-dzen2)
        (launch-dzen2)))
  (defun dzen-process ()
    dzen-process))

(defcommand dzen () ()
  "Launch or kill dzen"
  (toggle-dzen2))
