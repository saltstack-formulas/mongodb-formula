# This setup for mongodb assumes that the replica set can be determined from
# the id of the minion
# NOTE: Currently this will not work behind a NAT in AWS VPC.
# see http://lodge.glasgownet.com/2012/07/11/apt-key-from-behind-a-firewall/comment-page-1/ for details
{% from "mongodb/map.jinja" import mdb with context %}

mongodb_package:
{% if mdb.use_ppa or mdb.use_repo %}
  {% set os = salt['grains.get']('os')|lower %}
  {% set code = salt['grains.get']('oscodename') %}
  pkgrepo.managed:
    - humanname: MongoDB.org Repo
    - name: deb http://repo.mongodb.org/apt/{{ os }} {{ code }}/mongodb-org/stable {{ mdb.repo_component }}
    - file: /etc/apt/sources.list.d/mongodb.list
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com
{% endif %}
  pkg.installed:
     - name: {{ mdb.mongodb_package }}

mongodb_db_path:
  file.directory:
    - name: {{ mdb.db_path }}
    - user: mongodb
    - group: mongodb
    - mode: 755
    - makedirs: True
    - recurse:
        - user
        - group

mongodb_log_path:
  file.directory:
    - name: {{ mdb.log_path }}
    - user: mongodb
    - group: mongodb
    - mode: 755
    - makedirs: True

mongodb_service:
  service.running:
    - name: {{ mdb.mongod }}
    - enable: True
    - watch:
      - file: mongodb_configuration

mongodb_configuration:
  file.managed:
    - name: {{ mdb.conf_path }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://mongodb/files/mongodb.conf.jinja
    - template: jinja
