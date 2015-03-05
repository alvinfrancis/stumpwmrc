(defmacro def-web-jump (name url-prefix &optional (doc nil doc-supplied-p))
  `(defcommand ,name (search)
       ((:rest ,(concatenate 'string (symbol-name name) ": ")))
     ,(if doc-supplied-p
          doc
          (concat "Search " (symbol-name name)))
     (run-shell-command (format nil "firefox '~A'"
                                (concat ,url-prefix (substitute #\+ #\Space search))))))

(def-web-jump google "http://www.google.com/search?q=")
(def-web-jump wikipedia "http://en.wikipedia.org/wiki/Special:Search?fulltext=Search&search=")
(def-web-jump youtube "http://youtube.com/results?search_query=")
(def-web-jump arch "https://wiki.archlinux.org/index.php?title=Special%%3ASearch&search="
  "Search the Arch Linux Wiki")
(def-web-jump pac "http://www.archlinux.org/packages/?q="
  "Search pacman packages")
(def-web-jump aur "http://aur.archlinux.org/packages.php?K="
  "Search AUR packages")
