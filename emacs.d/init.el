(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

(unless (package-installed-p 'cyberpunk-theme)
  (package-install 'cyberpunk-theme))
(require 'cyberpunk-theme)
(load-theme 'cyberpunk t)

(setq backup-inhibited t)
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(setq-default indent-tabs-mode nil)

(global-auto-revert-mode t)
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq vc-follow-symlinks nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(yaml-mode go-eldoc kotlin-mode rainbow-delimiters flycheck-golangci-lint flycheck company-go direx auto-complete vimgolf golint go-autocomplete go-complete go-mode))
 '(show-paren-mode t)
 '(size-indication-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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
