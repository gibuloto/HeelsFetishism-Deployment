vinta_air:
  ssh_auth.present:
    - source: salt://ssh/keys/vinta/id_rsa.air.pub
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}

vinta_mini:
  ssh_auth.present:
    - source: salt://ssh/keys/vinta/id_rsa.mini.pub
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
