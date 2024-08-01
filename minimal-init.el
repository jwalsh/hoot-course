;;; Minimal Emacs configuration for Scheme, Guile, and Sourcehut integration

;; Package management setup
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Ensure all packages are installed
(setq use-package-always-ensure t)

;; Scheme and Guile setup
(use-package geiser
  :config
  (setq geiser-active-implementations '(guile)))

(use-package geiser-guile)

(use-package scheme
  :mode ("\\.scm\\'" . scheme-mode)
  :interpreter ("guile" . scheme-mode))

(use-package paredit
  :hook ((scheme-mode . paredit-mode)
         (geiser-repl-mode . paredit-mode)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package company
  :hook (after-init . global-company-mode))

(use-package flycheck
  :config
  (global-flycheck-mode))

(use-package projectile
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package which-key
  :config
  (which-key-mode))

;; Sourcehut integration
(use-package magit)

(use-package forge
  :after magit
  :config
  (add-to-list 'forge-alist
               '("sr.ht" "git.sr.ht" "~%u/%n" "~%u/%n/issues"
                 "~%u/%n/patches" nil nil)))

(use-package git-link
  :config
  (setq git-link-default-branch "master")
  (add-to-list 'git-link-remote-alist
               '("git\\.sr\\.ht" git-link-sourcehut)))

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

;; General settings
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq inhibit-startup-screen t)
(setq create-lockfiles nil)
(show-paren-mode 1)
(electric-pair-mode 1)

;; Key bindings
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; Backup settings
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-save-list/" t)))
