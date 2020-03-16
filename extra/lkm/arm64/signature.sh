#!/bin/sh
FILENAME=$1
if [ ! -n "${FILENAME}" ]; then
    echo "[-]Usage: ./signature.sh modelFileName"
    exit
fi
WORKSPACE=/home/chj/chj/m01OS/LINUX/android/device/chehejia/M01_AE
MODULE_SIGN_FILE=${WORKSPACE}/sign-file.dat
MODSECKEY=${WORKSPACE}/userdebug/sv/signing_key.pem
MODPUBKEY=${WORKSPACE}/userdebug/sv/signing_key.x509
${MODULE_SIGN_FILE} sha512 ${MODSECKEY} ${MODPUBKEY} ${FILENAME}.ko ${FILENAME}.sign.userdebug.ko
ls -la ${FILENAME}.sign.userdebug.ko
# echo "you can do this cmdline, on your local pc envirment: scp chj@192.168.85.44:/home/chj/chj/m01OS/LINUX/android/device/chehejia/M01_AE/sample/${FILENAME}.sign.userdebug.ko ."