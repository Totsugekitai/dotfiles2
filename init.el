;;; init.el --- Emacs init code
;;; Commentary:
;;; Code:
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


;; コンパイル時のウィンドウサイズを10にする
(defun ct/create-proper-compilation-window ()
  "Setup the *compilation* window with custom settings."
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
        (let* ((w (split-window-vertically))
               (h (window-height w)))
          (select-window w)
          (switch-to-buffer "*compilation*")

          ;; Reduce window height
          (shrink-window (- h 10))

          ;; Prevent other buffers from displaying inside
          (set-window-dedicated-p w t)
          )))))

;; You can also configure builtin package via leaf!
(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :custom ((user-full-name . "Hirose Tomoyuki")
	   (user-mail-address . "37617413+Totsugekitai@users.noreply.github.com")
	   (user-login-name . "totsugekitai")
	   (truncate-lines . nil) ;; はみ出た文字を切り詰めない
	   (menu-bar-mode . nil) ;; メニューバーを出さない
	   (tool-bar-mode . nil) ;; ツールバーを出さない
	   (scroll-bar-mode . nil) ;; スクロールバーを出さない
	   (indent-tabs-mode . nil) ;; インデントは常にスペース
           (show-trailing-whitespace . t) ;; 行末スペースをハイライト
           (global-hl-line-mode . t) ;; 現在行をハイライト
           (transient-mark-mode . t) ;; 選択範囲をハイライト
           (show-paren-mode . t) ;; カッコのハイライト
           (scroll-conservatively . 1) ;; スクロールを1行ごとに
           (scroll-margin . 10) ;; スクロールの画面幅マージン
           (electric-pair-mode . t) ;; カッコの自動補完
           (global-display-line-numbers-mode . t) ;; 行番号を表示
           (electric-indent-mode . t) ;; 改行時インデント
           (make-backup-files . nil) ;; backupファイルを作成しない
           (custom-file . "~/.emacs.d/custom.el") ;; customファイルをcustom.elに書くようにする
           )
  :defvar (show-paren-style)
  :setq ((show-paren-style quote mixed))
  :bind (("C-c c" . compile))
  :hook (compilation-mode-hook . ct/create-proper-compilation-window) ;; コンパイル時ウィンドウサイズ
  :config
  (set-face-attribute 'line-number nil :background "color-233") ;; 横の行番号の色
  (set-face-attribute 'line-number-current-line nil :foreground "gold") ;; 横の行番号の色
  (set-language-environment 'Japanese) ;; 日本語環境
  (set-language-environment 'utf-8)    ;; UTF-8
  (prefer-coding-system 'utf-8)        ;; UTF-8
  (load-theme 'monokai t)) ;; monokaiテーマ

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :ensure t
  :custom ((auto-revert-interval . 0.1))
  :global-minor-mode global-auto-revert-mode)

(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :added "2021-03-21"
  :ensure t
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
  :defvar (lsp-prefer-flymake lsp-completion-provider)
  :config
  (let* (dir-list
         (expand-file-name "~/.local/nodejs/bin")
         (expand-file-name "~/.cargo/bin")
         (expand-file-name "~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin"))
    (dolist (dir dir-list exec-path)
      (setq exec-path (cons dir exec-path))))
  :setq ((lsp-prefer-flymake . nil)
         (lsp-completion-provider . :capf)
         (gc-cons-threshold . 12800000))
  :custom (lsp-rust-server . 'rls)
  :bind (:lsp-mode-map
         ("M-." . lsp-ui-peek-find-definitions)
         ("M-," . lsp-ui-peek-find-references))
  )

(leaf lsp-ui
  :doc "UI modules for lsp-mode"
  :req "emacs-26.1" "dash-2.18.0" "lsp-mode-6.0" "markdown-mode-2.3"
  :tag "tools" "languages" "emacs>=26.1"
  :added "2021-03-21"
  :url "https://github.com/emacs-lsp/lsp-ui"
  :emacs>= 26.1
  :ensure t
  :custom ((lsp-ui-peek-enable . t)
           (lsp-ui-peek-peek-height . 20)
           (lsp-ui-peek-list-width . 50))
  :commands lsp-ui-mode
  :hook (lsp-mode-hook . lsp-ui-mode))

;; ivy
(leaf ivy
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :ensure t
    :bind (("C-s" . swiper)))
  (leaf recentf
    :defvar (recentf-save-file recentf-max-saved-items recentf-exclude recentf-auto-cleanup)
    :setq ((recentf-save-file . "~/.emacs.d/.recentf")
           (recentf-max-saved-items . 200)
           (recentf-exclude . '(".recentf"))
           (recentf-auto-cleanup . 'never))
    :config (leaf recentf-ext :ensure t))
  (leaf counsel
    :after recentf
    :ensure t
    :blackout t
    :bind (("C-x C-r" . counsel-recentf))
    :custom `((counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

;; company
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

;; yasnippet
(leaf yasnippet
  :ensure t
  :global-minor-mode yas-global-mode)

;; monokai
(leaf monokai-theme :ensure t)

;; C/C++
(leaf cc-mode
  :doc "major mode for editing C and similar languages"
  :tag "builtin"
  :added "2021-03-21"
  :defvar (c-basic-offset)
  :bind (c-mode-base-map ("C-c c" . compile))
  :hook
  ((c-mode-hook c++-mode-hook) . lsp)
  (c-mode-common-hook . (lambda nil
                          (add-hook (make-local-variable 'before-save-hook) 'clang-format-buffer)))
  :mode-hook
  (c-mode-hook . ((c-set-style "linux")
                  (setq c-basic-offset 4)))
  (c++-mode-hook . ((c-set-style "linux")
                    (setq c-basic-offset 2))))

;; clang-format
(leaf clang-format :ensure t)

;; Python
(leaf lsp-pyright :ensure t)

;; GNU Global
(leaf ggtags
  :ensure t
  :config
  :hook (c-mode-common-hook (lambda nil
                              (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
                                (ggtags-mode 1)))))

;; Rust
(leaf rust-mode
  :doc "A major-mode for editing Rust source code"
  :req "emacs-25.1"
  :tag "languages" "emacs>=25.1"
  :added "2021-06-30"
  :url "https://github.com/rust-lang/rust-mode"
  :emacs>= 25.1
  :ensure t
  :hook (rust-mode-hook . lsp)
  :custom (rust-format-on-save . t))

;; Rust Cargo
(leaf cargo
  :doc "Emacs Minor Mode for Cargo, Rust's Package Manager."
  :req "emacs-24.3" "rust-mode-0.2.0" "markdown-mode-2.4"
  :tag "tools" "emacs>=24.3"
  :added "2021-06-30"
  :emacs>= 24.3
  :ensure t
  :hook (rust-mode . cargo-minor-mode)
  :bind* ("C-c c" . cargo-process-build))

;; Haskell
(leaf lsp-haskell
  :ensure t
  :hook ((haskell-mode-hook haskell-literture-mode-hook) . lsp))

;; LaTeX
(leaf tex
  :hook (LaTeX-mode-hook . (visual-line-mode LaTeX-math-mode turn-on-reftex)))

;;; init.el end section

(provide 'init)

;;; init.el ends here
