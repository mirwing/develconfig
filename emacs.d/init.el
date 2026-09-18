;;; init.el --- Personal Emacs Configuration -*- lexical-binding: t; -*-

;; -------------------------------------------------------------------
;; 1. 시작 속도 가속화 (GC 임계값 조정)
;; -------------------------------------------------------------------
(setq gc-cons-threshold (* 50 1024 1024))
(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold (* 2 1024 1024))))

;; -------------------------------------------------------------------
;; 2. 패키지 매니저 (HTTPS MELPA & ELPA)
;; -------------------------------------------------------------------
(when (>= emacs-major-version 24)
  (require 'package)
  (setq package-archives
        '(("gnu"   . "https://elpa.gnu.org/packages/")
          ("melpa" . "https://melpa.org/packages/")))
  (package-initialize))

;; Emacs 29+ / 30 / 31 내장 use-package 설정
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; 누락된 패키지 자동 설치 헬퍼
(defun ensure-package-installed (pkg)
  (unless (package-installed-p pkg)
    (ignore-errors
      (unless package-archive-contents
        (package-refresh-contents))
      (package-install pkg))))

;; -------------------------------------------------------------------
;; 3. 기본 편집 및 버퍼 환경 설정
;; -------------------------------------------------------------------
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
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

;; find file & paren
(ido-mode)
(show-paren-mode 1)
(setq show-paren-delay 0)
(electric-pair-mode 1)
(delete-selection-mode 1)
(setq vc-follow-symlinks nil)

;; -------------------------------------------------------------------
;; 4. 터미널 (-nw) 모드 최적화 (마우스 및 macOS 클립보드 연동)
;; -------------------------------------------------------------------
(unless (display-graphic-p)
  ;; 터미널 모드에서 마우스 클릭 및 스크롤 지원
  (xterm-mouse-mode 1)

  ;; macOS 클립보드(pbcopy / pbpaste) 연동
  (defun paste-to-osx (text &optional _push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))
  (defun copy-from-osx ()
    (shell-command-to-string "pbpaste"))
  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx))

;; -------------------------------------------------------------------
;; 5. 언어 및 한글 설정
;; -------------------------------------------------------------------
(set-language-environment "Korean")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq default-input-method "korean-hangul")
(global-set-key (kbd "C-SPC") #'toggle-input-method)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(cyberpunk-theme web-mode go-eldoc swiper lsp-mode doom-modeline helm rjsx-mode flycheck-kotlin posframe lsp-dart js2-mode go-autocomplete typescript-mode yaml-mode kotlin-mode rainbow-delimiters flycheck-golangci-lint flycheck company-go auto-complete vimgolf golint go-complete go-mode treemacs anaconda-mode))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(warning-suppress-types '((comp) (files))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; -------------------------------------------------------------------
;; 6. 테마 설정 (Cyberpunk)
;; -------------------------------------------------------------------
(ensure-package-installed 'cyberpunk-theme)
(when (or (package-installed-p 'cyberpunk-theme)
          (require 'cyberpunk-theme nil t))
  (load-theme 'cyberpunk t))

;; -------------------------------------------------------------------
;; 7. 주요 패키지 설정 (안전 로딩 지원)
;; -------------------------------------------------------------------
(ensure-package-installed 'helm)
(when (require 'helm nil t)
  (helm-mode 1))

(ensure-package-installed 'treemacs)
(when (require 'treemacs nil t)
  (setq treemacs-width 30
        treemacs-indentation 2
        treemacs-follow-after-init t
        treemacs-recenter-after-file-follow t
        treemacs-silent-refresh t
        treemacs-sorting 'alphabetic-asc
        treemacs-persist-file nil)

  ;; 실행 위치(default-directory) 또는 현재 파일의 Git 루트를 워크스페이스로 잡고 창으로 포커스
  (defun my-treemacs-jump ()
    "현재 버퍼의 파일 또는 Emacs 실행 위치를 Treemacs에서 찾아 창을 열고 포커스합니다.
이미 Treemacs 창에 있을 때는 창을 닫습니다."
    (interactive)
    (if (and (fboundp 'treemacs-is-treemacs-window?)
             (treemacs-is-treemacs-window? (selected-window)))
        (treemacs-quit)
      (let* ((raw-file (buffer-file-name (buffer-base-buffer)))
             (file (when raw-file (file-truename raw-file)))
             (target-dir (file-truename (if file
                                            (file-name-directory file)
                                          default-directory)))
             (root (or (locate-dominating-file target-dir ".git")
                       (ignore-errors (project-root (project-current nil target-dir)))
                       target-dir))
             (canonical-root (treemacs-canonical-path root))
             (name (file-name-nondirectory (directory-file-name canonical-root))))
        (unless (treemacs-current-workspace)
          (treemacs--find-workspace))
        (let ((project (or (treemacs--find-project-for-path canonical-root)
                           (when file (treemacs--find-project-for-path file)))))
          (unless project
            (treemacs-do-add-project-to-workspace canonical-root name)
            (setq project (or (treemacs--find-project-for-path canonical-root)
                              (when file (treemacs--find-project-for-path file)))))
          (pcase (treemacs-current-visibility)
            ('visible (treemacs--select-visible-window))
            ('exists  (treemacs--select-not-visible-window))
            ('none    (treemacs--init)))
          (treemacs-select-window)
          (when (and file (file-exists-p file) project)
            (ignore-errors (treemacs-goto-file-node file project)))
          (treemacs-select-window)))))

  ;; 파일 선택(RET) 시 파일을 열고 Treemacs 창을 자동으로 닫기 (디렉터리는 펼침 유지)
  (with-eval-after-load 'treemacs
    (define-key treemacs-mode-map (kbd "RET")
      (lambda ()
        (interactive)
        (let ((btn (treemacs-current-button)))
          (if (and btn (memq (treemacs-button-get btn :type) '(file tag tag-node tag-leaf)))
              (progn
                (treemacs-visit-node-default)
                (treemacs-quit))
            (treemacs-RET-action)))))
    (define-key treemacs-mode-map (kbd "q") #'treemacs-quit)
    (define-key treemacs-mode-map (kbd "C-x C-j") #'treemacs-quit))

  (global-set-key (kbd "C-x C-j") 'my-treemacs-jump)
  (global-set-key (kbd "M-0") 'treemacs-select-window)
  (global-set-key (kbd "C-c t t") 'treemacs))

(ensure-package-installed 'auto-complete)
(when (require 'auto-complete nil t)
  (require 'auto-complete-config nil t)
  (ac-config-default))


(ensure-package-installed 'flycheck)
(when (require 'flycheck nil t)
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-golangci-lint-setup)))

(ensure-package-installed 'rainbow-delimiters)
(when (require 'rainbow-delimiters nil t)
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; (global-set-key (kbd "C-c <left>")  'windmove-left)
;; (global-set-key (kbd "C-c <right>") 'windmove-right)
;; (global-set-key (kbd "C-c <up>")    'windmove-up)
;; (global-set-key (kbd "C-c <down>")  'windmove-down)

(ensure-package-installed 'anaconda-mode)
(when (require 'anaconda-mode nil t)
  (add-hook 'python-mode-hook #'anaconda-mode))

(ensure-package-installed 'go-mode)
(when (require 'go-mode nil t)
  (autoload 'go-mode "go-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

  (ensure-package-installed 'go-eldoc)
  (require 'go-eldoc nil t)
  (ensure-package-installed 'go-autocomplete)
  (require 'go-autocomplete nil t)

  (add-hook 'go-mode-hook (lambda ()
                           (when (fboundp 'go-eldoc-setup) (go-eldoc-setup))
                           (setq gofmt-command "goimports")
                           (add-hook 'before-save-hook #'gofmt-before-save)
                           (setq tab-width 4)
                           (setq indent-tabs-mode 1)
                           (set (make-local-variable 'compile-command)
                                "go build -v && go test -v && go vet")
                           (local-set-key (kbd "C-c C-l") 'compile))))
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
(add-hook 'c-mode-common-hook #'my-c-mode-common-hook)

(setq js-indent-level 2)

(ensure-package-installed 'web-mode)
(when (require 'web-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

(ensure-package-installed 'typescript-mode)
(when (require 'typescript-mode nil t)
  (setq typescript-indent-level 2)
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . rjsx-mode)))

(ensure-package-installed 'rjsx-mode)
(when (require 'rjsx-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . rjsx-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode)))

