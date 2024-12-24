;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Davis Muro"
      user-mail-address "davis.ray.muro@gmail.com")

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
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14 :weight 'bold)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 18 :weight 'bold)
      doom-variable-pitch-font (font-spec :family "SF Pro Text"))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
;;
;; My current favorites: doom-homage-black
(setq doom-theme 'doom-nord)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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

;; Less annoying C++ idents
(defun c++-mode-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook 'c++-mode-hook)

;; Disable quit confirmation prompt
(setq! confirm-kill-emacs nil)

(after! projectile
  (map! :leader :desc "Update project index" :n "p l" #'projectile-discover-projects-in-search-path)
  (setq! projectile-project-search-path '("~/workspace" "~/workspace/school")))

;; Zen mode customization
(setq! +zen-text-scale 1.2)
(after! mixed-pitch-mode
  (setq mixed-pitch-set-height t))

;; Org mode customization
(add-hook! 'org-mode-hook #'+org-pretty-mode #'mixed-pitch-mode)

;; Modeline customization
(after! doom-modeline
  (remove-hook 'doom-modeline-mode-hook #'size-indication-mode)
  (remove-hook 'doom-modeline-mode-hook #'column-number-mode)
  (line-number-mode -1))

;; Deft customization
(setq! deft-extensions '("txt" "org")
       deft-directory "~/Notes"
       deft-recursive t
       deft-use-filename-as-title t)
