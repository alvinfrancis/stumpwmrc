;; Define the volume control and mute keys.
(define-key *top-map* (kbd "XF86AudioLowerVolume") "exec amixer set Master 5%-")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "exec amixer set Master 5%+")
(define-key *top-map* (kbd "XF86AudioMute") "exec amixer set Master toggle")

;; Define brightness display keys
;; (define-key *top-map* (kbd "XF86MonBrightnessDown") "exec amixer set Master 5%-")
;; (define-key *top-map* (kbd "XF86MonBrightnessUp") "exec amixer set Master 5%+")
