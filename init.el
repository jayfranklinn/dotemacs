;;; package --- Summary
;;; Commentary:

;;; Code:
;; init package sources
(require 'package)

(if (not (file-directory-p  "~/.elpa-mirror/"))

    (setq package-archives
	  '(("org" . "https://orgmode.org/elpa/")
	    ("melpa" . "http://melpa.org/packages/")
	    ("gnu" . "http://elpa.gnu.org/packages/")))

  (setq package-enable-at-startup nil)
  (setq package-archives
	'(("org" . "~/.elpa-mirror/org/")
	  ("melpa" . "~/.elpa-mirror/melpa/")
	  ("gnu" . "~/.elpa-mirror/gnu/")))
  (setq configuration-layer--elpa-archives
	'(("org" . "~/.elpa-mirror/org/")
	  ("melpa" . "~/.elpa-mirror/melpa/")
	  ("gnu" . "~/.elpa-mirror/gnu/"))))

;; init packages
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

;; misc
(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(global-display-line-numbers-mode t)

(load-theme 'nyx t)

(if (not (file-directory-p "~/.elpa-mirror/"))
    (progn
      (setq font-height 200)
      (setq mode-line-height 30))
  (progn
    (setq font-height 140)
    (setq mode-line-height 20)))

(set-face-attribute 'default nil :font "DejaVu Sans Mono" :height font-height)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode t)
  :custom ((doom-modeline-height mode-line-height)))

(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)

(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(global-set-key (kbd "M-j")  'windmove-left)
(global-set-key (kbd "M-k") 'windmove-right)
(global-set-key (kbd "M-h")    'windmove-up)
(global-set-key (kbd "M-l")  'windmove-down)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq initial-scratch-message "")

;; packages
(use-package ivy
  :diminish
  :bind (:map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line))
  :config
  (ivy-mode t))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)))
(global-set-key (kbd "M-b") nil)
(global-set-key (kbd "M-b") 'counsel-switch-buffer)

(use-package magit)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.3))

(use-package flycheck)
(global-flycheck-mode)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line))
(use-package evil-collection
  :after evil
  :config (evil-collection-init))
(evil-set-undo-system 'undo-redo)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/playground/")
    (setq projectile-project-search-path '("~/playground/")))
  (setq projectile-switch-project-action #'projectile-dired))
(use-package counsel-projectile
  :config (counsel-projectile-mode))

(setq lsp-mode-packages '(clojure-mode lsp-mode))
(when (cl-find-if-not #'package-installed-p lsp-mode-packages)
  (package-refresh-contents)
  (mapc #'package-install lsp-mode-packages))
(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      lsp-lens-enable t
      lsp-signature-auto-activate nil)

(use-package cider)

(use-package company
  :init (global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1)
  (company-show-numbers t))

(use-package restclient)

(use-package smartparens)
(require 'smartparens-config)
(add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)
(smartparens-global-mode t)
(global-set-key (kbd "M-s k") 'sp-forward-slurp-sexp)
(global-set-key (kbd "M-s j") 'sp-forward-barf-sexp)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-show-quick-access t nil nil "Customized with use-package company")
 '(custom-safe-themes
   '("dc11cee30927281fe3f5c77372119d639e77e86aa794dce2a6ff019afdfbec9e" "16ab866312f1bd47d1304b303145f339eac46bbc8d655c9bfa423b957aa23cc9" default))
 '(package-selected-packages
   '(smartparens evil-smartparens restclient nyx-theme badwolf-theme clojure-mode flycheck lsp-mode cider evil-magit magit counsel-projectile projectile evil-collection evil counsel which-key rainbow-delimiters doom-modeline ivy use-package)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "dark gray")))))
