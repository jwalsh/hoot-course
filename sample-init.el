;;; Emacs configuration for Scheme, Guile, and Sourcehut integration

;; User-specific variables (modify these)
(defvar user-projects-directory "~/Projects"
  "Directory where your projects are stored.")

(defvar user-sourcehut-email "your-username@example.com"
  "Your sourcehut email address.")

(defvar user-sourcehut-smtp-server "smtp.sourcehut.org"
  "SMTP server for sourcehut.")

(defvar user-sourcehut-smtp-port 587
  "SMTP port for sourcehut.")

;; Package management setup
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Scheme and Guile setup
(use-package geiser
  :ensure t
  :config
  (setq geiser-active-implementations '(guile)))

(use-package geiser-guile
  :ensure t)

(use-package scheme
  :mode ("\\.scm\\'" . scheme-mode)
  :interpreter ("guile" . scheme-mode))

(use-package paredit
  :ensure t
  :hook ((scheme-mode . paredit-mode)
         (geiser-repl-mode . paredit-mode)))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-project-search-path (list user-projects-directory)))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; Optional: Support for running Guile scripts
(use-package run-guile
  :ensure t
  :config
  (add-hook 'scheme-mode-hook 'run-guile-mode))

;; Optional: Support for Guix
(use-package guix
  :ensure t
  :config
  (require 'guix-emacs)
  (guix-emacs-autoload-packages))

;; Sourcehut integration

;; Enable VC (Version Control) integration
(require 'vc)

;; Set up Magit for Git operations
(use-package magit
  :ensure t
  :config
  (setq magit-repository-directories `((,user-projects-directory . 2))))

;; Configure git-send-email for sourcehut
(use-package git-email
  :ensure t
  :config
  (setq git-email-smtp-server user-sourcehut-smtp-server
        git-email-smtp-user user-sourcehut-email
        git-email-smtp-port user-sourcehut-smtp-port
        git-email-smtp-encryption 'starttls))

;; Set up forge for sourcehut integration
(use-package forge
  :ensure t
  :after magit
  :config
  (add-to-list 'forge-alist
               '("sr.ht" "git.sr.ht" "~%u/%n" "~%u/%n/issues"
                 "~%u/%n/patches" nil nil)))

;; Configure Emacs to use the correct email address for sourcehut
(setq user-mail-address user-sourcehut-email)

;; Set up git-link for easy linking to sourcehut files
(use-package git-link
  :ensure t
  :config
  (setq git-link-default-branch "master")
  (add-to-list 'git-link-remote-alist
               '("git\\.sr\\.ht" git-link-sourcehut)))

;; Set up diff-hl for highlighting changes in the gutter
(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))
