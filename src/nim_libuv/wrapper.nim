import os

import nimterop/[cimport, build, paths]

const
  srcDir = currentSourcePath.parentDir().parentDir().parentDir()
  buildDir = srcDir/"build"/"libuv"

static:
  cDebug()
  cDisableCaching()
  
  gitPull("https://github.com/libuv/libuv", outdir = buildDir, plist = """
include/*
include/uv/*
src/*
src/win/*
src/unix/*
""", checkout = "v1.34.2")

const
    hunix = buildDir/"include/uv/unix.h" 
    huv {.used.} = "/Users/jyakimowich-payne/JoeyProjects/nim-libuv/build/libuv/include/uv.h"

cOverride:
    # Standard Nim code to wrap types, consts, procs, etc.
    type
        loop_s = object
        handle_s = object
        dir_s = object
        stream_s = object
        tcp_s = object
        udp_s = object
        pipe_s = object
        tty_s = object
        poll_s = object
        timer_s = object
        prepare_s = object
        check_s = object
        idle_s = object
        async_s = object
        process_s = object
        fs_event_s = object
        fs_poll_s = object
        signal_s = object

        req_s = object
        interface_address_s = object
        getaddrinfo_s = object
        getnameinfo_s = object
        shutdown_s = object
        write_s = object
        connect_s = object
        udp_send_s = object
        fs_s = object
        work_s = object

        addrinfo {.importc: "addrinfo"} = object
        sockaddr {.importc: "sockaddr"} = object

    type
        once_t* {.importc: "uv_once_t", header: hunix.} = object
        thread_t* {.importc: "uv_thread_t", header: hunix.} = object
        mutex_t* {.importc: "uv_mutex_t", header: hunix.} = object
        rwlock_t* {.importc: "uv_rwlock_t", header: hunix.} = object
        sem_t* {.importc: "uv_sem_t", header: hunix.} = object
        cond_t* {.importc: "uv_cond_t", header: hunix.} = object
        key_t* {.importc: "uv_key_t", header: hunix.} = object
        dirent_t* {.importc: "uv__dirent_t", header: hunix.} = object

        stdio_container_t* {.importc: "uv_stdio_container_t", header: huv.} = object
        req_type* {.importc: "uv_req_type", header: huv.} = object
        handle_type* {.importc: "uv_handle_type", header: huv.} = object

        sockaddr_in* {.importc: "sockaddr_in".} = object
        sockaddr_in6* {.importc: "sockaddr_in6".} = object


cIncludeDir(buildDir/"include")
cIncludeDir(buildDir/"src")
cIncludeDir(buildDir/"src/unix")

#cDefine("SYMBOL", "value")



{.passC: "-pthreads -D_DARWIN_USE_64_BIT_INODE=1 -D_DARWIN_UNLIMITED_SELECT=1".}
#{.passL: "flags".}


cCompile(buildDir/"src/fs-poll.c")
cCompile(buildDir/"src/idna.c")
cCompile(buildDir/"src/inet.c")
cCompile(buildDir/"src/random.c")
cCompile(buildDir/"src/strscpy.c")
cCompile(buildDir/"src/threadpool.c")
cCompile(buildDir/"src/uv-data-getter-setters.c")
cCompile(buildDir/"src/timer.c")
cCompile(buildDir/"src/uv-common.c")
cCompile(buildDir/"src/version.c")

cCompile(buildDir/"src/unix/async.c")
cCompile(buildDir/"src/unix/core.c")
cCompile(buildDir/"src/unix/dl.c")
cCompile(buildDir/"src/unix/fs.c")
cCompile(buildDir/"src/unix/getaddrinfo.c")
cCompile(buildDir/"src/unix/getnameinfo.c")
cCompile(buildDir/"src/unix/loop-watcher.c")
cCompile(buildDir/"src/unix/loop.c")
cCompile(buildDir/"src/unix/pipe.c")
cCompile(buildDir/"src/unix/poll.c")
cCompile(buildDir/"src/unix/process.c")
cCompile(buildDir/"src/unix/random-devurandom.c")
cCompile(buildDir/"src/unix/signal.c")
cCompile(buildDir/"src/unix/stream.c")
cCompile(buildDir/"src/unix/tcp.c")
cCompile(buildDir/"src/unix/thread.c")
cCompile(buildDir/"src/unix/tty.c")
cCompile(buildDir/"src/unix/udp.c")

cCompile(buildDir/"src/unix/bsd-ifaddrs.c")
cCompile(buildDir/"src/unix/darwin.c")
cCompile(buildDir/"src/unix/darwin-proctitle.c")
cCompile(buildDir/"src/unix/fsevents.c")
cCompile(buildDir/"src/unix/kqueue.c")
cCompile(buildDir/"src/unix/proctitle.c")
cCompile(buildDir/"src/unix/random-getentropy.c")

cPlugin:
  import strutils

  proc onSymbol*(sym: var Symbol) {.exportc, dynlib.} =
    sym.name = sym.name.strip(chars = {'_'})
    sym.name = sym.name.replace("uv__", "")

    sym.name = sym.name.replace("uv_", "")


cImport(buildDir/"include/uv.h", recurse = true)