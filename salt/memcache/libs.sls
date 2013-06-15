include:
  - common

memcache-lib-packages:
  pkg.installed:
    - names:
      - libmemcached-dev
    - require:
      - pkg: general-packages
