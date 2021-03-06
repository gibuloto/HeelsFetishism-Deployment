include:
  - django
  - scrapy

crontab-crawler:
  file.managed:
    - template: jinja
    - name: /etc/cron.d/crawler
    - source: salt://crontab/crawler
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: crawler-settings
      - git: crawler-repo
      - git: project-repo
      - virtualenv: project-virtualenv
