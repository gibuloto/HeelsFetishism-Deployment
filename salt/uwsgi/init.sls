uwsgi:
  pip.installed:
    - require:
      - pkg: python-packages

uwsgi-apps-available:
  file.managed:
    - template: jinja
    - name: /etc/uwsgi/apps-available/heelsfetishism.ini
    - source: salt://uwsgi/heelsfetishism.ini
    - makedirs: True
    - user: root
    - group: root
    - require:
      - pip: uwsgi
      - file: logs-dir
      - virtualenv: project-virtualenv

uwsgi-apps-enabled:
  file.symlink:
    - name: /etc/uwsgi/apps-enabled/heelsfetishism.ini
    - target: /etc/uwsgi/apps-available/heelsfetishism.ini
    - makedirs: True
    - require:
      - file: uwsgi-apps-available

uwsgi-upstart-conf:
  file.managed:
    - template: jinja
    - name: /etc/init/uwsgi.conf
    - source: salt://uwsgi/uwsgi.conf
    - require:
      - file: uwsgi-apps-enabled

uwsgi-service:
  service.running:
    - name: uwsgi
    - enable: True
    - watch:
      - file: uwsgi-apps-available
      - file: uwsgi-upstart-conf
      - git: project-repo
    - order: last
