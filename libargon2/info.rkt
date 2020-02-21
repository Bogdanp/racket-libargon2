#lang info

(define version "20190702")
(define deps '("base"
               ("libargon2-i386-win32" #:platform #rx"win32.i386")
               ("libargon2-x86_64-linux" #:platform #rx"x86_64-linux")
               ("libargon2-x86_64-macosx" #:platform #rx"x86_64-macosx")
               ("libargon2-x86_64-win32" #:platform #rx"win32.x86_64")))
