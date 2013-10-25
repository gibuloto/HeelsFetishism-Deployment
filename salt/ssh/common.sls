ssh-dir:
  file.directory:
    - name: {{ pillar['system']['home_path'] }}/.ssh/
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - makedirs: True
    - recurse:
      - user
      - group

ssh-config:
  file.managed:
    - template: jinja
    - name: {{ pillar['system']['home_path'] }}/.ssh/config
    - source: salt://ssh/ssh_config
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - require:
      - file: ssh-dir
