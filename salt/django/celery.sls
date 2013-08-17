include:
  - django

celeryd-upstart-conf:
  file.managed:
    - template: jinja
    - name: /etc/init/celeryd.conf
    - source: salt://django/upstart/celeryd.conf

celeryd-service:
  service.running:
    - name: celeryd
    - enable: True
    - watch:
      - file: celeryd-upstart-conf
      - git: project-repo
    - order: last
