;;; -*- lexical-binding: t; -*-

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file t)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("elpa" . "https://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode)

(setq use-package-always-ensure t)
(setq inhibit-startup-message t)
(setq display-line-numbers-type 'relative)
(setq vc-follow-symlinks t)
(setq visible-bell t)

(set-face-attribute 'default nil
		    :family "Terminess Nerd Font Mono"
		    :height 120
		    :weight 'regular)

(dolist (mode '(term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Packages
(use-package vertico
  :init
  (vertico-mode))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

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
  ;; Hide commands in M-x which do not work in the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package delsel
  :ensure nil
  :init
  (delete-selection-mode))

(use-package org
  :ensure nil
  :config
  (setq org-directory "~/org")
  (setq org-agenda-files (list org-directory)))

(use-package which-key
  :ensure nil
  :config
  (which-key-mode))

(use-package flymake
  :ensure nil
  :init
  (flymake-mode)
  (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error))
