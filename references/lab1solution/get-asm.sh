#!/bin/bash

SFile=/tmp/get.sh
RFile=/tmp/gdb_result.txt
STime=50000
#D=`date`
#RFile=/tmp/gdb_result_$D.txt


function create_get_script {
	if [ -e $SFile ]; then
		rm -f $SFile
	fi

	touch $SFile
	chmod u+x $SFile

	echo '#!/bin/bash' > $SFile
	echo 'eax='"'"'$eax'"'" >> $SFile
	echo 'ecx='"'"'$ecx'"'" >> $SFile
	echo 'edx='"'"'$edx'"'" >> $SFile
	echo 'ebx='"'"'$ebx'"'" >> $SFile
	echo 'esp='"'"'$esp'"'" >> $SFile
	echo 'ebp='"'"'$ebp'"'" >> $SFile
	echo 'esi='"'"'$esi'"'" >> $SFile
	echo 'edi='"'"'$edi'"'" >> $SFile
	echo 'eip='"'"'$eip'"'" >> $SFile
	echo 'cs='"'"'$cs'"'" >> $SFile
	echo 'ss='"'"'$ss'"'" >> $SFile
	echo 'ds='"'"'$ds'"'" >> $SFile
	echo 'es='"'"'$es'"'" >> $SFile
	echo 'fs='"'"'$fs'"'" >> $SFile
	echo 'gs='"'"'$gs'"'" >> $SFile
	echo 'gdb << END_OF_GDB' >> $SFile
	echo 'b *0x7c00' >> $SFile
	echo 'c' >> $SFile
	echo 'display/x $eax' >> $SFile
	echo 'display/x $ecx' >> $SFile
	echo 'display/x $edx' >> $SFile
	echo 'display/x $ebx' >> $SFile
	echo 'display/x $esp' >> $SFile
	echo 'display/x $ebp' >> $SFile
	echo 'display/x $esi' >> $SFile
	echo 'display/x $edi' >> $SFile
	echo 'display/x $eip' >> $SFile
	echo 'display/x $cs' >> $SFile
	echo 'display/x $ss' >> $SFile
	echo 'display/x $ds' >> $SFile
	echo 'display/x $es' >> $SFile
	echo 'display/x $fs' >> $SFile
	echo 'display/x $gs' >> $SFile
	i=1
	while [ $i -lt $STime ]; do
		echo 'si' >> $SFile
		let i=i+1
	done
	echo 'END_OF_GDB' >> $SFile
}

##### main #####

create_get_script

if [ -e $RFile ];then
	rm -f $RFile
fi

touch $RFile
$SFile > $RFile
