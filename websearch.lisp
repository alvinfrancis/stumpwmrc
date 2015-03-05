(defmacro make-web-jump (name url-prefix &optional (doc nil doc-supplied-p))
  `(defcommand ,name (search)
       ((:rest ,(concatenate 'string (symbol-name name) ": ")))
     ,(if doc-supplied-p
          doc
          (concat "Search " (symbol-name name)))
     (run-shell-command (format nil "firefox '~A'"
                                (concat ,url-prefix (substitute #\+ #\Space search))))))

(make-web-jump google    "http://www.google.com/search?q=")
(make-web-jump wikipedia "http://en.wikipedia.org/wiki/Special:Search?fulltext=Search&search=")
(make-web-jump youtube   "http://youtube.com/results?search_query=")
(make-web-jump arch      "https://wiki.archlinux.org/index.php?title=Special%%3ASearch&search="
               "Search the Arch Linux Wiki")
(make-web-jump pac       "http://www.archlinux.org/packages/?q="
               "Search pacman packages")
(make-web-jump aur       "http://aur.archlinux.org/packages.php?K="
               "Search AUR packages")
