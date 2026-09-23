# Linux 6.18 i.MX93 real-time configuration

UCM-iMX93, MCM-iMX93 and IOT-LINK share the Linux 6.18.20 source tree.
ARM64 PREEMPT_RT is integrated in this kernel: the historical 6.6 RT patches
must not be applied to it.

IOT-LINK automatically applies `arch/arm64/configs/cl-imx93-rt.cfg` after
the common CompuLab additions, removals and i.MX93 pruning fragment.
Configuration fails if `CONFIG_PREEMPT_RT=y` is not retained. UCM and MCM
keep the normal preemption configuration by default.

The `cl-imx9` IOT-LINK image includes `rt-tests` (`cyclictest`). Verify the
running kernel with `uname -a` and `cat /sys/kernel/realtime` (expected `1`),
then measure latency under representative application and I/O load.
Enabling RT does not by itself guarantee application deadlines.

To opt other i.MX93 machines into RT, update `conf/local.conf`:

```
DISTRO_FEATURES:append = " linux-rt "
```
