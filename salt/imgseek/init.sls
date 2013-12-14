include:
  - python
  - python.boto

# imgseek-packages:
#   pkg.installed:
#     - names:
#       - libmagick++-dev
#       - swig
#     - require:
#       - pkg: python-packages

# imgseek-virtualenv:
#   virtualenv.manage:
#     - name: {{ pillar['imgseek']['virtualenv_path'] }}
#     - requirements: salt://imgseek/config/requirements.txt
#     - system_site_packages: False
#     - pip: True
#     - runas: {{ pillar['system']['user'] }}
#     - require:
#       - pkg: imgseek-packages

# iskdaemon-conf:
#   file.managed:
#     - template: jinja
#     - name: /etc/iskdaemon/isk-daemon.conf
#     - source: salt://imgseek/config/isk-daemon.conf
#     - user: root
#     - group: root
#     - recurse:
#       - user
#       - group
#     - makedirs: True
#     - require:
#       - virtualenv: imgseek-virtualenv

# imgseek-upstart-conf:
#   file.managed:
#     - template: jinja
#     - name: /etc/init/iskdaemon.conf
#     - source: salt://imgseek/upstart/iskdaemon.conf
#     - require:
#       - file: iskdaemon-conf

# imgseek-service:
#   service.running:
#     - name: iskdaemon
#     - enable: True
#     - watch:
#       - file: imgseek-upstart-conf
#     - order: last

imgseek-service:
  service.dead:
    - name: iskdaemon
    - enable: False

# file-backup_imgseek:
#   file.managed:
#     - template: jinja
#     - name: {{ pillar['system']['home_path'] }}/backup_imgseek.py
#     - source: salt://imgseek/scripts/backup_imgseek.py
#     - user: {{ pillar['system']['user'] }}
#     - group: {{ pillar['system']['user'] }}
#     - mode: 0755
#     - recurse:
#       - user
#       - group

# crontab-backup_imgseek:
#   cron.present:
#     - name: "python {{ pillar['system']['home_path'] }}/backup_imgseek.py"
#     - user: {{ pillar['system']['user'] }}
#     - minute: "46"
#     - hour: "9"
#     - require:
#       - file: file-backup_imgseek

crontab-backup_imgseek-absent:
  cron.absent:
    - name: "python {{ pillar['system']['home_path'] }}/backup_imgseek.py"
    - user: {{ pillar['system']['user'] }}
