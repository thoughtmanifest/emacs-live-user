;; User pack init file
;;
;; User this file to initiate the pack configuration.
;; See README for more information.
;(setq nrepl-lein-command "lein2")
;; Load bindings config
(live-load-config-file "bindings.el")

(require 'clojure-mode)
(add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))

(require 'midje-mode)
(add-hook 'clojure-mode-hook 'midje-mode)

;; nrepl stuff
(add-hook 'nrepl-interaction-mode 'paredit-mode)
(setq nrepl-popup-stacktraces nil)
;;;(add-hook 'nrepl-mode-hook 'paredit-mode)
(add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode)
;(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
;(add-to-list 'same-window-buffer-names "*nrepl*")
;; end nrepl stuff

(setq explicit-shell-file-name "bash")
(setq explicit-bash-args '("-c" "export EMACS=; stty echo; bash"))
(setq comint-process-echoes t)

(require 'readline-complete)

(add-to-list 'ac-modes 'shell-mode)
(add-hook 'shell-mode-hook 'ac-rlc-setup-sources)

;; Shell mode stuff. Set up cwd tracking via the
  ;; subshell prompt and strip it.
  (require 'dirtrack)
  (add-hook 'shell-mode-hook
            (lambda ()
              (setq dirtrack-list '("^|PrOmPt|\\([^|]*\\)|" 1 nil))
              (shell-dirtrack-mode nil)
              (add-hook 'comint-preoutput-filter-functions
                        'dirtrack nil t)
              (add-hook 'comint-preoutput-filter-functions
                        'dirtrack-filter-out-pwd-prompt t t)))
  ;; Now strip the goofy strings from the prompt before it gets into
  ;; the shell buffer.
  (defun dirtrack-filter-out-pwd-prompt (string)
    "dirtrack-mode doesn't remove the PWD match from the prompt.  This does."
    ;; TODO: support dirtrack-mode's multiline regexp.
    (if (and (stringp string) (string-match (first dirtrack-list) string))
        (replace-match "" t t string 0)
      string))

;; ;; to re-compile current function
;; (add-hook 'clojure-mode-hook
;;           '(lambda ()
;;              (define-key clojure-mode-map "\C-c\C-f" 'slime-eval-defun)))

;; for collapsing and expanding of regions
(add-hook 'clojure-mode-hook 'hs-minor-mode)

;; ;; for adding line numbers to all clojure buffers
;; (add-hook 'clojure-mode-hook 'linum-mode)

(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

;;;(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
;;;(add-hook 'clojure-mode-hook 'paredit-mode)

;; ;; ac-nrepl stuff
;; (require 'ac-nrepl)
;;  (add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
;;  (add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
;;  (eval-after-load "auto-complete"
;;    '(add-to-list 'ac-modes 'nrepl-mode))

;; (setq nrepl-popup-stacktraces nil)
;; (add-to-list 'same-window-buffer-names "*nrepl*")

;;  (defun set-auto-complete-as-completion-at-point-function ()
;;   (setq completion-at-point-functions '(auto-complete)))
;; (add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)

;; (add-hook 'nrepl-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; (add-hook 'nrepl-interaction-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; ;; ac-nrepl stuff end

;; (require 'package)
;; (add-to-list 'package-archives
;;              '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (package-initialize)

;; for PATH and env variables
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
(exec-path-from-shell-copy-env "AWS_ACCESS_KEY_ID")
(exec-path-from-shell-copy-env "AWS_SECRET_KEY")
;; end path and env variables
