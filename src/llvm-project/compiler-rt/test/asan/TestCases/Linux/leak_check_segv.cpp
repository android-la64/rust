// Test that SIGSEGV during leak checking does not crash the process.
// RUN: %clangxx_asan -O1 %s -o %t && not %run %t 2>&1 | FileCheck %s
// REQUIRES: leak-detection
#include <sanitizer/lsan_interface.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

char data[10 * 1024 * 1024];

int main() {
  void *p = malloc(10 * 1024 * 1024);
  long pagesz_minus_one = sysconf(_SC_PAGESIZE) - 1;
  // surprise-surprise!
  mprotect((void *)(((unsigned long)p + pagesz_minus_one) & ~pagesz_minus_one), 16 * 1024, PROT_NONE);
  mprotect((void *)(((unsigned long)data + pagesz_minus_one) & ~pagesz_minus_one), 16 * 1024, PROT_NONE);
  __lsan_do_leak_check();
  fprintf(stderr, "DONE\n");
}

// CHECK: Tracer caught signal 11
// CHECK: LeakSanitizer has encountered a fatal error
// CHECK: HINT: For debugging, try setting {{.*}} LSAN_OPTIONS
// CHECK-NOT: DONE
