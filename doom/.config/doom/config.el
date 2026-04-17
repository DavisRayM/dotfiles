;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Davis Raymond Muro"
      user-mail-address "git@davisraym.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
(setq doom-font (font-spec :family "Terminess Nerd Font" :size 18 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Terminess Nerd Font" :size 18))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq doom-modeline-time t)
(setq doom-modeline-time-icon t)

(setq projectile-project-search-path '("~/Projects/DavisRayM" "~/Projects/seattleu-projectcenter/" "~/Projects/seattle-university-cs-cloud-computing/"))
(setq confirm-kill-emacs nil)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(display-time)
(setq corfu-preview-current t)
(with-eval-after-load 'python
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode)))
(setq-hook! 'python-mode-hook +format-with 'ruff)
(setq-hook! 'python-ts-mode-hook +format-with 'ruff)

(setq-default
 gptel-model 'claude-haiku-4-5-20251001
 gptel-backend (gptel-make-anthropic "Claude"
                 :stream t :key (gptel-api-key-from-auth-source "api.anthropic.com"))
 gptel-max-tokens 1024
 gptel-directives '(
                    (default . "You are a helpful assistant. Be concise.")
                    (code    . "You are an expert programmer. Reply with code only, no explanation unless asked.")
                    (explain . "Explain the following clearly and briefly."))
 )

(add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
(add-hook 'gptel-post-response-functions 'gptel-end-of-response)

(defun my/gptel-use-sonnet ()
  "Switch current buffer to Claude Sonnet for complex tasks."
  (interactive)
  (setq-local gptel-model 'claude-sonnet-4-6)
  (message "gptel: switched to Sonnet 4.6"))

(defun my/gptel-use-haiku ()
  "Switch current buffer back to Haiku for lightweight tasks."
  (interactive)
  (setq-local gptel-model 'claude-haiku-4-5-20251001)
  (message "gptel: switched to Haiku 4.5"))

(setq +format-on-save-disabled-modes
      '(dockerfile-mode
        dockerfile-ts-mode))

(map! :leader :desc "Ammend" :n "g c a" #'magit-commit-amend)
(after! eglot
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode)
                 . ("clangd"
                    "--background-index"
                    "--query-driver=/nix/store/*/bin/clang++,/nix/store/*/bin/clang"))))

(map! :leader
      :prefix ("o l" . "llm")
      :desc "Use Haiku (fast)"   "h" #'my/gptel-use-haiku
      :desc "Use Sonnet (smart)" "S" #'my/gptel-use-sonnet)
