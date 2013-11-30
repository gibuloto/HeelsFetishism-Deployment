include:
  - common.time

en_US.UTF-8:
  locale.system:
    - order: 2

create-system-user:
  user.present:
    - name: {{ pillar['system']['user'] }}
    - home: {{ pillar['system']['home_path'] }}
    - shell: /bin/bash
    - order: 3

sudoer-file:
  file.managed:
    - template: jinja
    - name: "/etc/sudoers.d/{{ pillar['system']['user'] }}"
    - source: salt://common/sudoers.template
    - user: root
    - group: root
    - mode: 0440

logs-dir:
  file.directory:
    - name: {{ pillar['system']['log_path'] }}
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - mode: 0755
    - makedirs: True
    - order: 4

hostname:
  host.present:
    - ip: 127.0.1.1
    - names:
      - {{ grains['host'] }}

terminal-packages:
  pkg.installed:
    - names:
      - curl
      - htop
      - mosh
      - screen
      - vim
