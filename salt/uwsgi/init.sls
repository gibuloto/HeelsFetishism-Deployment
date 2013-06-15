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
    - name: /etc/uwsgi/uwsgi.ini
    - source: salt://uwsgi/config/uwsgi.ini
    - user: root
    - group: root
    - require:
      - pip: uwsgi
      - file: logs-dir
      - virtualenv: project-virtualenv
