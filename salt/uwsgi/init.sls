include:
  - common
  - django

uwsgi:
  pip.installed:
    - require:
      - pkg: python-packages

uwsgi-conf:
  file.managed:
    - template: jinja
    - name: /etc/uwsgi/apps-available/default.ini
    - source: salt://uwsgi/config/default.ini
    - makedirs: True
    - user: root
    - group: root
    - require:
      - pip: uwsgi
      - file: logs-dir
      - virtualenv: project-virtualenv

uwsgi-app-link:
  file.symlink:
    - name: /etc/uwsgi/apps-enabled/default.ini
    - target: /etc/uwsgi/apps-available/default.ini
    - makedirs: True
    - require:
      - file: uwsgi-conf

uwsgi-upstart-conf:
  file.managed:
    - template: jinja
    - name: /etc/init/uwsgi.conf
    - source: salt://uwsgi/upstart/uwsgi.conf
    - require:
      - file: uwsgi-app-link

uwsgi-service:
  service.running:
    - name: uwsgi
    - enable: True
    - watch:
      - file: uwsgi-conf
      - file: uwsgi-upstart-conf
      - git: project-repo
    - order: last
