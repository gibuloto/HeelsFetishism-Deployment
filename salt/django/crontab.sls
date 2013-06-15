include:
  - django
  - django.syncdb
  - scrapy

crontab-file:
  file.managed:
    - template: jinja
    - name: /etc/cron.d/{{ pillar['project']['name'] }}
    - source: salt://django/files/crontab_file
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: crawler-settings
      - git: project-repo
      - git: crawler-repo
      - virtualenv: project-virtualenv
