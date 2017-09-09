#lang racket
(require msgpack)
(require racket/control)

(provide msgpack-rpc%)

(define msgpack-rpc%
  (class object%
    (init-field
      [in (current-input-port)]
      [out (current-output-port)])
    (super-new)

    (define continuations (make-hash))

    (define/public (call cmd . parameters)
      (pack (list 0 (current-seconds) cmd parameters) out) (flush-output out)
      (receive))

    (define/public (call/async cmd . parameters)
      (let/cc k
              (let ([msgid (current-seconds)])
                (pack (list 0 msgid cmd parameters) out) (flush-output out)
                (hash-set! continuations msgid k)
                (abort))))

    (define/public (receive)
      (unpack in))

    (define/public (event-loop handler)
      (prompt
        (match (receive)
          [(vector 2 cmd args)
           (apply handler cmd (vector->list args))]
          [(vector 1 msgid cmd args)
           (let ([k (hash-ref continuations msgid #f)])
             (when k (k (cons cmd args))))]
          [_ #f]))
      (event-loop handler))))
