include:
  - django
  - postgresql.server

project-syncdb:
  cmd.wait:
    - name: "{{ pillar['project']['virtualenv_path'] }}/bin/python manage.py syncdb --noinput"
    - cwd: {{ pillar['project']['path'] }}
    - user: {{ pillar['system']['user'] }}
    - require:
      - virtualenv: project-virtualenv
      - postgres_database: postgresql-db
    - watch:
      - git: project-repo

project-migrate:
  cmd.wait:
    - name: "{{ pillar['project']['virtualenv_path'] }}/bin/python manage.py migrate"
    - cwd: {{ pillar['project']['path'] }}
    - user: {{ pillar['system']['user'] }}
    - require:
      - cmd: project-syncdb
    - watch:
      - git: project-repo
