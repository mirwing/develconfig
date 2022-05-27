(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

(setq backup-inhibited t)
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq create-lockfiles nil)
;; tab => space (4)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;; auto reload file
(global-auto-revert-mode t)
;; buffer open same window
(global-set-key "\C-x\C-b" 'buffer-menu)
;; find file
(ido-mode)
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq vc-follow-symlinks nil)

(set-language-environment "Korean")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq default-input-method "korean-hangul")
(global-set-key (kbd "C-SPC") `toggle-input-method)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(swiper lsp-mode doom-modeline helm rjsx-mode flycheck-kotlin posframe lsp-dart js2-mode go-autocomplete typescript-mode yaml-mode go-eldoc kotlin-mode rainbow-delimiters flycheck-golangci-lint flycheck company-go auto-complete vimgolf golint go-complete go-mode))
 '(show-paren-mode t)
 '(size-indication-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(require 'cyberpunk-theme)
(load-theme 'cyberpunk t)

(require 'helm-config)
(helm-mode 1)

(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

(require 'auto-complete)
(ac-config-default)

(require 'flycheck)
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-golangci-lint-setup))

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; (global-set-key (kbd "C-c <left>")  'windmove-left)
;; (global-set-key (kbd "C-c <right>") 'windmove-right)
;; (global-set-key (kbd "C-c <up>")    'windmove-up)
;; (global-set-key (kbd "C-c <down>")  'windmove-down)

(require 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-mode)

(require 'go-mode)
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(require 'go-eldoc)
(require 'go-autocomplete)
(require 'auto-complete-config)
(add-hook 'go-mode-hook (lambda ()
                         (go-eldoc-setup)
                         (setq gofmt-command "goimports")
                         (add-hook 'before-save-hook 'gofmt-before-save)
                         (setq tab-width 4)
                         (setq indent-tabs-mode 1)
                         (set (make-local-variable 'compile-command)
                              "go build -v && go test -v && go vet")
                         (local-set-key (kbd "C-c C-l") 'compile)))
(put 'downcase-region 'disabled nil)

(defun my-c-mode-common-hook ()
  (c-set-offset 'substatement-open 0)

  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4)                  ;; Default is 2
  (setq c-indent-level 4)                  ;; Default is 2

  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
  (setq indent-tabs-mode t)  ; use spaces only if nil
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(setq js-indent-level 2)

(require 'typescript-mode)
(use-package typescript-mode
  :ensure t
  :config
  (setq typescript-indent-level 2)
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . rjsx-mode)))

(require 'rjsx-mode)
(use-package rjsx-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . rjsx-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode)))
