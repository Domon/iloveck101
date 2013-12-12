#lang racket

(require net/url
         (planet neil/html-parsing:2:0)
         (planet lizorkin/sxml:2:1/sxml))

(define doc
  (call/input-url
    (string->url "http://ck101.com/thread-2826444-1-1.html")
    (lambda (url headers)
      (get-pure-port url #:redirections 5))
    (lambda (in)
      (html->xexp in))
    (list "User-Agent: Mozilla/5.0")))

(define urls
  ((sxpath "//img/@file/text()") doc))

(for-each
  (lambda (a-url)
    (copy-port
      (get-pure-port a-url)
      (open-output-file
        (path/param-path (last (url-path a-url)))
        #:exists 'replace)))
  urls)
