FROM ubuntu:14.10

# much of this was gleaned from https://github.com/lxc/lxc/blob/lxc-0.8.0/templates/lxc-ubuntu.in
# and then heavily modified and hacked like crazy

# we're going to want this bad boy installed so we can connect :)
RUN apt-get update && apt-get install -y ssh

ADD init-fake.conf /etc/init/fake-container-events.conf

# undo some leet hax of the base image
RUN rm /usr/sbin/policy-rc.d; \
	rm /sbin/initctl; dpkg-divert --rename --remove /sbin/initctl

# generate a nice UTF-8 locale for our use
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# remove some pointless services
RUN /usr/sbin/update-rc.d -f ondemand remove; \
	for f in \
		/etc/init/u*.conf \
		/etc/init/mounted-dev.conf \
		/etc/init/mounted-proc.conf \
		/etc/init/mounted-run.conf \
		/etc/init/mounted-tmp.conf \
		/etc/init/mounted-var.conf \
		/etc/init/hostname.conf \
		/etc/init/networking.conf \
		/etc/init/tty*.conf \
		/etc/init/plymouth*.conf \
		/etc/init/hwclock*.conf \
		/etc/init/module*.conf\
	; do \
		dpkg-divert --local --rename --add "$f"; \
	done; \
	echo '# /lib/init/fstab: cleared out for bare-bones Docker' > /lib/init/fstab

# small fix for SSH in 13.10 (that's harmless everywhere else)
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# let Upstart know it's in a container
ENV container docker

# set a cheap, simple password for great convenience
RUN echo 'root:besA4aBr' | chpasswd

######### Custom Setup ############

# Run Updates
RUN apt-get update
RUN apt-get -y upgrade

# Basic Requirements
RUN apt-get -y -f install memcached mysql-client nginx nginx-extras php5-fpm php5-mysql php-apc pwgen python-setuptools curl git unzip vim

# Wordpress Requirements
RUN apt-get -y -f install php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-memcached php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

# Set up wordpress user
RUN useradd -m -d /home/wp-user -p $(openssl passwd -1 'welcome1') -G sudo -s /bin/bash wp-user

# Set up nginx user
RUN useradd -b /usr/sbin/nologin nginx

# Copy configuration
ADD wpconfig.tar.gz /tmp/
ADD restore_config.sh /tmp/
RUN /tmp/restore_config.sh

# Set services to autostart
RUN update-rc.d nginx defaults && update-rc.d php5-fpm defaults && update-rc.d cron defaults

# Cleanup
RUN rm -rf /tmp/backup /tmp/restore_config.sh

########## END ############

# we can has SSH
EXPOSE 22
EXPOSE 80

# prepare for takeoff
CMD ["/sbin/init"]
