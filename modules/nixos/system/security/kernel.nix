{ config, lib, ... }:
let
  inherit (builtins) mapAttrs concatLists;
  inherit (lib.modules) mkForce;
  inherit (lib.lists) optionals;

  sys = config.self.system;
in
{
  boot = {
    # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
    # https://github.com/sotormd/nixos/blob/master/doc/security.md#kernel-parameters
    kernelParams = [
      # disables merging of slabs of similar sizes
      # sometimes, vulnerable slabs may be merged with safe ones
      # slight increase in kernel memory utilization
      "slab_nomerge"

      # enable zeroing of memory during allocation and free time
      # mitigate use-after-free vulnerabilities and erase sensitive data
      # also enables poisoning for some freed memory
      # little performance cost
      "init_on_alloc=1"
      "init_on_free=1"

      # randomises page allocator freelists
      # makes page allocations less predictable
      # slightly improves performance
      "page_alloc.shuffle=1"

      # enable kernel page table isolation
      # mitigates meltdown and prevents some KASLR bypasses
      "pti=on"

      # randomize kernel stack offset on each syscall
      # mitigates attacks reliant on deterministic kernel stack layouts
      "randomize_kstack_offset=on"

      # disable obsolete vsyscalls
      # replaced by vDSO calls
      # this breaks really old binaries
      "vsyscall=none"

      # disable debugfs
      # debugfs exposes sensitive kernel information
      "debugfs=off"

      # some kernel exploits will cause an "oops"
      # this will cause the kernel to panic on such oopses, preventing the exploit
      # sometimes, bad drivers cause harmless oopses, resulting in system crashes
      "oops=panic"

      # only allows kernel modules that have been signed with a valid key to be loaded
      # makes it harder to load a malicious kernel module
      # virtualbox, nvidia modules may need manual signing
      #
      # MODULE_SIG is disabled in the kernel on NixOS
      # to ensure reproducibility, this does nothing
      "module.sig_enforce=1"

      # enable the kernel lockdown LSM
      # confidentiality is the strictest mode
      # protects both kernel integrity and prevents unauthorized access to kernel data
      # establishes clear security boundary between userspace and kernel
      # this implies module.sig_enforce=1
      #
      # LOCKDOWN_LSM is disabled in the kernel on NixOS
      # to ensure reproducibility, this does nothing
      "lockdown=confidentiality"

      # do not panic on uncorrectable memory errors
      # kernel will panic on uncorrectable memory errors, which can be exploited
      # mainly for systems with ECC memory
      # so this is unnecessary and can be disabled
      "mce=0"

      # mitigate spectre vulnerabilities
      "spectre_v2=on"
      "spec_store_bypass_disable=on"

      # do not trust the proprietary cpu RNG
      # this RNG can not be audited
      "random.trust_cpu=off"
      "random.trust_bootloader=off"

      # enable IOMMU
      # mitigates direct memory access attacks
      "intel_iommu=on"
      "amd_iommu=on"

      # fixes a hole in IOMMU
      # disables busmaster bit on all PCI bridges in early boot
      "efi=disable_early_pci_dma"

      # forces KVM to mark huge pages as non-executable
      # prevents code execution in certain memory regions
      # can increase memory usage, especially with KVM-based hypervisors
      "kvm.nx_huge_pages=force"

      # disable hyperthreading - for both amd and intel
      # also disable TSX and mitigate TAA - mostly for intel
      # also mitigate speculative execution vulnerabilities - mostly for intel
      # dramatic performance losses
      #"nosmt=force"
      #"tsx=off"
      #"tsx_async_abort=full,nosmt"
      #"l1tf=full,force"
      #"mds=full,nosmt"
    ];

    # https://www.kernel.org/doc/html/latest/admin-guide/sysctl/
    # https://github.com/sotormd/nixos/blob/master/doc/security.md#sysctl-options
    kernel.sysctl = mapAttrs (_name: value: mkForce value) {
      # prevent boot console kernel log information leaks
      "kernel.printk" = "3 3 3 3";

      # enable ASLR
      # randomises memory space for stack, heap, memory mappings and shared libraries
      "kernel.randomize_va_space" = 2;

      # disable magic SysRq key
      "kernel.sysrq" = 0;

      # restrict access to kernel pointers via /proc
      "kernel.kptr_restrict" = 2;

      # only allow access to kernel log messages for privileged users
      "kernel.dmesg_restrict" = 1;

      # disable unprivileged calls to berkeley packet filter
      "kernel.unprivileged_bpf_disabled" = 1;

      # disable ability to load a new kernel while system is running
      "kernel.kexec_load_disabled" = 1;

      # control use of performance events system by unprivileged users
      # >=2 disallows kernel profiling by unprivileged users
      # this maw break poop/hyprfine/perf
      "kernel.perf_event_paranoid" = 3;

      # limits cpu time that can be accounted for perf sampling events to 1%
      "kernel.perf_cpu_time_max_percent" = 1;

      # limits sample rate for performance events to 1
      "kernel.perf_event_max_sample_rate" = 1;

      # disable ptrace with yama LSM
      # this may break game launchers
      # "kernel.yama.ptrace_scope" = 3;

      # disable function tracing
      "kernel.ftrace_enabled" = 0;

      # disable io_uring
      # https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html
      # "kernel.io_uring_disabled" = 2;

      # prevent auto loading line disciplines for tty
      "dev.tty.ldisc_autoload" = 0;

      # disable core dumps for setuid programs
      "fs.suid_dumpable" = 0;

      # restricts creation of hard links to files owned by other users
      "fs.protected_hardlinks" = 1;

      # restricts creation of symlinks to files owned by other users
      "fs.protected_symlinks" = 1;

      # controls permissions for named pipes
      # only owner of the FIFO can write to it
      "fs.protected_fifos" = 2;

      # restrict access to regular files by non-root
      # users if the file is owned by another user
      "fs.protected_regular" = 2;

      # disable the berkely packet filter JIT
      "net.core.bpf_jit_enable" = 0;

      # enable JIT hardening techniques like constant blinding
      "net.core.bpf_jit_harden" = 2;

      # protect against SYN flood attacks
      "net.ipv4.tcp_syncookies" = 1;

      # protect against time-wait assassination by dropping RST packets
      "net.ipv4.tcp_rfc1337" = 1;

      # enables source validation of received packets from all interfaces
      # protect against IP spoofing
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;

      # disable ICMP redirect acceptance and sending
      # prevent MITM attacks
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;

      # ignore all ICMP requests
      # prevent smurf attacks and clock fingerprinting
      "net.ipv4.icmp_echo_ignore_all" = 1;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;

      # disable source routing
      # prevent MITM attacks
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_source_route" = 0;

      # disable TCP SACK
      # commonly exploited and mostly unnecessary
      "net.ipv4.tcp_sack" = 0;
      "net.ipv4.tcp_dsack" = 0;
      "net.ipv4.tcp_fack" = 0;

      # log martian packets
      "net.ipv4.conf.all.log_martians" = 1;
      "net.ipv4.conf.default.log_martians" = 1;

      # disable IPv6 router advertisements
      # prevent MITM attacks
      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.default.accept_ra" = 0;

      # generate a random IPv6 address every time
      # IPv6 addresses are tied to MAC address, making them unique for each device
      "net.ipv6.conf.all.use_tempaddr" = 2;
      "net.ipv6.conf.default.use_tempaddr" = 2;

      # tcp timestamps leak the system time
      # kernel attempts to mitigate this by adding random offsets
      # but that is not sufficient
      "net.ipv4.tcp_timestamps" = 0;

      # disable the often-abused userfaultfd() syscall
      "vm.unprivileged_userfaultfd" = 0;

      # increase bits of entropy used for mmap ASLR
      "vm.mmap_rnd_compat_bits" = 16;
      "vm.mmap_rnd_bits" = 32; # consider 33 for servers
    };

    # https://github.com/sotormd/nixos/blob/master/doc/security.md#module-blacklists
    blacklistedKernelModules = concatLists [
      # obscure network protocols
      [
        # datagram congestion control protocol
        # manages congestion without providing reliable data delivery
        # can blacklist unless using voice-over-IP
        #"dccp"

        # stream control transmission protocol
        # like tcp but with support for multiple streams
        # can blacklist unless involved in telecoms or signalling
        "sctp"

        # reliable datagram sockets
        # high performance clustered computing and inter-process communication
        # can blacklist unless running distributed systems
        "rds"

        # transparent inter-process communication
        # cluster-wide communication in systems like databases/clustered servers
        # can blacklist unless running clustered environments
        "tipc"

        # high-level data link control
        # serial communication and networking over physical links
        # can blacklist unless using specialized serial networking hardware
        "n-hdlc"

        # amateur radio X.25 protocol
        # amateur radio communication
        # can blacklist unless a radio operator
        "ax25"

        # network layer protocol used in AX.25
        "netrom"

        # X.25 protocol
        # packet-switched network protocol
        # can blacklist unless using legacy networking systems
        "x25"

        # amateur radio link layer
        # packet radio communication
        # can blacklist unless a radio operator
        "rose"

        # digital equipment corporation network
        # DEC network protocol for its proprietary systems
        # can blacklist unless using legacy DEC equipment
        "decnet"

        # Acorn Computers' networking protocol
        # proprietary network protocol developed by Acorn
        # can blacklist unless using legacy Acorn equipment
        "econet"

        # IEEE 802.15.4 protocol family
        # low-rate wireless personal area networks (LR-WPANs), mostly for IoT devices
        # can blacklist unless dealing with IoT
        "af_802154"

        # internetwork packet exchange
        # Novell protocol used in legacy networks
        # can blacklist unless using old Novell networks
        "ipx"

        # AppleTalk protocol
        # network protocol developed by Apple
        # can blacklist unless using legacy Mac systems
        "appletalk"

        # subnetwork access protocol
        # transmitting packets over different types of physical networks
        # can blacklist unless dealing with low-level networking
        "psnap"

        # IEEE 802.3 and 802.2
        # ethernet-based networking
        # standard for ethernet communication
        # can blacklist unless using ethernet (eg. only using wifi)
        "p8023"
        "p8022"

        # controller area network
        # communication in vehicles and industrial systems
        # can blacklist unless dealing with embedded/automotive systems
        "can"

        # asynchronous transfer mode
        # used in old telecommunications networks
        # can blacklist unless using legacy telecom equipment
        "atm"
      ]

      # rare filesystems
      # can blacklist if not using
      [
        "cramfs" # compressed ROM/RAM file system
        "freevxfs" # Veritas filesystem driver
        "jffs2" # Journalling Flash File System (v2)
        "hfs" # Hierarchical File System (Macintosh)
        "hfsplus" # same as above, but with extended attributes
        #"squashfs" # compressed read-only file system (used by live CDs)
        "udf" # https://docs.kernel.org/5.15/filesystems/udf.html
        #"overlay" # union mount filesystem, used in containerization
        "adfs" # Active Directory Federation Services
        "affs" # Amiga Fast File System
        "bfs" # BFS, used by SCO UnixWare OS for the /stand slice
        "befs" # "Be File System"
        "efs" # Extent File System
        "erofs" # Enhanced Read-Only File System
        "exofs" # EXtended Object File System
        "f2fs" # Flash-Friendly File System
        "hpfs" # High Performance File System (used by OS/2)
        "jfs" # Journaled File System - only useful for VMWare sessions
        "minix" # minix fs - used by the minix OS
        "nilfs2" # New Implementation of a Log-structured File System
        "omfs" # Optimized MPEG Filesystem
        "qnx4" # extent-based file system used by the QNX4 and QNX6 OSes
        "qnx6" # same as above
        "sysv" # implements all of Xenix FS, SystemV/386 FS and Coherent FS.
        "ufs" # Unix File System

        # network filesystems
        # can blacklist if not using
        "cifs" # Common Internet File System
        "nfs" # Network File System
        "nfsv3" # same as above (v3)
        "nfsv4" # same as above (v4)
        "sunrpc" # Sub Remote Procedure Call
        "lockd" # record-locking operations for NFS
        "ksmbd" # SMB3 Kernel Server
        "gfs2" # Global File System 2
      ]

      [
        # virtual video driver
        # can blacklist unless testing video drivers
        "vivid"
      ]

      [
        # IEEE 1394
        # high-speed interface for video cameras, external drives, etc
        # replaced by usb 3.0 and usb c
        # can blacklist unless using old firewire devices
        #"firewire-core"

        # intel thunderbolt
        # high-speed data and power transfer
        # can blacklist unless using thunderbolt
        #"thunderbolt"
      ]

      # bluetooth
      # can blacklist unless using bluetooth
      (optionals (!sys.bluetooth.enable) [
        "bluetooth"
        "btusb"
      ])

      [
        # usb video class devices
        # can blacklist unless using webcam
        #"uvcvideo"
      ]

      [
        # annoying PC speaker module
        # can blacklist unless deaf
        #"pcspkr"
      ]

      # dirtyfrag mitigation
      [
        # "esp4"
        # "esp6"
        # "rxrpc"
      ]
    ];
  };
}
