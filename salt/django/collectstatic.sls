include:
  - django

# nodejs_ppa:
#   pkgrepo.managed:
#     - ppa: chris-lea/node.js
#     - require_in:
#       - pkg: nodejs

# nodejs:
#   pkg.latest:
#     - name: nodejs

# grunt:
#   cmd.run:
#     - unless: which grunt
#     - name: "npm install -g grunt-cli"
#     - user: root
#     - require:
#       - pkg: nodejs

# bower:
#   cmd.run:
#     - unless: which bower
#     - name: "npm install -g bower"
#     - user: root
#     - require:
#       - pkg: nodejs

# project-npm-install:
#   cmd.wait:
#     - name: "npm install"
#     - cwd: {{ pillar['project']['path'] }}
#     - user: {{ pillar['system']['user'] }}
#     - require:
#       - pkg: nodejs
#     - watch:
#       - git: project-repo

# project-bower-install:
#   cmd.wait:
#     - name: "bower install"
#     - cwd: {{ pillar['project']['path'] }}
#     - user: {{ pillar['system']['user'] }}
#     - require:
#       - cmd: bower
#     - watch:
#       - git: project-repo

# project-grunt-build:
#   cmd.wait:
#     - name: "grunt build"
#     - cwd: {{ pillar['project']['path'] }}
#     - user: {{ pillar['system']['user'] }}
#     - require:
#       - cmd: grunt
#       - cmd: bower
#       - cmd: project-npm-install
#       - cmd: project-bower-install
#     - watch:
#       - git: project-repo

project-collectstatic:
  cmd.wait:
    - name: "{{ pillar['project']['virtualenv_path'] }}/bin/python manage.py collectstatic --noinput"
    - cwd: {{ pillar['project']['path'] }}
    - user: {{ pillar['system']['user'] }}
    - watch:
      - git: project-repo
