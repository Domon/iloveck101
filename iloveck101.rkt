#lang racket

(require net/url
         (planet neil/html-parsing:2:0)
         (planet lizorkin/sxml:2:1/sxml))

(define verbose-mode (make-parameter #f))

(define thread-url
  (command-line
   #:program "iloveck101"
   #:once-each
   [("--verbose" "-v") "Be verbose" (verbose-mode #t)]
   #:ps "<url> should be a url of a thread, e.g. http://ck101.com/thread-2826444-1-1.html"
   #:args
   (url) (string->url url)))

(define doc
  (call/input-url
    thread-url
    (lambda (url headers)
      (get-pure-port url #:redirections 5))
    (lambda (in)
      (html->xexp in))
    (list "User-Agent: Mozilla/5.0")))

(define thread-id-with-subject
  (let* ([thread-path (path/param-path (last (url-path thread-url)))]
         [thread-id (second (regexp-match "thread-([0-9]*)-.*" thread-path))]
         [thread-title (first ((sxpath "//title/text()") doc))]
         [thread-subject (first (string-split thread-title " - "))]
         [clean-thread-subject (regexp-replace* "[\\\\/]" thread-subject "")])
    (string-append thread-id " - " clean-thread-subject)))

(define download-location
  (build-path (find-system-path 'home-dir) "Pictures" "iloveck101" thread-id-with-subject))

(define image-urls
  (filter
   (lambda (a-url)
     (url-path-absolute? a-url))
   (map string->url ((sxpath "//img/@file/text()") doc))))

(define download-image
  (lambda (a-url)
    (let ([filename (path/param-path (last (url-path a-url)))])
      (and verbose-mode (printf "Downloading ~a...~n" (url->string a-url)))
      (call-with-output-file*
       (build-path download-location filename)
       (lambda (out)
         (copy-port (get-pure-port a-url) out))
       #:exists 'replace))))


(make-directory* download-location)

(for-each download-image image-urls)
