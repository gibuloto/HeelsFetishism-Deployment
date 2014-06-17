include:
  - common.build

postgresql-client-packages:
  pkg.installed:
    - names:
      - postgresql-client
      - postgresql-contrib
      - libpq-dev
    - require:
      - pkg: build-packages
