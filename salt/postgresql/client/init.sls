include:
  - common

postgresql-client-packages:
  pkg.installed:
    - names:
      - postgresql-client-9.1
      - postgresql-contrib-9.1
      - libpq-dev
    - require:
      - pkg: general-packages