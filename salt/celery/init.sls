include:
  - django

celeryd-upstart-conf:
  file.managed:
    - template: jinja
    - name: /etc/init/celeryd.conf
    - source: salt://celery/celeryd.conf

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
