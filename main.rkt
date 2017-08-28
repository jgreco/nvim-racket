#lang racket
(require racket/unix-socket)
(require nvim-racket/vim-rpc)

(provide vim-rpc%)

;(define vim-rpc 
  ;(let-values ([(in out) (unix-socket-connect "/tmp/nvimsocket2")])
    ;(new vim-rpc%
         ;[in in]
         ;[out out])))
;(provide vim-rpc)

;(send vim-rpc event-loop 
      ;(hash "PING" (λ (args) (send vim-rpc nvim_command "echo\"PONG!\""))
            ;"PIG"  (λ (args) (send vim-rpc nvim_command "echo\"PORK!\""))))

;(define (call cmd . parameters)
 ;(pack (list 0 (current-seconds) cmd parameters) nvim-out)
 ;(flush-output nvim-out)
 ;(unpack nvim-in))

;(define (command cmd)
 ;(call "nvim_command" cmd))

;(define (echo str)
 ;(command (string-append "echo \"" str "\"")))

;(call "nvim_buf_line_count" (vector-ref (call "nvim_get_current_buf") 3 ))
