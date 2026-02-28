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

;; set up elfeed feeds
(setq rmh-elfeed-org-files (list "~/.doom.d/elfeed.org"))
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
(setq doom-symbol-font (font-spec :family "MesloLGS Nerd Font Propo" :size 13))
(setq doom-font (font-spec :family "MesloLGS Nerd Font Propo" :size 14))
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
(add-hook 'python-mode-hook  #'fci-mode)
(setq fci-rule-column 80
      fci-rule-color "red")

;; load keychain-environment to handle ssh agent
(keychain-refresh-environment)


;; (use-package! imenu-list
;;   :commands imenu-list-smart-toggle)
;; (after! imenu
;;   (setq imenu-auto-rescan t)
;;   (setq imenu-list-auto-resize t)
;;   (setq imenu-list-max-width 40)
;;   (setq imenu-sort-function 'imenu--sort-by-position)
;; )

;; ;; (map! :leader
;; ;;       :desc "Toggle imenu-list"
;; ;;       "i" #'imenu-list-smart-toggle)


;; (use-package! dap-mode
;; :after lsp-mode
;; :commands dap-debug
;; :hook ((python-mode . dap-ui-mode) (python-mode . dap-mode))
;; :config
;; (require 'dap-python)
;; (setq dap-python-debugger 'debugpy)
;; (defun dap-python--pyenv-executable-find (command)
;;   (with-venv (executable-find "python"))))

;;;; set up tabnine auto completion
;;(after! company
;;  ;; (setq +lsp-company-backends '(company-tabnine))
;;  (add-to-list '+lsp-company-backends 'company-tabnine)
;;  ;; (add-to-list 'company-backends #'company-tabnine)
;;  ;; trigger completion immediately
;;  (setq company-idle-delay 0.2)
;;  (setq company-show-quick-access t))

;; ;; set up numpydoc for python docstring generation
;; (use-package! numpydoc
;;   :after python-mode
;;   :config
;;   (setq numpydoc-insert-examples-block nil)
;;   :bind (:map python-mode-map
;;               ("C-c C-n" . numpydoc-generate)))

;; pdftool
;; auto-revert after Tex comlilation
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

;; diagram with plantUML
;; (setq plantuml-executable-path "/usr/bin/plantuml")
;; (setq plantuml-default-exec-mode 'executable)
(setq plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar")
(setq plantuml-default-exec-mode 'jar)
;; (setq plantuml-server-url "http://localhost:8080")
;; (setq plantuml-default-exec-mode 'server)

;; (use-package! corfu
;;   :custom
;;   (corfu-separator ?\s)
;;   (corfu-auto t)
;;   (corfu-auto-delay 0.2)
;;   (corfu-preview-current nil) ;; Disable current candidate preview
;;   (corfu-on-exact-match nil)
;;   (corfu-quit-no-match t)
;;   (corfu-cycle t)
;;   (corfu-auto-prefix 0.5)
;;   (completion-cycle-threshold 0.5)
;;   (tab-always-indent 'complete)
;;   (corfu-max-width 80)
;;   (corfu-preselect-first nil)
;;   :hook
;;   (doom-first-buffer . global-corfu-mode)
;;   :config
;;   ;; ;; disable company-mode
;;   ;; (setq company-mode nil)
;;   ;; (setq global-company-mode nil)
;; ;;  (setq company-backends '(corfu-company))
;;  ;; (when (modulep! +minibuffer)
;;  ;;   (add-hook 'minibuffer-setup-hook #'+corfu--enable-in-minibuffer))

;; ;;  ;; Dirty hack to get c completion running
;; ;;  ;; Discussion in https://github.com/minad/corfu/issues/34
;; ;;  (when (and (modulep! :lang cc)
;; ;;             (equal tab-always-indent 'complete))
;; ;;    (map! :map c-mode-base-map
;; ;;          :i [remap c-indent-line-or-region] #'completion-at-point))

;;   ;; Reset lsp-completion provider
;;   (add-hook 'doom-init-modules-hook
;;             (lambda ()
;;               (after! lsp-mode
;;                 (setq lsp-completion-provider :none))))

;;   ;; Set orderless filtering for LSP-mode completions
;;   ;; TODO: expose a Doom variable to control this part
;;   (add-hook 'lsp-completion-mode-hook
;;             (lambda ()
;;               (setf (alist-get 'lsp-capf completion-category-defaults) '((styles . (orderless flex))))))

;;   (defun corfu-move-to-minibuffer ()
;;     "Move current completions to the minibuffer"
;;     (interactive)
;;     (let ((completion-extra-properties corfu--extra)
;;           completion-cycle-threshold completion-cycling)
;;       (apply #'consult-completion-in-region completion-in-region--data)))

;;   (map! :map corfu-map
;;         "SPC"    #'corfu-insert-separator
;;         "C-n"      #'corfu-next
;;         "C-p"      #'corfu-previous
;;         "<escape>" #'corfu-quit
;;         "M-m"      #'corfu-move-to-minibuffer
;;         "M-d"      #'corfu-popupinfo-documentation
;;         (:prefix "C-x"
;;                  "C-k"     #'cape-dict
;;                  "s"       #'cape-ispell
;;                  "C-n"     #'cape-keyword
;;                  "C-l"     #'cape-line
;;                  "C-f"     #'cape-file))
;;   )
;;   ;; (after! evil
;;   ;;   (advice-add 'corfu--setup :after 'evil-normalize-keymaps)
;;   ;;   (advice-add 'corfu--teardown :after 'evil-normalize-keymaps)
;;   ;;   (evil-make-overriding-map corfu-map)))
;; ;;
;; ;;  (defadvice! +corfu--org-return (orig) :around '+org/return
;; ;;    (if (and (modulep! :completion corfu)
;; ;;             corfu-mode
;; ;;             (>= corfu--index 0))
;; ;;        (corfu-insert)
;; ;;      (funcall orig))))
;; ;;
;; ;;  ;; TODO: check how to deal with Daemon/Client workflow with that
;; ;;  (unless (display-graphic-p)
;; ;;    (corfu-doc-terminal-mode)
;; ;;    (corfu-terminal-mode)))

;; (use-package! orderless
;; ;;  :when (modulep! +orderless)
;;   :init
;;   (setq completion-styles '(orderless partial-completion)
;;         completion-category-defaults nil
;;         completion-category-overrides '((file (styles . (partial-completion))))))

;; (use-package! kind-icon
;;   :after corfu
;; ;;  :when (modulep! +icons)
;;   :custom
;;   (kind-icon-default-face 'corfu-default)
;;   :config
;; ;;  (setq kind-icon-use-icons t
;; ;;        svg-lib-icons-dir (expand-file-name "svg-lib" doom-cache-dir)
;; ;;        kind-icon-mapping
;; ;;        '((array "a" :icon "code-brackets" :face font-lock-variable-name-face)
;; ;;          (boolean "b" :icon "circle-half-full" :face font-lock-builtin-face)
;; ;;          (class "c" :icon "view-grid-plus-outline" :face font-lock-type-face)
;; ;;          (color "#" :icon "palette" :face success)
;; ;;          (constant "co" :icon "pause-circle" :face font-lock-constant-face)
;; ;;          (constructor "cn" :icon "table-column-plus-after" :face font-lock-function-name-face)
;; ;;          (enum "e" :icon "format-list-bulleted-square" :face font-lock-builtin-face)
;; ;;          (enum-member "em" :icon "format-list-checks" :face font-lock-builtin-face)
;; ;;          (event "ev" :icon "lightning-bolt-outline" :face font-lock-warning-face)
;; ;;          (field "fd" :icon "application-braces-outline" :face font-lock-variable-name-face)
;; ;;          (file "f" :icon "file" :face font-lock-string-face)
;; ;;          (folder "d" :icon "folder" :face font-lock-doc-face)
;; ;;          (function "f" :icon "lambda" :face font-lock-function-name-face)
;; ;;          (interface "if" :icon "video-input-component" :face font-lock-type-face)
;; ;;          (keyword "kw" :icon "image-filter-center-focus" :face font-lock-keyword-face)
;; ;;          (macro "mc" :icon "sigma" :face font-lock-keyword-face)
;; ;;          (method "m" :icon "lambda" :face font-lock-function-name-face)
;; ;;          (module "{" :icon "view-module" :face font-lock-preprocessor-face)
;; ;;          (numeric "nu" :icon "numeric" :face font-lock-builtin-face)
;; ;;          (operator "op" :icon "plus-circle-outline" :face font-lock-comment-delimiter-face)
;; ;;          (param "pa" :icon "cog" :face default)
;; ;;          (property "pr" :icon "tune-vertical" :face font-lock-variable-name-face)
;; ;;          (reference "rf" :icon "bookmark-box-multiple" :face font-lock-variable-name-face)
;; ;;          (snippet "S" :icon "text-short" :face font-lock-string-face)
;; ;;          (string "s" :icon "sticker-text-outline" :face font-lock-string-face)
;; ;;          (struct "%" :icon "code-braces" :face font-lock-variable-name-face)
;; ;;          (t "." :icon "crosshairs-question" :face shadow)
;; ;;          (text "tx" :icon "script-text-outline" :face shadow)
;; ;;          (type-parameter "tp" :icon "format-list-bulleted-type" :face font-lock-type-face)
;; ;;          (unit "u" :icon "ruler-square" :face shadow)
;; ;;          (value "v" :icon "numeric-1-box-multiple-outline" :face font-lock-builtin-face)
;; ;;          (variable "va" :icon "adjust" :face font-lock-variable-name-face)))
;;   (add-hook 'doom-load-theme-hook #'kind-icon-reset-cache)
;;   (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))


;; (use-package! cape
;;   :defer t
;;   :init
;;   (map!
;;    [remap dabbrev-expand] 'cape-dabbrev)
;;   (add-hook! 'latex-mode-hook (defun +corfu--latex-set-capfs ()
;;                                 (add-to-list 'completion-at-point-functions #'cape-tex)))
;;   (add-to-list 'completion-at-point-functions #'cape-dict)
;;   (add-to-list 'completion-at-point-functions #'cape-file)
;; ;;  (add-to-list 'completion-at-point-functions #'cape-line)
;;   (add-to-list 'completion-at-point-functions #'cape-keyword t)
;;   (add-to-list 'completion-at-point-functions #'cape-dabbrev t))


;; ;;(use-package! corfu-history
;; ;;  :after corfu
;; ;;  :hook (corfu-mode . (lambda ()
;; ;;                        (corfu-history-mode 1)
;; ;;                        (savehist-mode 1)
;; ;;                        (add-to-list 'savehist-additional-variables 'corfu-history))))

;; (use-package! corfu-quick
;;   :after corfu
;;   :bind (:map corfu-map
;;               ("M-q" . corfu-quick-complete)
;;               ("C-q" . corfu-quick-insert)))

;; (use-package! corfu-echo
;;   :after corfu
;;   :hook (corfu-mode . corfu-echo-mode))


;; (use-package! corfu-info
;;   :after corfu)


;; (use-package! corfu-popupinfo
;;   :after corfu
;;   :hook (corfu-mode . corfu-popupinfo-mode))

;; (when (modulep! :editor evil +everywhere)
;;   (setq evil-collection-corfu-key-themes '(default magic-return)))

;;(use-package! cape-yasnippet
;;  :after cape)

;;;; Override :config default mapping by waiting for after corfu is loaded
;;(add-hook! 'doom-after-modules-config-hook
;;  (defun +corfu-unbind-yasnippet-h ()
;;    "Remove problematic tab bindings in cmds! on :i TAB"
;;    (map! :i [tab] nil
;;          :i "TAB" nil
;;          :i "C-SPC" #'completion-at-point
;;          :i "C-@" #'completion-at-point)))

;;;;; ---------------------------------------------------
;;;;; set up codeium auto completion
;;;;; we recommend using use-package to organize your init.el
;;(use-package! codeium
;;    ;; if you use straight
;;    ;; :straight '(:type git :host github :repo "Exafunction/codeium.el")
;;    ;; otherwise, make sure that the codeium.el file is on load-path
;;
;;    :init
;;    ;; use globally
;;;;    (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
;;    ;; or on a hook
;;    (add-hook 'python-mode-hook
;;        (lambda ()
;;            (setq-local completion-at-point-functions '(codeium-completion-at-point)))))
;;
;;    ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
;;;;    (add-hook 'python-mode-hook
;;;;        (lambda ()
;;;;            (setq-local completion-at-point-functions
;;;;                (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
;;    ;; an async company-backend is coming soon!
;;
;;    ;; codeium-completion-at-point is autoloaded, but you can
;;
;;    ;; codeium local language server takes ~0.2s to start up
;;    ;; (add-hook 'emacs-startup-hook
;;    ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))

;;    ;; :defer t ;; lazy loading, if you want
;;    :config
;;    (setq use-dialog-box nil) ;; do not use popup boxes
;;
;;    ;; if you don't want to use customize to save the api-key
;;    (setq codeium/metadata/api_key "0930a4ba-0fea-4b91-90c4-536bdde51c64")
;;    ;; get codeium status in the modeline
;;    (setq codeium-mode-line-enable
;;        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
;;    (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
;;    ;; alternatively for a more extensive mode-line
;;    ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)
;;
;;    ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
;;    (setq codeium-api-enabled
;;        (lambda (api)
;;            (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
;;    ;; you can also set a config for a single buffer like this:
;;    ;; (add-hook 'python-mode-hook
;;    ;;     (lambda ()
;;    ;;         (setq-local codeium/editor_options/tab_size 4)))
;;
;;    ;; You can overwrite all the codeium configs!
;;    ;; for example, we recommend limiting the string sent to codeium for better performance
;;    (defun my-codeium/document/text ()
;;        (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
;;    ;; if you change the text, you should also change the cursor_offset
;;    ;; warning: this is measured by UTF-8 encoded bytes
;;    (defun my-codeium/document/cursor_offset ()
;;        (codeium-utf8-byte-length
;;            (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
;;    (setq codeium/document/text 'my-codeium/document/text)
;;    (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))
;;;; ---------------------------------------------------

;; set up org-cv
(use-package! ox-moderncv)
(use-package! ox-awesomecv)

;; set up org-babel
;; set global python interpreter
(setq org-babel-python-command "/home/yueting/.pyenv/versions/3.10.12/bin/python")

;; set browser to system default browser
(setq browse-url-browser-function 'browse-url-xdg-open)

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
 (setq org-modern-label-border 0.3)
 (setq org-modern-table t)
 ;; modern star
 (setq org-modern-star '("◉" "○" "◈" "◇" "*"))
 ;; prettify org-agenda
 (add-hook 'org-agenda-finalize-hook #'org-modern-agenda))
 ;; global mode
 (global-org-modern-mode)
 ;; (add-hook 'org-mode-hook #'org-modern-mode)

;; set transparency
(set-frame-parameter nil 'alpha-background 95) ; For current frame
;; (set-frame-parameter nil 'alpha-background 100) ; For current frame no transparency
(add-to-list 'default-frame-alist '(alpha-background . 95)) ; For all new frames henceforth

;; auto revert buffer
(global-auto-revert-mode 1)

;; ;; use zathura to open pdf files
;; (setq org-file-apps
;;       '((auto-mode . emacs)
;;         ("\\.x?html?\\'" . default)
;;         ("\\.pdf\\'" . "zathura %s")
;;         ("\\.pdf::\\([0-9]+\\)\\'" . "zathura %s -p %1")))

;; ;; set up lsp-booster
;; (defun lsp-booster--advice-json-parse (old-fn &rest args)
;;   "Try to parse bytecode instead of json."
;;   (or
;;    (when (equal (following-char) ?#)
;;      (let ((bytecode (read (current-buffer))))
;;        (when (byte-code-function-p bytecode)
;;          (funcall bytecode))))
;;    (apply old-fn args)))
;; (advice-add (if (progn (require 'json)
;;                        (fboundp 'json-parse-buffer))
;;                 'json-parse-buffer
;;               'json-read)
;;             :around
;;             #'lsp-booster--advice-json-parse)

;; (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
;;   "Prepend emacs-lsp-booster command to lsp CMD."
;;   (let ((orig-result (funcall old-fn cmd test?)))
;;     (if (and (not test?)                             ;; for check lsp-server-present?
;;              (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
;;              lsp-use-plists
;;              (not (functionp 'json-rpc-connection))  ;; native json-rpc
;;              (executable-find "emacs-lsp-booster"))
;;         (progn
;;           (message "Using emacs-lsp-booster for %s!" orig-result)
;;           (cons "emacs-lsp-booster" orig-result))
;;       orig-result)))
;; (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

;; set default emacs shell to bash, because fish may inject a lot garbage
(setq shell-file-name (executable-find "bash"))
;; set vterm shell to fish
(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))

;; set tramp default remote shell to bash
(setq tramp-default-remote-shell "/bin/bash")
(setq tramp-default-remote-shell-args (list "-l" "-c"))

;; ;; set up lsp-bridge
;; (use-package! lsp-bridge
;;  :config
;;  (setq lsp-bridge-enable-log nil)
;;  ;; set python to pyenv python
;;  (setq lsp-bridge-python-command "/usr/bin/python")
;;  (global-lsp-bridge-mode))

;; ;; use poetry to manage virtualenv
;; (defun my-lsp-bridge-poetry-venv ()
;;   "Set the Python virtual environment for lsp-bridge based on Poetry."
;;   (when (and buffer-file-name
;;              (executable-find "poetry"))
;;     (let* ((poetry-venv (string-trim (shell-command-to-string "poetry env info --path")))
;;            (python-exec (concat poetry-venv "/bin/python")))
;;       (when (file-exists-p python-exec)
;;         (setq-local lsp-bridge-python-command python-exec)))))

;; (add-hook 'python-mode-hook 'my-lsp-bridge-poetry-venv)

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
;; with package gptel
(use-package! gptel)
(defun my-get-api-key (machine)
  "Retrieve API key for MACHINE from authinfo."
  (let ((entry (car (auth-source-search :host machine :max 1 :require '(:user :secret)))))
    (when entry
      (let ((secret (funcall (plist-get entry :secret))))
        (if (stringp secret) secret (error "Invalid secret for %s" machine))))))

;; Fetch API keys
(setq gptel-api-key-openai (my-get-api-key "openai.com")
      gptel-api-key-gemini (my-get-api-key "generativelanguage.googleapis.com")
      gptel-api-key-openrouter (my-get-api-key "openrouter.ai"))
(after! gptel
  (gptel-make-openai "OpenAI" :key gptel-api-key-openai :stream t)
  (gptel-make-gemini "Gemini" :key gptel-api-key-gemini :stream t)
  (gptel-make-openai "OpenRouter"
                     :host "openrouter.ai"
                     :endpoint "/api/v1/chat/completions"
                     :stream t
                     :key gptel-api-key-openrouter
                     :models '(openai/o4-mini-high
                               openai/o4-mini
                               deepseek/deepseek-r1
                               deepseek/deepseek-r1:free
                               anthropic/claude-3.7-sonnet:beta
                              )
  )
)

;; programming
;; -----------
;; -----------
;; set up github copilot
;; accept completion from copilot and fallback to company
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


;; LSP related
;; --------------
;; set lsp ui
(use-package! lsp-ui
  :after lsp-mode
  :config
  (setq
    lsp-ui-sideline-show-hover t
    lsp-ui-sideline-delay 0.5
    lsp-ui-doc-delay 5
    lsp-ui-sideline-ignore-duplicates t
    lsp-ui-doc-position 'bottom
    lsp-ui-doc-alignment 'frame
    lsp-ui-doc-header nil
    lsp-ui-doc-include-signature t
    lsp-ui-doc-use-childframe t
    lsp-ui-imenu-auto-refresh t
    lsp-ui-imenu-refresh-delay 1
    lsp-imenu-sort-methods '(position kind)
    lsp-imenu-index-symbol-kinds '(Class Method Function Enum)
    lsp-ui-imenu--custom-mode-line-format
            '((:title "Classes" :category "Class")
             (:title "Functions" :category "Function")
             (:title "Methods" :category "Method")))
 ;; ;; Only enable lsp-ui-imenu in programming modes, not in org-mode
 ;;  (defun my/maybe-enable-lsp-ui-imenu ()
 ;;    "Enable lsp-ui-imenu only in programming modes, not in org-mode."
 ;;    (when (and (derived-mode-p 'prog-mode)
 ;;               (not (derived-mode-p 'org-mode)))
 ;;      ;; You could add specific setup for lsp-ui-imenu here if needed
 ;;      (lsp-ui-imenu-enable t)))
 ;;    ;; Disable in org-mode explicitly
 ;;    ;; (when (derived-mode-p 'org-mode)
 ;;    ;;   (lsp-ui-imenu-enable nil)))

 ;;  ;; Add the function to relevant hooks
 ;;  (add-hook 'lsp-managed-mode-hook #'my/maybe-enable-lsp-ui-imenu)
 ;;  ;; (add-hook 'org-mode-hook (lambda () (lsp-ui-imenu-enable nil)))
)

;; python
;; ------
;; python linting and formatting
;; load flycheck-ruff for linting along with other linters like LSP
(load! "lisp/flycheck-ruff.el")
;; also use ruff for formating
(use-package! ruff-format
  :after python-mode
  :config
  (add-hook 'python-mode-hook 'ruff-format-on-save-mode))
;; ----------------
