#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

static int __init idps_x64_init(void){
      printk(KERN_ALERT "idps_x64 driver init!\n");
      return 0;
}

static void __exit idps_x64_exit(void){
       printk(KERN_ALERT "idps_x64 driver exit\n");
}

module_init(idps_x64_init);
module_exit(idps_x64_exit);
MODULE_LICENSE("GPL");
