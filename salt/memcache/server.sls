include:
  - common

memcache-server-packages:
  pkg.installed:
    - name: memcached
    - require:
      - pkg: general-packages

memcached:
  service.running:
    - enable: True
    - require:
      - pkg: memcache-server-packages
      - file: /etc/memcached.conf
    - watch:
      - file: /etc/memcached.conf

/etc/memcached.conf:
  file.managed:
    - source: salt://memcache/memcached.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: memcache-server-packages
