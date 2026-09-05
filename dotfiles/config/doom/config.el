;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Set org agenda files
(setq org-agenda-files (append '("~/org/gtd.org"
                                 "~/org/work.org")
                                (file-expand-wildcards "~/org/projects/*/*.org")))

;; update timestamp when saving
(add-hook 'before-save-hook 'time-stamp)

;; Workflow sequence, track TODO state changes
(after! org
     (setq org-todo-keywords
           '((sequence "TODO(t)" "NEXT(n)" "INPROGRESS(i)" "WAITING(w@/!)" "HOLDING(h)" "PROJECT(p)" "ACTIVE(a)" "INACTIVE(I)" "|" "DONE(d!)" "CANCELLED(c@)")))

     ;; start agenda today
     (setq org-agenda-start-day nil) ;today
     ;; Skip Done tasks in agenda view
     (setq org-agenda-skip-scheduled-if-done t)
     (setq org-agenda-skip-deadline-if-done t)

     ;; Show the daily agenda by default.
     ;(setq org-agenda-span 'day)

     ;; Hide tasks that are scheduled in the future.
     (setq org-agenda-todo-ignore-scheduled 'future)

     ;; Use "second" instead of "day" for time comparison.
     ;; It hides tasks with a scheduled time like "<2020-11-15 Sun 11:30>"
     (setq org-agenda-todo-ignore-time-comparison-use-seconds t)

     ;; Hide the deadline prewarning prior to scheduled date.
     (setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)

     ;; org super agenda config
     (setq org-agenda-custom-commands
           '(("z" "Super zaen view"
             ((agenda "" ((org-agenda-span 'day)
                          (org-super-agenda-groups
                          '((:name "Today"
                                   :time-grid t
                                   :date today
                                   :todo "TODAY"
                                   :scheduled today
                                   :order 0)
                            (:name "InProgress"
                                   :todo "INPROGRESS"
                                   :order 10)
                            (:name "Due Today"
                                    :deadline today
                                    :order 20)
                            (:name "Due Soon"
                                    :deadline future
                                    :order 40)
                            (:name "Done today"
                                    :and (:regexp "State \"DONE\""
                                          :log t)
                                    :order 25)
                            (:name "Overdue"
                                    :deadline past
                                    :scheduled past
                                    :order 30)))))
              (alltodo "" ((org-agenda-overriding-header "")
                           (org-super-agenda-groups
                            '((:name "Next Items"
                                     :todo "NEXT"
                                     :order 0)
                              (:name "Waiting"
                                      :todo "WAITING"
                                      :order 10)
                              (:name "Important"
                                      :priority "A"
                                      :order 30)
                              (:name "Quick Picks"
                                      :effort< "0:30"
                                      :order 20)
                              (:name "Projects"
                                      :file-path "projects"
                                      :order 40)
                              (:priority<= "B"
                                      :scheduled future
                                      :order 50)
                              (:auto-category t
                                      :order 90)
                              ))))))
             ))
)
(use-package! org-super-agenda
  :after org
  :config
  (org-super-agenda-mode 1))

;; Set org latex preview scale
(after! org
     (setq org-format-latex-options
      (plist-put org-format-latex-options :scale 1.5)))


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yueting Liu"
      user-mail-address "yueting1106.liu@gmail.com")

;; Keep only Option/Alt as Super on macOS. Command is Meta so Command+Option
;; remains distinguishable from plain Meta keybindings.
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'super
        ns-option-modifier 'super
        mac-command-modifier 'meta
        ns-command-modifier 'meta))

;; set up elfeed feeds
(setq rmh-elfeed-org-files (list "~/.config/doom/elfeed.org"))
;; set database location
(setq elfeed-db-directory "~/org/data/elfeed")
;; (use-package! elfeed-tube
;;   :after elfeed
;;   :config
;;   (elfeed-tube-setup)
;;   :bind (:map elfeed-show-mode-map
;;          ("F" . elfeed-tube-fetch)
;;          ([remap save-buffer] . elfeed-tube-save)
;;          :map elfeed-search-mode-map
;;          ("F" . elfeed-tube-fetch)
;;          ([remap save-buffer] . elfeed-tube-save)))
;; (use-package! elfeed-tube-mpv
;;     :bind (:map elfeed-tube-mpv-follow-mode-map
;;                 ("C-c C-f" . elfeed-tube-mpv-follow-mode)
;;                 ("C-c C-w" . elfeed-tube-mpv-where)))

;; set up org-journal
(setq org-journal-file-type 'monthly)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;; use nerd font
;; (setq doom-font (font-spec :family "MesloLGS NF" :size 13 :weight 'semi-light)
;; (setq doom-symbol-font (font-spec :family "FiraCode Nerd Font Propo"))
;; (setq doom-font (font-spec :family "FiraCode Nerd Font Propo"))
(if (eq system-type 'darwin)
    (setq doom-symbol-font (font-spec :family "Iosevka" :size 15.0)
          doom-font (font-spec :family "Iosevka" :size 14.0))
  (setq doom-symbol-font (font-spec :family "Iosevka" :size 13.0)
        doom-font (font-spec :family "Iosevka" :size 12.0)))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-dark)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; set dictionary server
(setq dictionary-server "dict.org")

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; set global keybindings
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
;; set org capture
(setq org-default-notes-file (concat org-directory "notes.org"))
(after! org
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Inbox")
         "* TODO %?\nEntered on %U\n  %i\n  %a")
        ("n" "Notes" entry (file+datetree "~/org/notes_inbox.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal_inbox.org")
         "* %?\nEntered on %U\n  %i")
        ("s" "Slipbox" entry  (file "~/org/roam/inbox.org")
         "* %?\n"))))

;; org-roam
(setq org-roam-directory (concat org-directory "roam/"))
;; org-roam-dailies
(setq org-roam-dailies-directory "journals/")
(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
       "* %<%H:%M> %?"
       ;; "* %<%I:%M %p> %?"
      :target (file+head "%<%Y-%m-%d>.org"
                         "#+title: %<%Y-%m-%d>\n"))))

;; org roam capture template
(setq org-roam-capture-templates
      '(("c" "concept" plain "%?"
         :target
         (file+head "concept/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("r" "reference" plain "%?"
         :target
         (file+head "reference/%<%Y%m%d%H%M%S>-${title}.org" "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("a" "article" plain "%?"
         :target
         (file+head "articles/%<%Y%m%d%H%M%S>-${title}.org" "#+title: ${title}\n#+filetags: :article:\n")
         :immediate-finish t
         :unnarrowed t)))

;; ;; Projectile config
;; (setq projectile-project-search-path '("~/org/projects/"))
;; (setq projectile-switch-project-action #'projectile-dired)

;; log status change
(setq org-log-done t)
;;(setq org-log-into-drawer LOGBOOK)
;;
;;split window to the right or below
(setq evil-vsplit-window-right t
     evil-split-window-below t)

;; Configs for python
;; set up vertical line indicator
(add-hook 'python-mode-hook  #'display-fill-column-indicator-mode)
(setq fci-rule-column 80
      fci-rule-color "red")

;; load keychain-environment to handle ssh agent
(keychain-refresh-environment)

;; auto-revert after Tex comlilation
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

;; set up org-cv
(use-package! ox-moderncv)
(use-package! ox-awesomecv)

;; Set browser to system default browser based on OS
(setq browse-url-browser-function
      (if (eq system-type 'darwin)
          'browse-url-default-macosx-browser
        'browse-url-xdg-open))

;; make workspaces always visible
(after! doom-modeline
  (setq doom-modeline-persp-name t))

;; ;; use lualatex to as latex compiler
;; (setq org-latex-pdf-process '("lualatex %f" "lualatex %f" "lualatex %f"))

;; enable beacon
(use-package! beacon
 :config
 (beacon-mode 1))

;; set up org-modern after org
(use-package! org-modern
 :after org
 :config
 ;; for stlying
 (setq org-hide-emphasis-markers t)
 (setq org-pretty-entities t)
 (setq org-ellipsis "...")
 ;; (setq org-modern-label-border 0.3)
 (setq org-modern-table t)
 ;; modern star
 (setq org-modern-star '("◉" "○" "◈" "◇" "*"))
 ;; prettify org-agenda
 (add-hook 'org-agenda-finalize-hook #'org-modern-agenda))
;;  ;; global mode
;;  (global-org-modern-mode)
;;  ;; (add-hook 'org-mode-hook #'org-modern-mode)

;; macOS/NS frames need explicit frame parameters for title bar and opacity.
(when (eq system-type 'darwin)
  (setq ns-use-proxy-icon nil
        frame-title-format nil)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  ;; (add-to-list 'default-frame-alist '(undecorated . t))

  (set-frame-parameter nil 'ns-transparent-titlebar t)
  (set-frame-parameter nil 'ns-appearance 'dark))
 ;; (set-frame-parameter nil 'undecorated t))

;; ;; set transparency
;; (set-frame-parameter nil 'alpha 95) ; For current frame
;; (set-frame-parameter nil 'alpha-background 95) ; For current frame
;; ;; (set-frame-parameter nil 'alpha 100) ; For current frame no transparency
;; ;; (set-frame-parameter nil 'alpha-background 100) ; For current frame no transparency
;; (add-to-list 'default-frame-alist '(alpha . 90)) ; For all new frames henceforth
;; (add-to-list 'default-frame-alist '(alpha-background . 90)) ; For all new frames henceforth

;; auto revert buffer
(global-auto-revert-mode 1)

;; set default emacs shell to bash, because fish may inject a lot garbage
(setq shell-file-name (executable-find "bash"))
;; set vterm shell to fish
(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))

;; set tramp default remote shell to bash
(setq tramp-default-remote-shell "/bin/bash")
(setq tramp-default-remote-shell-args (list "-l" "-c"))

;; completion settings
;; in-buffer completion with corfu, cape, kind-icons, and orderless
(use-package! cape
  :after corfu
  :init
  ;; Use Cape sources globally
  (setq-default completion-at-point-functions
                (list #'cape-dict       ;; Dictionary
                      #'cape-dabbrev    ;; Buffer words
                      #'cape-file       ;; File paths
                      #'cape-keyword    ;; Keywords in programming modes
                      ;; #'cape-line       ;; line completion
                      ;; #'cape-yasnippet  ;; snippet
                      ;; #'cape-symbol)))  ;; Symbols from buffer
                )
  )
)

;; set up LLMs
;; module llm uses  gptel as the backend
(after! gptel
  ;; use auth-source to manage API keys
  (require 'auth-source)

  ;; Clear Doom/gptel default backends such as ChatGPT/OpenAI.
  (setq gptel--known-backends nil)

  (defun my/openrouter-api-key ()
    (or (auth-source-pick-first-password
         :host "openrouter.ai"
         :user "apikey")
        (user-error "No OpenRouter API key found for openrouter.ai")))

  (setq gptel-backend
        (gptel-make-openai "OpenRouter"
                           :host "openrouter.ai"
                           :endpoint "/api/v1/chat/completions"
                           :stream t
                           ;; :key gptel-api-key-openrouter
                           :key #'my/openrouter-api-key
                           :models '(openai/gpt-5.5
                                     google/gemini-3.5-flash
                                     anthropic/claude-sonnet-4.8
                                     moonshotai/kimi-k2.6
                                     deepseek/deepseek-v4-flash
                                     deepseek/deepseek-v4-pro))
        ;; Default model
        gptel-model 'google/gemini-3.5-flash

        ;; Sensible defaults
        gptel-default-mode 'org-mode
))


;; programming
;; -----------
;; -----------
;; set up github copilot
;; accept completion from copilot
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)
              ("M-n" . copilot-next-completion)
              ("M-p" . copilot-previous-completion)
        )
  :config
    (add-to-list 'copilot-indentation-alist '(prog-mode 4))
    (add-to-list 'copilot-indentation-alist '(org-mode 2))
    (add-to-list 'copilot-indentation-alist '(text-mode 2))
    (add-to-list 'copilot-indentation-alist '(closure-mode 2))
    (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))
)

;; denote configuration
(after! denote
  (setq denote-directory (concat org-directory "denote/"))
  (setq denote-file-type 'org)
  (setq denote-known-keywords
        '("emacs" "org" "ml" "cv" "system" "research" "journal" "idea" "information" "reference" "concept" "article" "draft"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-prompts '(title keywords)))

(map! :leader
      (:prefix ("n d" . "denote")
       :desc "Create note"   "n" #'denote
       :desc "Open/create"   "o" #'denote-open-or-create
       :desc "Insert link"   "l" #'denote-link
       :desc "Backlinks"     "b" #'denote-backlinks
       :desc "Rename file"   "r" #'denote-rename-file
       :desc "Search notes"  "s" #'consult-ripgrep))

;; Prefer Nix-built epdfinfo when it exists. On macOS, Emacs Plus lets Doom
;; build pdf-tools and use the package-local epdfinfo instead.
(let ((nix-epdfinfo
       (car (file-expand-wildcards
             "/nix/store/*-emacs-pdf-tools-*/share/emacs/site-lisp/elpa/pdf-tools-*/epdfinfo"))))
  (when (and nix-epdfinfo (file-executable-p nix-epdfinfo))
    (setq pdf-info-epdfinfo-program nix-epdfinfo)))

;; add pdf file association
(autoload 'pdf-view-mode "pdf-view" nil t)
(add-to-list 'auto-mode-alist '("\\.[pP][dD][fF]\\'" . pdf-view-mode))
(add-to-list 'magic-mode-alist '("%PDF" . pdf-view-mode))
;; Nix pdf-tools may not expose this autoload to Doom.
(autoload 'pdf-occur-global-minor-mode "pdf-occur" nil t)

; use xelatex
(setq org-latex-compiler "xelatex")

;; set up org export to github flavored md
(after! org
  (require 'ox-gfm)

  ;; Put future TODO/DONE history into LOGBOOK drawers
  (setq org-log-into-drawer t)

  ;; Cleaner Markdown/GFM export
  (setq org-export-with-toc nil
        org-export-with-tags nil
        org-export-with-properties nil
        org-export-with-timestamps nil
        org-export-with-todo-keywords nil
        org-export-with-drawers nil
        org-export-with-smart-quotes nil))
