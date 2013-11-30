include:
  - django
  - newrelic.python

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

newrelic-uwsgi-config:
  file.managed:
    - template: jinja
    - name: {{ pillar['system']['home_path'] }}/newrelic_uwsgi.ini
    - source: salt://uwsgi/newrelic.ini
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}

uwsgi-upstart-conf:
  file.managed:
    - template: jinja
    - name: /etc/init/uwsgi.conf
    - source: salt://uwsgi/uwsgi.conf
    - require:
      - file: uwsgi-apps-enabled
      - file: newrelic-uwsgi-config
      - pip: newrelic-python-package

uwsgi-service:
  service.running:
    - name: uwsgi
    - enable: True
    - watch:
      - file: uwsgi-apps-available
      - file: uwsgi-upstart-conf
      - git: project-repo
    - order: last
