#!/bin/bash

# Some tools requires an english envrionment
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"

CPU_JOB_NUM=$(grep processor /proc/cpuinfo | awk '{field=$NF};END{print field+1}')

svn up

make clean -j$CPU_JOB_NUM

mkdir -p output

function gen_all_kernel_image()
{
	function check_kernel_build_result() {
		if [ $? != 0 ];then 
			echo "$1 build error!!"
			exit -1
		fi
	}
	make meizu_defconfig
	make all -j$CPU_JOB_NUM
	check_kernel_build_result meizu_defconfig
	cp arch/arm/boot/zImage output/zImage-dev
	
	unset check_kernel_build_result
}

time gen_all_kernel_image

unset gen_all_kernel_image

