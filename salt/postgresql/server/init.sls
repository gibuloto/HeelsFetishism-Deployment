include:
  - common
  - python.boto
  - postgresql.client

postgresql-server-packages:
  pkg.installed:
    - names:
      - postgresql-9.1
      - postgresql-contrib-9.1
      - libpq-dev
    - require:
      - pkg: general-packages

postgresql:
  service.running:
    - enable: True
    - watch:
      - file: postgresql-conf
      - file: postgresql-hba

postgresql-user:
  postgres_user.present:
    - name: {{ pillar['postgresql']['user'] }}
    - password: {{ pillar['postgresql']['password'] }}
    - runas: postgres
    - require:
      - service: postgresql
      - file: postgresql-conf
      - file: postgresql-hba

postgresql-db:
  postgres_database.present:
    - name: {{ pillar['postgresql']['db'] }}
    - encoding: UTF8
    - lc_collate: en_US.UTF-8
    - lc_ctype: en_US.UTF-8
    - owner: {{ pillar['postgresql']['user'] }}
    - template: template0
    - runas: postgres
    - require:
      - service: postgresql
      - postgres_user: postgresql-user
      - file: postgresql-conf
      - file: postgresql-hba

postgresql-conf:
  file.managed:
    - template: jinja
    - name: /etc/postgresql/9.1/main/postgresql.conf
    - source: salt://postgresql/server/config/postgresql.conf
    - user: postgres
    - group: postgres
    - require:
      - pkg: postgresql-server-packages

postgresql-hba:
  file.managed:
    - template: jinja
    - name: /etc/postgresql/9.1/main/pg_hba.conf
    - source: salt://postgresql/server/config/pg_hba.conf
    - user: postgres
    - group: postgres
    - require:
      - pkg: postgresql-server-packages

file-backup_postgresql:
  file.managed:
    - template: jinja
    - name: {{ pillar['system']['home_path'] }}/backup_postgresql.py
    - source: salt://postgresql/server/scripts/backup_postgresql.py
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - mode: 0777
    - recurse:
      - user
      - group
    - require:
      - user: create-user

crontab-backup_postgresql:
  cron.present:
    - name: "python {{ pillar['system']['home_path'] }}/backup_postgresql.py"
    - user: postgres
    - minute: "26"
    - hour: "9"
    - require:
      - file: file-backup_postgresql
