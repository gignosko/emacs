;; stop the splash screen
(setq inhibit-startup-screen t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(electric-pair-mode)
(desktop-save-mode 1)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

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
(use-package command-log-mode)
(use-package ivy
  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(command-log-mode elixir-ts-mode evil exec-path-from-shell ivy
		      lsp-mode projectile rainbow-delimiters ts-fold)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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
  :config
  (evil-mode 1)
  ;; disable this when using `general.el'
  (evil-set-leader '(normal visual) (kbd "SPC"))
  (evil-set-leader '(normal visual) (kbd "C-c SPC") t))

  ;; (use-package lsp-mode
  ;;   :commands lsp
  ;;   :ensure t
  ;;   :diminish lsp-mode
  ;;   :hook
  ;;   (elixir-mode . lsp)
  ;;   (ruby-mode . lsp)
  ;;   :init
  ;;   (add-to-list 'exec-path "/Users/gignosko/bin/elixirls")
  ;;   (add-to-list 'exec-path "/Users/gignosko/.asdf/shims/ruby-lsp")
  ;;   )

(use-package eglot
  :ensure t
  :hook (ruby-mode . eglot-ensure))

;; (with-eval-after-load 'eglot
;;  (add-to-list 'eglot-server-programs '((ruby-mode ruby-ts-mode) "ruby-lsp")))

;; (use-package elixir-ts-mode
;;   :ensure t
;;   :hook (elixir-ts-mode . lsp))

(use-package ruby-mode
  :ensure t
  :hook (ruby-mode . eglot-ensure))


(which-key-mode)


;; TODO
;; magit
;; orgmode
;; lsp-treemacs
;; helm

;; project management
;; +projectile
;; To add a project to Projectile’s list of known projects, open a file in the project.
;; Add a project: M-x projectile-discover-projects-in-search-path
(use-package projectile
  :ensure t
  :init
  (setq projectile-project-search-path '("~/dev/elixir/" "~/dev/python/" ("~/dev/ruby/" . 1)))
  (setq projectile-completion-system 'ivy)
  :config
  ;; I typically use this keymap prefix on macOS
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (global-set-key (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))
