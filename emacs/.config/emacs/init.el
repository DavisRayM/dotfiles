;;; -*- lexical-binding: t; -*-

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file t)
;; A bunch of cool stuff:
;; - delsel
;; - Flymake Configurations
;; - Global Line & Column Numbers
;; - Savehist
;; - WhichKey
(load-theme 'newcomers-presets)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("elpa" . "https://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(setq package-archive-priorities '(("elpa" . 10) ("nongnu" . 5) ("melpa" . 0)))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(setq use-package-always-ensure t)
(setq inhibit-startup-message t)
(setq display-line-numbers-type 'relative)
(setq visible-bell t)

(set-face-attribute 'default nil
		    :family "Terminess Nerd Font Mono"
		    :height 120
		    :weight 'regular)

;; Packages
(use-package minibuffer
  :ensure nil
  :config
  (setq completion-show-help nil)
  (setq completion-show-inline-help nil)
  (setq completions-detailed t)
  (setq completions-format 'one-column)
  (setq completions-max-height 12)
  (setq completions-sort 'historical)
  (setq completion-auto-help t)
  (setq completion-auto-select nil
        minibuffer-visible-completions t)
  (setq completion-eager-display t)
  (setq completion-eager-update t))

(use-package consult
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c m" . consult-man)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<") ;; "C-+"
)

(use-package embark
  :bind
  (("C-." . embark-act)
   ("M-." . embark-dwim)
   ("C-h B" . embark-bindings))
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult)

(use-package marginalia
  :init
  (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

(use-package magit)

(use-package nerd-icons)

(use-package doom-modeline
  :init
  (doom-modeline-mode))

(use-package doom-themes
  :config
  (load-theme 'doom-palenight t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package emacs
  :custom
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package org
  :ensure nil
  :config
  (setq org-directory "~/org")
  (setq org-agenda-files (list org-directory)))

(use-package completion-preview
  :ensure nil
  :demand t
  :bind
  (:map completion-preview-active-mode-map
	("M-i" . completion-preview-insert-word)
	("M-n" . completion-preview-next-candidate)
	("M-p" . completion-preview-prev-candidate)
	("M-<return>". completion-preview-insert)
	("<tab>" . completion-preview-complete))
  :config
  (setq completion-preview-minimum-symbol-length 2)
  (global-completion-preview-mode))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package vterm
  :bind
  (("C-c t" . vterm-other-window)))

(provide 'init)
;;; init.el ends here
