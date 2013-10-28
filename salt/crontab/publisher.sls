include:
  - django

crontab-publisher:
  file.managed:
    - template: jinja
    - name: /etc/cron.d/publisher
    - source: salt://crontab/publisher
    - user: root
    - group: root
    - mode: 0644
    - require:
      - git: project-repo
      - virtualenv: project-virtualenv
