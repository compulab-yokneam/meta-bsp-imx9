# The deployed static SPDX document can be removed while its completion stamp
# survives. Restore or recreate it on normal builds so do_create_spdx never
# relies on an orphaned stamp. Kernel compile/install tasks remain cacheable.

do_create_recipe_spdx[nostamp] = "1"
do_create_recipe_spdx_setscene[nostamp] = "1"
