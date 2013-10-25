include:
  - django
  - scrapy

crontab-file:
  file.managed:
    - template: jinja
    - name: "/etc/cron.d/{{ pillar['project']['name'] }}"
    - source: salt://crontab/crawler
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: crawler-settings
      - git: crawler-repo
      - git: project-repo
      - virtualenv: project-virtualenv
