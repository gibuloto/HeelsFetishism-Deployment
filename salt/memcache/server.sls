memcache-server-packages:
  pkg.installed:
    - name: memcached

memcache-conf:
  file.managed:
    - template: jinja
    - name: /etc/memcached.conf
    - source: salt://memcache/memcached.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: memcache-server-packages

memcache-service:
  service.running:
    - name: memcached
    - enable: True
    - watch:
      - file: memcache-conf
