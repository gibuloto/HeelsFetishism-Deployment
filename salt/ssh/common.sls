include:
  - common

ssh-dir:
  file.directory:
    - name: {{ pillar['system']['home_path'] }}/.ssh/
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: create-user

ssh-config:
  file.managed:
    - name: {{ pillar['system']['home_path'] }}/.ssh/config
    - source: salt://ssh/config/ssh_config
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - require:
      - file: ssh-dir
