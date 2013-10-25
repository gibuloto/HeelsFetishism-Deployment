s3cmd-packages:
  pkg.installed:
    - names:
      - s3cmd

s3cmd-config:
  file.managed:
    - template: jinja
    - name: {{ pillar['system']['home_path'] }}/.s3cfg
    - source: salt://common/s3cfg.template
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - mode: 0600
    - require:
      - pkg: s3cmd-packages
