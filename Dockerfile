FROM debian:buster

# Add the dependencies your app needs here after patch.
RUN apt-get update && apt-get install -y openssh-server locales patch \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir /var/run/sshd

ADD ["./files", "/srv/sshapp/"]

RUN passwd -d root \
 && usermod --shell /usr/sbin/nologin root \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
 && patch /etc/ssh/sshd_config /srv/sshapp/sshd_config.patch \
 && patch /etc/pam.d/sshd /srv/sshapp/sshd.patch \
 && chmod 555 /srv/sshapp/run.sh

# If you want multiple users, running multiple apps, add them here (the -p sKzEqcFhB5Zfo sets the password to "admin")
RUN useradd -m -p sKzEqcFhB5Zfo -s /srv/sshapp/run.sh play


# Overwrite ssh host keys if provided
ADD ["./ssh", "/etc/ssh"]

RUN chmod 600 /etc/ssh/*_key && chmod 644 /etc/ssh/*.pub

# Force UTF-8
ENV LANG en_US.utf8

# If your app needs additional setup uncomment the following line, and you can put your commands after RUN (will run only at build)
# RUN echo "Your command here!"

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]