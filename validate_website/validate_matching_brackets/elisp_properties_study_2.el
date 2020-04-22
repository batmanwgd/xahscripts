1234567890

(text-properties-at 1)

(setq xx (buffer-substring-no-properties 1 6) )
(put-text-property 0 5 'face 'font-lock-comment-delimiter-face xx )
(message "「%s」" xx)
