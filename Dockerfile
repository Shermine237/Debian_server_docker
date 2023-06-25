FROM debian:11-slim

LABEL version='1.0.1' arch='x86-64'
# Variable
ARG NAME=user
ARG PASSWORD=user
ENV USER_NAME=$NAME
ENV USER_PASSWORD=$PASSWORD
# Copy entrypoint.sh to root folder (/)
COPY ./entrypoint.sh /
# Copy pip requirements.txt
COPY ./requirements.txt /
# Give exec permission
RUN chmod +x /entrypoint.sh
# Create user
RUN useradd $USER_NAME && echo $USER_NAME:$USER_PASSWORD | chpasswd;\
    apt-get update && apt-get install -y doas && echo "permit $USER_NAME as root" > /etc/doas.conf;\
# Install requiered packages
    apt-get install -y python3.9 python3-pip libldap2-dev libpq-dev libsasl2-dev nodejs npm;\
# Install wkhtmltopdf
    apt-get install -y xfonts-75dpi xfonts-base;\
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb;\
    dpkg -i wkhtmltox_0.12.5-1.stretch_amd64.deb;\
    cp /usr/local/bin/wkhtmltopdf /usr/bin/;\
    cp /usr/local/bin/wkhtmltoimage /usr/bin/;\
    rm -f wkhtmltox_0.12.5-1.stretch_amd64.deb;\
    rm -rf /var/lib/apt/lists/;\
# Install requirements.txt librairies with pip
    pip install -r /requirements.txt
# Set user
USER $USER_NAME
# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
# Open port
EXPOSE 8069
