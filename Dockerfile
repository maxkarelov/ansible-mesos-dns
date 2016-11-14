FROM ubuntu:trusty

ENV WORKDIR /tmp/build
ENV ROLEDIR /etc/ansible/roles/ansible-mesos-dns

RUN apt-get update && apt-get install -y software-properties-common
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -o Dpkg::Options::="--force-confnew" -y ansible

ADD files     $ROLEDIR/files
ADD defaults  $ROLEDIR/defaults
ADD handlers  $ROLEDIR/handlers
ADD meta      $ROLEDIR/meta
ADD tasks     $ROLEDIR/tasks
ADD templates $ROLEDIR/templates
ADD tests     $ROLEDIR/tests
ADD vars      $ROLEDIR/vars

ADD tests/inventory     /etc/ansible/hosts
ADD tests/playbook.yml  $WORKDIR/playbook.yml

RUN ansible-playbook $WORKDIR/playbook.yml -c local

CMD service mesos-dns start
