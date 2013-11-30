include:
  - django
  - newrelic.python

newrelic-celery-config:
  file.managed:
    - template: jinja
    - name: {{ pillar['system']['home_path'] }}/newrelic_celery.ini
    - source: salt://celery/newrelic.ini
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}

celeryd-upstart-conf:
  file.managed:
    - template: jinja
    - name: /etc/init/celeryd.conf
    - source: salt://celery/celeryd.conf
    - require:
      - file: newrelic-celery-config
      - pip: newrelic-python-package

celeryd-service:
  service.running:
    - name: celeryd
    - enable: True
    - watch:
      - file: celeryd-upstart-conf
      - git: project-repo
    - order: last

celery-logrotate:
  file.managed:
    - template: jinja
    - name: /etc/logrotate.d/celery
    - source: salt://celery/celery_logrotate
