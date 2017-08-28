#lang racket
(require msgpack)

(provide msgpack-rpc%)

(define msgpack-rpc%
  (class object%
    (init-field
      [in (current-input-port)]
      [out (current-output-port)])
    (super-new)

    (define/public (call cmd . parameters)
      (pack (list 0 (current-seconds) cmd parameters) out)
      (flush-output out)
      (receive))

    ;TODO
    (define/public (call/async cmd . parameters)
      (let ([t (current-seconds)])
        (pack (list 0 t cmd parameters) out)
        (flush-output out)
        (receive)))

    (define/public (receive)
      (unpack in))

    (define/public (event-loop handlers)
      (let* ([e (receive)]
             [cmd (vector-ref e 1)]
             [args (vector->list (vector-ref e 2))])
        (when (hash-has-key? handlers cmd)
          ((hash-ref handlers cmd) args)))
      (event-loop handlers))))
