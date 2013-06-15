include:
  - common
  - ssh.common

github-private-key:
  file.managed:
    - name: {{ pillar['system']['home_path'] }}/.ssh/github
    - source: salt://ssh/keys/github/id_rsa
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - mode: 0400
    - require:
      - file: ssh-config

github-public-key:
  file.managed:
    - name: {{ pillar['system']['home_path'] }}/.ssh/github.pub
    - source: salt://ssh/keys/github/id_rsa.pub
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - mode: 0400
    - require:
      - file: ssh-config
