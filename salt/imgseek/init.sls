include:
  - common
  - python.boto
  - supervisor.common

imgseek-packages:
  pkg.installed:
    - names:
      - libmagick++-dev
      - swig
    - require:
      - pkg: python-packages

imgseek-virtualenv:
  virtualenv.manage:
    - name: {{ pillar['imgseek']['virtualenv_path'] }}
    - requirements: salt://imgseek/config/requirements.txt
    - no_site_packages: true
    - runas: {{ pillar['system']['user'] }}
    - require:
      - pkg: imgseek-packages

iskdaemon-conf:
  file.managed:
    - template: jinja
    - name: /etc/iskdaemon/isk-daemon.conf
    - source: salt://imgseek/config/isk-daemon.conf
    - user: root
    - group: root
    - recurse:
      - user
      - group
    - makedirs: True
    - require:
      - virtualenv: imgseek-virtualenv

imgseek-supervisor-conf:
  file.managed:
    - template: jinja
    - name: /etc/supervisor/conf.d/imgseek.conf
    - source: salt://supervisor/config/imgseek.conf
    - user: root
    - group: root
    - require:
      - file: logs-dir
      - file: iskdaemon-conf
      - pkg: supervisor-packages

imgseek-supervisorctl-update:
  cmd.wait:
    - name: "supervisorctl update"
    - watch:
      - file: imgseek-supervisor-conf

supervisorctl-restart-imgseek:
  cmd.wait:
    - name: "supervisorctl restart imgseek"
    - require:
      - cmd: imgseek-supervisorctl-update
    - watch:
      - file: iskdaemon-conf
      - file: imgseek-supervisor-conf

file-backup_imgseek:
  file.managed:
    - template: jinja
    - name: {{ pillar['system']['home_path'] }}/backup_imgseek.py
    - source: salt://imgseek/scripts/backup_imgseek.py
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - mode: 0777
    - recurse:
      - user
      - group
    - require:
      - user: create-user

crontab-backup_imgseek:
  cron.present:
    - name: "python {{ pillar['system']['home_path'] }}/backup_imgseek.py"
    - user: {{ pillar['system']['user'] }}
    - minute: "46"
    - hour: "9"
    - require:
      - file: file-backup_imgseek
