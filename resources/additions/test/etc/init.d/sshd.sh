#!/bin/sh
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin/:/usr/local/sbin/

SSHD_DSA=/etc/ssh_host_dsa_key
SSHD_RSA=/etc/ssh_host_rsa_key
SSHD_KEY=/etc/ssh_host_key

SSHD=/usr/local/sbin/sshd
if [ ! -x ${SSHD} ] ; then
	echo "sshd is not supported on this platform!!!"
fi

[ -f /etc/nas_feature ] && . /etc/nas_feature

#if [ "${SUPPORT_SFTP}" = "0" ] ; then
#        echo "Not support sftp on this model." > /dev/console
#        exit 0
#fi

umask 000

sshd_keygen()
{
	if [ ! -f ${SSHD_KEY} ] ; then
		echo "1st time bootup?"
		echo "key file(${SSHD_KEY}) is not exist!!!"
		echo "Create key file, please wait for a while"
		echo y|ssh-keygen -t dsa -f ${SSHD_KEY} -N ""
		if [ $? -ne 0 ] ; then
			echo "file(${SSHD_KEY}) is created successfully."
		else
			echo "file(${SSHD_KEY}) is created failed!"
		fi
	fi
	if [ ! -f ${SSHD_DSA} ] ; then
		echo "1st time bootup?"
		echo "key file(${SSHD_DSA}) is not exist!!!"
		echo "Create key file, please wait for a while"
		echo y|ssh-keygen -t dsa -f ${SSHD_DSA} -N ""
		if [ $? -ne 0 ] ; then
			echo "file(${SSHD_DSA}) is created successfully."
		else
			echo "file(${SSHD_DSA}) is created failed!"
		fi
	fi 
	if [ ! -f ${SSHD_RSA} ] ; then
		echo "1st time bootup?"
		echo "key file(${SSHD_RSA}) is not exist!!!"
		echo "Create key file, please wait for a while"
		echo y|ssh-keygen -t rsa -f ${SSHD_RSA} -N ""
		if [ $? -ne 0 ] ; then
			echo "file(${SSHD_RSA}) is created successfully."
		else
			echo "file(${SSHD_RSA}) is created failed!"
		fi

	fi
}

sshd_start()
{
	sshd_keygen
	nas_configgen -c sftp
	sshdauth="`sed -n '/^sshdauth=/ s/sshdauth=//p' /etc/melco/info`"

	if [ "x$sshdauth" == "xon" ]; then
		${SSHD} -f /etc/sshd_config_2222	
	fi
	if [ "${SUPPORT_REPLICATION}" = "1" ] ; then
		local is_rep_task=1
		if [ -f /usr/local/lib/libreplication ] ; then
			. /usr/local/lib/libreplication
			IsReplicationTask
			is_rep_task=$?
		fi
		if [ ${is_rep_task} -eq 0 ] ; then
			${SSHD}
		else
			LD_PRELOAD=/usr/local/lib/libondemandsync.so ${SSHD}
		fi
	else
		${SSHD}
	fi
}

sshd_stop()
{
	killall sshd
}


case $1 in
start)
	sshd_start
	;;
stop)
	sshd_stop
	;;
restart)
	sshd_stop
	sleep 1
	sshd_start
	;;
*)
	echo "Unknown argument"
	;;
esac

exit 0
