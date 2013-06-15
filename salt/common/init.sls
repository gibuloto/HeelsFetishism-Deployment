en_US.UTF-8:
  locale.system

Asia/Taipei:
  timezone.system:
    - utc: True
    - order: 1

create-user:
  user.present:
    - name: {{ pillar['system']['user'] }}
    - home: {{ pillar['system']['home_path'] }}
    - shell: /bin/bash

file-setup_locale:
  file.managed:
    - name: {{ pillar['system']['home_path'] }}/setup_locale.sh
    - source: salt://common/scripts/setup_locale.sh
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - mode: 0700
    - recurse:
      - user
      - group
    - require:
      - locale: en_US.UTF-8
      - user: create-user

run-setup_locale:
  cmd.run:
    - name: "source setup_locale.sh"
    - cwd: {{ pillar['system']['home_path'] }}
    - shell: /bin/bash
    - user: {{ pillar['system']['user'] }}
    - watch:
      - file: file-setup_locale
    - order: 2

logs-dir:
  file.directory:
    - name: {{ pillar['system']['home_path'] }}/logs/
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - makedirs: True
    - require:
      - user: create-user

sudoer-file:
  file.managed:
    - template: jinja
    - name: /etc/sudoers.d/{{ pillar['system']['user'] }}
    - source: salt://common/files/sudoers.template
    - user: root
    - group: root
    - mode: 0440
    - require:
      - user: create-user

general-packages:
  pkg.installed:
    - names:
      - build-essential
      - git-core
      - htop
      - vim
    - require:
      - cmd: run-setup_locale
