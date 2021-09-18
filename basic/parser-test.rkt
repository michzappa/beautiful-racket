#lang br
(require basic/parser basic/tokenizer brag/support)

(define str #<<HERE
30 rem print 'ignored'
35
50 print "never gets here"
40 end
60 print 'three' : print 1.0 + 3
70 goto 11. + 18.5 + .5 rem ignored
10 print "o" ; "n" ; "e"
20 print : goto 60.0 : end
HERE
)

(parse-to-datum (apply-tokenizer make-tokenizer str))
