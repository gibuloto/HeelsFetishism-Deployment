include:
  - django

nodejs_ppa:
  pkgrepo.managed:
    - ppa: chris-lea/node.js
    - require_in:
      - pkg: nodejs

nodejs:
  pkg.latest:
    - name: nodejs

grunt:
  cmd.run:
    - unless: which grunt
    - name: "npm install -g grunt-cli"
    - user: root
    - require:
      - pkg: nodejs

bower:
  cmd.run:
    - unless: which bower
    - name: "npm install -g bower"
    - user: root
    - require:
      - pkg: nodejs

# grunt:
#   npm.installed:
#     - name: grunt-cli
#     - runas: root
#     - require:
#       - pkg: nodejs

# bower:
#   npm.installed:
#     - name: bower
#     - runas: root
#     - require:
#       - pkg: nodejs

project-npm-install:
  cmd.run:
    - name: "npm install"
    - cwd: {{ pillar['project']['path'] }}
    - user: {{ pillar['system']['user'] }}
    - require:
      - pkg: nodejs
      - git: project-repo

project-bower-install:
  cmd.run:
    - name: "bower install"
    - cwd: {{ pillar['project']['path'] }}
    - user: {{ pillar['system']['user'] }}
    - require:
      - cmd: bower
      - git: project-repo

project-grunt-build:
  cmd.run:
    - name: "grunt build"
    - cwd: {{ pillar['project']['path'] }}
    - user: {{ pillar['system']['user'] }}
    - require:
      - cmd: grunt
      - cmd: bower
      - cmd: project-npm-install
      - cmd: project-bower-install
      - git: project-repo

project-collectstatic:
  cmd.run:
    - name: "{{ pillar['project']['virtualenv_path'] }}/bin/python manage.py collectstatic --noinput"
    - cwd: {{ pillar['project']['path'] }}
    - user: {{ pillar['system']['user'] }}
    - require:
      - cmd: project-grunt-build
