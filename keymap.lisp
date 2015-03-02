;; Define the volume control and mute keys.

(define-key *top-map* (kbd "XF86AudioLowerVolume") "Master-dec")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "Master-inc")
(define-key *top-map* (kbd "XF86AudioMute") "Master-toggle")

;; Define brightness display keys
(define-key *top-map* (kbd "XF86MonBrightnessDown") "exec sudo backlightctl -2")
(define-key *top-map* (kbd "XF86MonBrightnessUp") "exec sudo backlightctl 2")
