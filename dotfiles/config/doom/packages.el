;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! )

;; Elfeed for RSS
;; disable elfeed goodies
(package! elfeed-goodies :disable t)
;;;; add elfeed-web
;; (package! elfeed-web)
;; use elfeed-tube
(package! elfeed-tube)
;; install mpv for elfeed-tube
(package! elfeed-tube-mpv)

;; use org-super-agenda for a better agenda view
(package! org-super-agenda)
;;(package! org-pomodoro)

;; fill column to indicate line width
(package! fill-column-indicator)

;; use keychain-environment to handle ssh-agent
(package! keychain-environment
  :recipe (:host github :repo "tarsius/keychain-environment"))

;; add dap mode for debugging
(package! dap-mode)

;; ;; use with-venv
;; (package! with-venv
;;   :recipe (:host github :repo "10sr/with-venv-el"))

;; Python docstring generation using numpydoc
;; (package! numpydoc)
;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))
;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)


;; AI completion tools
;; use tabnine as company backend for auto-completion
;; (package! company-tabnine)
;; ;; Codeium
;; (package! codeium:
;;   :recipe (:host github :repo "Exafunction/codeium.el"))

;; ;; corfu
;; ;; (package! company :disable t)
;; (package! corfu
;;   :recipe (:files (:defaults "extensions/*.el")))
;; (package! kind-icon)
;; (package! orderless)
;; (package! cape)

;;(package! popon
;;  :recipe (:host github :repo "https://codeberg.org/akib/emacs-popon"))
;;(package! corfu-terminal
;;  :recipe (:type git :repo "https://codeberg.org/akib/emacs-corfu-terminal.git"))
;;(package! corfu-doc-terminal
;;  :recipe (:type git :repo "https://codeberg.org/akib/emacs-corfu-doc-terminal.git"))
;;
;; add snippet support to cape
(package! cape-yasnippet
 :recipe (:host github :repo "elken/cape-yasnippet"))

;; AI stuff, chatGPT, copilot
;; integrate chatGPT
(package! gptel)
;; Github Copilot
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

(package! org-cv
  :recipe (:host gitlab :repo "Titan-C/org-cv" :files ("*.el")))

;; ;; use imenu-list
;; (package! imenu-list)

;; use beacon
(package! beacon)

;; ;; use org-modern for eye-candy org-mode
;; (package! org-modern)

;; ;; use ruff as python formatter
;; (package! ruff-format)

;; ;; use lsp-bridge
;; (when (package! lsp-bridge
;;         :recipe (:host github
;;                  :repo "manateelazycat/lsp-bridge"
;;                  :branch "master"
;;                  :files ("*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
;;                  ;; do not perform byte compilation or native compilation for lsp-bridge
;;                  :build (:not compile)))
;;   (package! markdown-mode)
;;   (package! yasnippet))

;; use denote for note taking
(package! denote)

;; nix has prebuilt pdf tools, use it over the package in MELPA
(package! pdf-tools :built-in 'prefer)

;; use github flavored markdown for org export to md
(package! ox-gfm)
