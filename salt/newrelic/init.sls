# install instructions at https://newrelic.com/docs/server/server-monitor-installation-ubuntu-and-debian

include:
  - common

base:
  pkgrepo.managed:
    - humanname: Newrelic PPA
    - name: deb http://apt.newrelic.com/debian/ newrelic non-free
    - file: /etc/apt/sources.list.d/newrelic.list
    - keyid: 548C16BF
    - keyserver: subkeys.pgp.net
    - require:
      - pkg: terminal-packages
    - require_in:
      - pkg: newrelic-packages

newrelic-packages:
  pkg.installed:
    - names:
       - newrelic-sysmond
    - refresh: True
    - skip_verify: True

newrelic-license-key:
  cmd.wait:
    - name: nrsysmond-config --set license_key={{ pillar['newrelic']['license_key'] }}
    - unless: "grep "license_key={{ pillar['newrelic']['license_key'] }}" /etc/newrelic/nrsysmond.cfg"
    - watch:
      - pkg: newrelic-packages

newrelic-service:
  service.running:
    - name: newrelic-sysmond
    - enable: True
    - watch:
      - pkg: newrelic-packages
      - cmd: newrelic-license-key
