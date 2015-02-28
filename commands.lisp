(load-module "battery-portable")

(defcommand battery-info () ()
  "Show battery info"
  (echo-string (current-screen)
               (battery-portable::battery-info-string)))
