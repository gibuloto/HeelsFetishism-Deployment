include:
  - common
  - ssh.common

vinta_air:
  ssh_auth.present:
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - source: salt://ssh/keys/vinta/id_rsa.air.pub
    - require:
      - user: create-user

vinta_mini:
  ssh_auth.present:
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - source: salt://ssh/keys/vinta/id_rsa.mini.pub
    - require:
      - user: create-user
