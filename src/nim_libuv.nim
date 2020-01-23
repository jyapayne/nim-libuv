import nim_libuv/wrapper

proc thread_callback(p: pointer) {.cdecl.} =
  echo "hello thread"

proc main() =
  var thread: thread_t

  let ret = thread_create(thread.addr, thread_callback, nil)
  assert ret == 0

  discard thread_join(thread.addr)

main()