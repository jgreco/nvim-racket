#lang racket
(require msgpack)

(define nvim-api (call-with-input-bytes (with-output-to-bytes (λ () (system "nvim --api-info"))) unpack))
(define nvim-functions (hash-ref nvim-api "functions"))
(define nvim-error_types (hash-ref nvim-api "error_types"))
(define nvim-version (hash-ref nvim-api "version"))
(define nvim-types (hash-ref nvim-api "types"))
(define (list-functions)
  (map (λ (x) (hash-ref x "name"))
       (vector->list nvim-functions)))
(define (get-function x)
  (car (filter (λ (y) (equal? x (hash-ref y "name")))
               (vector->list nvim-functions))))
(define (non-deprecated-funcs)
  (filter (λ (f) (not (hash-has-key? f "deprecated_since")))
          (vector->list nvim-functions)))

;(define (read-syntax path port)
  ;(define parse-tree (generate-body)) ;(parse path (make-tokenizer port)))
  ;(define module-datum `(module vim-rpc racket ,@parse-tree))
  ;(datum->syntax #f module-datum))
;(provide read-syntax)


(define (generate-body)
  `(define vim-rpc%
     (class msgpack-rpc%
       (super-new)
       (inherit call call/async)
       ,@(generate-methods)
       )))

(define (generate-methods)
 (map create-method (non-deprecated-funcs)))

(define (create-method f)
  (let ([return_type (hash-ref f "return_type")]
        [method (hash-ref f "method")]
        [name (hash-ref f "name")]
        [parameters (map (λ (x) (string->symbol (vector-ref x 1))) 
                         (vector->list (hash-ref f "parameters")))])
    `(define/public (,(string->symbol name) ,@parameters)
       (call ,name ,@parameters))))

(write `(module vim-rpc racket
         (require nvim-racket/msgpack-rpc)
         (provide vim-rpc%)
         ,(generate-body)))
