s_no_extra_traits! {
    #[allow(missing_debug_implementations)]
    #[repr(align(16))]
    pub struct max_align_t {
        priv_: [f64; 4]
    }

    #[allow(missing_debug_implementations)]
    #[repr(C)]
    pub union __loongarch_mc_fp_state {
        pub __val32: [::c_uint; 8],
        pub __val64: [::c_ulonglong; 4],
    }
}

cfg_if! {
    if #[cfg(feature = "extra_traits")] {
        impl PartialEq for __loongarch_mc_fp_state {
            fn eq(&self, other: &__loongarch_mc_fp_state) -> bool {
                unsafe { self.__val32 == other.__val32
                             || self.__val64 == other.__val64 }
            }
        }

        impl Eq for __loongarch_mc_fp_state {}

        impl ::fmt::Debug for __loongarch_mc_fp_state {
            fn fmt(&self, f: &mut ::fmt::Formatter) -> ::fmt::Result {
                unsafe { f.debug_struct("__loongarch_mc_fp_state")
                             .field("__val32", &self.__val32)
                             .field("__val64", &self.__val64)
                             .finish() }
            }
        }

        impl ::hash::Hash for __loongarch_mc_fp_state {
            fn hash<H: ::hash::Hasher>(&self, state: &mut H) {
                unsafe { self.__val32.hash(state);
                         self.__val64.hash(state); }
            }
        }
    }
}

s! {
    pub struct ucontext_t {
        pub uc_flags: ::c_ulong,
        pub uc_link: *mut ucontext_t,
        pub uc_stack: ::stack_t,
        pub uc_mcontext: mcontext_t,
        pub uc_sigmask: ::sigset_t,
    }

    #[repr(align(32))]
    pub struct mcontext_t {
        pub __pc: ::c_ulonglong,
        pub __gregs: [::c_ulonglong; 32],
        pub __flags: ::c_uint,
        pub __fcsr: ::c_uint,
        pub __vcsr: ::c_uint,
        pub __fcc: ::c_ulonglong,
        pub __fpregs: [__loongarch_mc_fp_state; 32],
        pub __reserved: ::c_uint,
    }

    #[repr(align(8))]
    pub struct clone_args {
        pub flags: ::c_ulonglong,
        pub pidfd: ::c_ulonglong,
        pub child_tid: ::c_ulonglong,
        pub parent_tid: ::c_ulonglong,
        pub exit_signal: ::c_ulonglong,
        pub stack: ::c_ulonglong,
        pub stack_size: ::c_ulonglong,
        pub tls: ::c_ulonglong,
        pub set_tid: ::c_ulonglong,
        pub set_tid_size: ::c_ulonglong,
        pub cgroup: ::c_ulonglong,
    }
}
