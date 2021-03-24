;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
		       ("melpa" . "https://melpa.org/packages/")
		       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
	:ensure t
	:init
	;; optional packages if you want to use :hydra, :el-get, :blackout,,,
	(leaf hydra :ensure t)
	(leaf el-get :ensure t)
	(leaf blackout :ensure t)

	:config
	;; initialize leaf-keywords.el
	(leaf-keywords-init)))
;; </leaf-install-code>

;; Now you can use leaf!
(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)
(leaf transient-dwim
      :ensure t
      :bind (("M-=" . transient-dwim-dispatch)))

;; You can also configure builtin package via leaf!
(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :custom ((user-full-name . "Hirose Tomoyuki")
	   (user-mail-address . "hrstmyk811m@gmail.com")
	   (user-login-name . "totsugekitai")
	   (truncate-lines . nil) ;; はみ出た文字を切り詰めない
	   (menu-bar-mode . nil) ;; メニューバーを出さない
	   (tool-bar-mode . nil) ;; ツールバーを出さない
	   (scroll-bar-mode . nil) ;; スクロールバーを出さない
	   (indent-tabs-mode . nil) ;; インデントは常にスペース
           (show-trailing-whitespace . t) ;; 行末スペースをハイライト
           ;;(global-hl-line-mode . t) ;; 現在行をハイライト
           (transient-mark-mode . t) ;; 選択範囲をハイライト
           (show-paren-mode . t) ;; カッコのハイライト
           (scroll-conservatively . 1) ;; スクロールを1行ごとに
           (scroll-margin . 10) ;; スクロールの画面幅マージン
           (electric-pair-mode . t) ;; カッコの自動補完
           (global-display-line-numbers-mode . t) ;; 行番号を表示
           (electric-indent-mode . t) ;; 改行時インデント
           (make-backup-files . nil) ;; backupファイルを作成しない
           )
  :setq ((show-paren-style quote mixed))
  :config
  ;; 横の行番号の色
  (set-face-attribute 'line-number nil
                      :foreground "DarkOliveGreen"
                      :background "dark")
  ;; 横の行番号の色
  (set-face-attribute 'line-number-current-line nil
                      :foreground "gold")
  (set-language-environment 'Japanese) ;; 日本語環境
  (set-language-environment 'utf-8) ;; UTF-8
  (prefer-coding-system 'utf-8) ;; UTF-8
  (load-theme 'monokai t) ;; monokaiテーマ
  )

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 0.1))
  :global-minor-mode global-auto-revert-mode)

(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :added "2021-03-21"
  :global-minor-mode delete-selection-mode)

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "dash-20200524" "git-commit-20200516" "transient-20200601" "with-editor-20200522"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :added "2021-03-22"
  :url "https://github.com/magit/magit"
  :emacs>= 25.1
  :ensure t
  :bind (("M-g" . magit-status)))

(leaf git-gutter+
  :doc "Manage Git hunks straight from the buffer"
  :req "git-commit-0" "dash-0"
  :tag "vc" "git"
  :added "2021-03-22"
  :url "https://github.com/nonsequitur/git-gutter-plus"
  :ensure t
  :global-minor-mode global-git-gutter+-mode)

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "tools" "languages" "convenience" "emacs>=24.3"
  :added "2021-03-21"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :global-minor-mode global-flycheck-mode)

(leaf lsp-mode
  :doc "LSP mode"
  :req "emacs-26.1" "dash-2.18.0" "f-0.20.0" "ht-2.3" "spinner-1.7.3" "markdown-mode-2.3" "lv-0"
  :tag "languages" "emacs>=26.1"
  :added "2021-03-21"
  :url "https://github.com/emacs-lsp/lsp-mode"
  :emacs>= 26.1
  :ensure t
  :commands lsp
  :hook ((c-mode-hook c++-mode-hook rustic-mode-hook) . lsp)
  :config
  (add-to-list 'exec-path (expand-file-name "~/.local/bin/"))
  :setq ((lsp-prefer-flymake . nil)
         (lsp-prefer-capf . t)
         (gc-cons-threshold . 12800000)
         (rustic-lsp-server . 'rust-analyzer)))

(leaf lsp-ui
  :doc "UI modules for lsp-mode"
  :req "emacs-26.1" "dash-2.18.0" "lsp-mode-6.0" "markdown-mode-2.3"
  :tag "tools" "languages" "emacs>=26.1"
  :added "2021-03-21"
  :url "https://github.com/emacs-lsp/lsp-ui"
  :emacs>= 26.1
  :ensure t
  :commands lsp-ui-mode)

(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :added "2021-03-21"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :global-minor-mode global-company-mode
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence))))

(leaf company-c-headers
  :doc "Company mode backend for C/C++ header files"
  :req "emacs-24.1" "company-0.8"
  :tag "company" "development" "emacs>=24.1"
  :added "2021-03-21"
  :emacs>= 24.1
  :ensure t
  :after company
  :defvar company-backends
  :config
  (add-to-list 'company-backends 'company-capf))

(leaf cc-mode
  :doc "major mode for editing C and similar languages"
  :tag "builtin"
  :added "2021-03-21"
  :defvar (c-basic-offset)
  :bind (c-mode-base-map ("C-c c" . compile))
  :mode-hook
  (c-mode-hook . ((c-set-style "linux")
                  (setq c-basic-offset 4)))
  (c++-mode-hook . ((c-set-style "linux")
                    (setq c-basic-offset 4))))

(leaf rustic
  :doc "Rust development environment"
  :req "emacs-26.1" "xterm-color-1.6" "dash-2.13.0" "s-1.10.0" "f-0.18.2" "markdown-mode-2.3" "spinner-1.7.3" "let-alist-1.0.4" "seq-2.3" "ht-2.0"
  :tag "languages" "emacs>=26.1"
  :added "2021-03-21"
  :emacs>= 26.1
  :ensure t
  :hook (rustic-mode . cargo-minor-mode)
  :setq((rustic-format-on-save . nil)
        (rustic-lsp-format . t)))



;; -----
;; auto configuration
;; -----
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(electric-indent-mode t)
 '(electric-pair-mode t)
 '(global-display-line-numbers-mode t)
 '(indent-tabs-mode nil)
 '(make-backup-files nil)
 '(menu-bar-mode nil)
 '(package-archives
   (quote
    (("org" . "https://orgmode.org/elpa/")
     ("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/"))))
 '(package-selected-packages
   (quote
    (company-c-headers bind-key company lsp-ui lsp-mode flycheck monokai-theme transient-dwim leaf-convert leaf-tree blackout el-get hydra leaf-keywords leaf)))
 '(scroll-bar-mode nil)
 '(scroll-conservatively 1)
 '(scroll-margin 10)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t)
 '(truncate-lines nil)
 '(user-full-name "Hirose Tomoyuki")
 '(user-login-name "totsugekitai" t)
 '(user-mail-address "hrstmyk811m@gmail.com"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
