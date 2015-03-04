(load-module "battery-portable")
(load-module "amixer")

(defcommand battery-info () ()
  "Show battery info"
  (echo-string (current-screen)
               (battery-portable::battery-info-string)))

(amixer::defvolcontrol Master-dec "Master" "1%-")
(amixer::defvolcontrol Master-inc "Master" "1%+")
(amixer::defvolcontrol Master-toggle "Master" "toggle")

(defcommand firefox () ()
  "Run or raise Firefox"
  (run-or-raise "firefox" '(:class "Firefox")))
