;; stop the splash screen
(setq inhibit-startup-screen t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(electric-pair-mode)
(desktop-save-mode 1)

;; On mac this shows an annoying visual caution triangle. 
(setq visible-bell nil)

(load-theme 'tango-dark)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Checks to make sure a package exists before trying to load it
(setq use-package-ensure t)

;; to run this:
;; M-x command-log-mode or global-command-line-mode
;; M-x clm/toggle-command-log-buffer 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

 ;; M-x package-install-selected-packages to install these.
 '(package-selected-packages
   '(command-log-mode company counsel diff-hl doom-modeline doom-themes
                      elixir-ts-mode evil-collection
                      evil-nerd-commenter exec-path-from-shell general
                      ivy lsp-mode magit minitest projectile
                      python-mode rainbow-delimiters swiper-helm
                      vterm-toggle)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(use-package command-log-mode)
(use-package ivy
  )

(use-package emacs
  :init
 (global-set-key (kbd "<escape>") 'keyboard-escape-quit)
  (setq initial-scratch-message nil)
  (defun display-startup-echo-area-message ()
    (message ""))
  (defalias 'yes-or-no-p 'y-or-n-p)
  (set-charset-priority 'unicode)
  (setq locale-coding-system 'utf-8
        coding-system-for-read 'utf-8
        coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix))
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)
  (defun ab/enable-line-numbers ()
    "Enable relative line numbers"
    (interactive)
    (display-line-numbers-mode)
    (setq display-line-numbers 'relative))
  (add-hook 'prog-mode-hook #'ab/enable-line-numbers)
  )

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package nerd-icons)

(use-package rainbow-delimiters
  :ensure
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package evil
  :ensure
  :preface
  (customize-set-variable 'evil-want-keybinding nil) ;; if using `evil-collection'
  (customize-set-variable 'evil-want-integration t) ;; if using `evil-collection'
  (customize-set-variable 'evil-undo-system 'undo-redo)
  (customize-set-variable 'evil-want-C-u-scroll t) ;; move universal arg to <leader> u
  (customize-set-variable 'evil-want-C-u-delete t) ;; delete back to indentation in insert state
      (customize-set-variable 'evil-want-C-g-bindings t)
  :init
  (setq evil-want-keybinding nil)
 (setq evil-want-C-u-scroll t)
  :config
 (evil-mode 1))

(use-package doom-themes
  :demand
  :config
  (load-theme 'doom-challenger-deep t))

;; (use-package eglot
;;   :ensure t
;;   :hook (ruby-mode . eglot-ensure))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  (add-to-list 'exec-path "~/bin/elixirls")
  :config
  (lsp-enable-which-key-integration t))

;; (with-eval-after-load 'eglot
;;  (add-to-list 'eglot-server-programs '((ruby-mode ruby-ts-mode) "ruby-lsp")))

(use-package elixir-ts-mode
  :ensure t
  :mode (("\\.ex\\'" . elixir-ts-mode)
         ("\\.exs\\'" . elixir-ts-mode)
         ("\\mix.lock\\'" . elixir-ts-mode))
  :hook (elixir-ts-mode . lsp))

(use-package ruby-mode
  :ensure t
  :hook (ruby-mode . lsp))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp))

(use-package which-key
  :demand
  :init
  (setq which-key-idle-delay 0.5) ; Open after .5s instead of 1s
  :config
  (which-key-mode))


;; TODO
;; magit
;; orgmode
;; lsp-treemacs
;; helm

;; project management
;; +projectile
;; To add a project to Projectile’s list of known projects, open a file in the project.
;; Add a project: M-x projectile-discover-projects-in-search-path



(use-package general
  :demand
  :config
  (general-evil-setup)

  (general-create-definer leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

    ;; Some bindinfs are set here, some are set in setup for the ext, i.e., projectile
    ;; I don't like that, I might consolidate.  
  (leader-keys
    "x" '(execute-extended-command :which-key "execute command")
    "r" '(restart-emacs :which-key "restart emacs")
    "i" '((lambda () (interactive) (find-file user-init-file)) :which-key "open init file")

    ;; Buffer
    "b" '(:ignore t :which-key "buffer")
    ;; Don't show an error because SPC b ESC is undefined, just abort
    "b <escape>" '(keyboard-escape-quit :which-key t)
    "bd"  'kill-current-buffer
    "b b" '(counsel-switch-buffer :which-key "switch buffer")
    "a" '(comment-or-uncomment-region :which-key "toggle comment")
    "f" '(counsel-find-file :which-key "find-file")
  ))

(use-package projectile
  :demand
  :general
  (leader-keys
    :states 'normal
    ;; Buffers

    ;; Projects
    "p" '(:ignore t :which-key "projects")
    "p <escape>" '(keyboard-escape-quit :which-key t)
    "p p" '(projectile-switch-project :which-key "switch project")
    "p a" '(projectile-add-known-project :which-key "add project")
    "p r" '(projectile-remove-known-project :which-key "remove project"))
  :init
  (projectile-mode +1))


;; magit
(use-package magit
  :general
  (leader-keys
   "g" '(:ignore t :which-key "git")
    "g <escape>" '(keyboard-escape-quit :which-key t)
    "g g" '(magit-status :which-key "status")
    "g l" '(magit-log :which-key "log"))
  (general-nmap
    "<escape>" #'transient-quit-one))

;; better magit key bindings
(use-package evil-collection
  :after evil
  :demand
  :config
  (evil-collection-init))
;; highlights uncommitted changes
(use-package diff-hl
  :init
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  :config
  (global-diff-hl-mode))

(use-package vterm)

;; <leader>-' will toggle a terminal
(use-package vterm-toggle
  :general
  (leader-keys
    "'" '(vterm-toggle :which-key "terminal")))

;; commenting
(use-package evil-nerd-commenter
  :general
  (general-nvmap
    "gc" 'evilnc-comment-operator))
