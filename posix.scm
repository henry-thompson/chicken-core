;;;; posix.scm - Platform-specific routines
;
; Copyright (c) 2008-2018, The CHICKEN Team
; Copyright (c) 2000-2007, Felix L. Winkelmann
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are
; met:
;
;   Redistributions of source code must retain the above copyright
;   notice, this list of conditions and the following disclaimer.
;
;   Redistributions in binary form must reproduce the above copyright
;   notice, this list of conditions and the following disclaimer in the
;   documentation and/or other materials provided with the distribution.
;
;   Neither the name of the author nor the names of its contributors may
;   be used to endorse or promote products derived from this software
;   without specific prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
; A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
; HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
; BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
; OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
; TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
; USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.


(declare
  (unit posix)
  (uses scheduler pathname extras port lolevel)
  (disable-interrupts)
  (not inline ##sys#interrupt-hook ##sys#user-interrupt-hook))

(module chicken.posix
  (block-device? call-with-input-pipe call-with-output-pipe
   change-directory* character-device? close-input-pipe
   close-output-pipe create-fifo create-pipe
   create-session create-symbolic-link
   current-effective-group-id current-effective-user-id
   current-effective-user-name current-group-id current-process-id
   current-user-id current-user-name
   directory? duplicate-fileno fcntl/dupfd fcntl/getfd
   fcntl/getfl fcntl/setfd fcntl/setfl fifo? file-access-time
   file-change-time file-close file-control file-creation-mode
   file-group file-link file-lock
   file-lock/blocking file-mkstemp file-modification-time file-open
   file-owner file-permissions file-position file-read
   file-select file-size file-stat file-test-lock file-truncate
   file-type file-unlock file-write fileno/stderr
   fileno/stdin fileno/stdout
   local-time->seconds local-timezone-abbreviation
   open-input-file* open-input-pipe open-output-file* open-output-pipe
   open/append open/binary open/creat open/excl open/fsync open/noctty
   open/noinherit open/nonblock open/rdonly open/rdwr open/read
   open/sync open/text open/trunc open/write open/wronly
   parent-process-id perm/irgrp perm/iroth perm/irusr perm/irwxg
   perm/irwxo perm/irwxu perm/isgid perm/isuid perm/isvtx perm/iwgrp
   perm/iwoth perm/iwusr perm/ixgrp perm/ixoth perm/ixusr pipe/buf
   port->fileno process process* process-execute process-fork
   process-group-id process-run process-signal process-sleep
   process-spawn process-wait read-symbolic-link regular-file?
   seconds->local-time seconds->string seconds->utc-time seek/cur
   seek/end seek/set
   set-alarm! set-file-group! set-file-owner!
   set-file-permissions! set-file-position! set-file-times!
   set-root-directory! set-signal-handler! set-signal-mask!
   signal-handler signal-mask signal-mask! signal-masked? signal-unmask!
   signal/abrt signal/alrm signal/break signal/bus signal/chld
   signal/cont signal/fpe signal/hup signal/ill signal/int signal/io
   signal/kill signal/pipe signal/prof signal/quit signal/segv
   signal/stop signal/term signal/trap signal/tstp signal/urg
   signal/usr1 signal/usr2 signal/vtalrm signal/winch signal/xcpu
   signal/xfsz signals-list socket? spawn/detach spawn/nowait
   spawn/nowaito spawn/overlay spawn/wait string->time symbolic-link?
   time->string user-information
   utc-time->seconds with-input-from-pipe with-output-to-pipe)

(import scheme
	chicken.base
	chicken.bitwise
	chicken.condition
	chicken.fixnum
	chicken.foreign
	chicken.memory
	chicken.pathname
	chicken.port
	chicken.process-context
	chicken.time)

(cond-expand
  (platform-unix
   (include "posixunix.scm"))
  (platform-windows
   (include "posixwin.scm"))))

(module chicken.errno *
(import scheme)
(define (errno) (##sys#errno))
(define errno/2big _e2big)
(define errno/acces _eacces)
(define errno/again _eagain)
(define errno/badf _ebadf)
(define errno/busy _ebusy)
(define errno/child _echild)
(define errno/deadlk _edeadlk)
(define errno/dom _edom)
(define errno/exist _eexist)
(define errno/fault _efault)
(define errno/fbig _efbig)
(define errno/ilseq _eilseq)
(define errno/intr _eintr)
(define errno/inval _einval)
(define errno/io _eio)
(define errno/isdir _eisdir)
(define errno/mfile _emfile)
(define errno/mlink _emlink)
(define errno/nametoolong _enametoolong)
(define errno/nfile _enfile)
(define errno/nodev _enodev)
(define errno/noent _enoent)
(define errno/noexec _enoexec)
(define errno/nolck _enolck)
(define errno/nomem _enomem)
(define errno/nospc _enospc)
(define errno/nosys _enosys)
(define errno/notdir _enotdir)
(define errno/notempty _enotempty)
(define errno/notty _enotty)
(define errno/nxio _enxio)
(define errno/perm _eperm)
(define errno/pipe _epipe)
(define errno/range _erange)
(define errno/rofs _erofs)
(define errno/spipe _espipe)
(define errno/srch _esrch)
(define errno/wouldblock _ewouldblock)
(define errno/xdev _exdev))

(module chicken.file.posix
  (create-fifo create-symbolic-link read-symbolic-link
   duplicate-fileno fcntl/dupfd fcntl/getfd fcntl/getfl fcntl/setfd
   fcntl/setfl file-access-time file-change-time file-modification-time
   file-close file-control file-creation-mode file-group file-link
   file-lock file-lock/blocking file-mkstemp file-open file-owner
   file-permissions file-position file-read file-select file-size
   file-stat file-test-lock file-truncate file-unlock file-write
   file-type block-device? character-device? directory? fifo?
   regular-file? socket? symbolic-link?
   fileno/stderr fileno/stdin fileno/stdout
   open-input-file* open-output-file*
   open/append open/binary open/creat open/excl open/fsync open/noctty
   open/noinherit open/nonblock open/rdonly open/rdwr open/read
   open/sync open/text open/trunc open/write open/wronly
   perm/irgrp perm/iroth perm/irusr perm/irwxg perm/irwxo perm/irwxu
   perm/isgid perm/isuid perm/isvtx perm/iwgrp perm/iwoth perm/iwusr
   perm/ixgrp perm/ixoth perm/ixusr
   port->fileno seek/cur seek/end seek/set set-file-group! set-file-owner!
   set-file-permissions! set-file-position! set-file-times!)
(import chicken.posix))

(module chicken.time.posix
  (seconds->utc-time utc-time->seconds seconds->local-time
   seconds->string local-time->seconds string->time time->string
   local-timezone-abbreviation)
(import chicken.posix))

(module chicken.process
  (qs system system* process-execute process-fork process-run
   process-signal process-spawn process-wait call-with-input-pipe
   call-with-output-pipe close-input-pipe close-output-pipe create-pipe
   open-input-pipe open-output-pipe with-input-from-pipe
   with-output-to-pipe process process* process-sleep pipe/buf
   spawn/overlay spawn/wait spawn/nowait spawn/nowaito spawn/detach)

(import scheme chicken.base chicken.fixnum chicken.posix chicken.platform)


;;; Execute a shell command:

(define (system cmd)
  (##sys#check-string cmd 'system)
  (let ((r (##core#inline "C_execute_shell_command" cmd)))
    (cond ((fx< r 0)
	   (##sys#update-errno)
	   (##sys#signal-hook #:process-error 'system "`system' invocation failed" cmd))
	  (else r))))

;;; Like `system', but bombs on nonzero return code:

(define (system* str)
  (let ((n (system str)))
    (unless (zero? n)
      (##sys#error "shell invocation failed with non-zero return status" str n))))


;;; Quote string for shell:

(define (qs str #!optional (platform (software-version)))
  (let* ((delim (if (eq? platform 'mingw32) #\" #\'))
	 (escaped (if (eq? platform 'mingw32) "\"\"" "'\\''"))
	 (escaped-parts
	  (map (lambda (c)
		 (cond
		   ((char=? c delim) escaped)
		   ((char=? c #\nul)
		    (error 'qs "NUL character can not be represented in shell string" str))
		   (else (string c))))
	       (string->list str))))
    (string-append
     (string delim)
     (apply string-append escaped-parts)
     (string delim)))))

(module chicken.process.signal
  (set-signal-handler! set-signal-mask! signal-handler signal-mask
   signal-mask! signal-masked? signal-unmask! signal/abrt signal/alrm
   signal/break signal/bus signal/chld signal/cont signal/fpe signal/hup
   signal/ill signal/int signal/io signal/kill signal/pipe signal/prof
   signal/quit signal/segv signal/stop signal/term signal/trap
   signal/tstp signal/urg signal/usr1 signal/usr2 signal/vtalrm
   signal/winch signal/xcpu signal/xfsz set-alarm!)
(import chicken.posix))

(module chicken.process-context.posix
  (change-directory* set-root-directory!
   current-effective-group-id current-effective-user-id
   current-group-id current-process-id current-user-id
   parent-process-id current-user-name
   current-effective-user-name create-session
   process-group-id user-information)
(import chicken.posix))
