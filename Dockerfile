FROM alpine:3.12
ENV LANG C.UTF-8
RUN apk add dos2unix --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted \
    && apk add --update --no-cache openssh bash sshpass wget openssl unzip \
    && apk add --no-cache --update build-base python3 py3-pip python3-dev libffi-dev rust cargo openssl-dev
RUN pip3 install ansible
RUN apk add --no-cache --update curl jq \
    && PACKER_LATEST_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r -M '.current_version') \
    && curl https://releases.hashicorp.com/packer/${PACKER_LATEST_VERSION}/packer_${PACKER_LATEST_VERSION}_linux_amd64.zip --output /tmp/packer_linux_amd64.zip \
    && unzip /tmp/packer_linux_amd64.zip -d /usr/local/bin/ && ln -s /usr/local/packer/pkg/packer_linux_amd64 /usr/sbin/packer \
    && rm -f /tmp/packer_linux_amd64.zip
RUN echo -e '[defaults]\nansible_managed = ANSIBLE MANAGED : DO NOT EDIT !!!\nhost_key_checking = False\ntransport = ssh\n' >> /root/.ansible.cfg
RUN adduser vmuser -s /bin/sh --disabled-password

WORKDIR /project
ADD . .
RUN find . -type f -name "*.sh" -print0 | xargs -0 dos2unix --
RUN chown -R vmuser:vmuser /project
USER vmuser
RUN mkdir ~/.ssh && cp /project/keys/private-key.pem ~/.ssh/key && chmod 600 ~/.ssh/key
RUN mkdir -p ~/.config/gcloud && cp /project/keys/application_default_credentials.json ~/.config/gcloud

ENTRYPOINT /bin/sh