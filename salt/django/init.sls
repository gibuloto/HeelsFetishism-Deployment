include:
  - common
  - django.collectstatic
  - memcache.libs
  - postgresql.client
  - python
  - ssh.github
  - supervisor.common
  - uwsgi

# django-common-packages:
#   pkg.installed:
#     - names:
#       - sendmail

pil-packages:
  pkg.installed:
    - names:
      - python-imaging
      - libjpeg-dev
      - libfreetype6-dev
      - liblcms1-dev
      - zlib1g-dev
    - require:
      - pkg: python-packages

lxml-packages:
  pkg.installed:
    - names:
      - libxml2-dev
      - libxslt1-dev
    - require:
      - pkg: general-packages

project-repo:
  git.latest:
    - name: {{ pillar['project']['repo_url'] }}
    - rev: master
    - target: {{ pillar['project']['path'] }}
    - runas: {{ pillar['system']['user'] }}
    - require:
      - file: github-private-key
      - file: github-public-key
      - pkg: general-packages
      - user: create-user

project-upload-dir:
  file.directory:
    - name: {{ pillar['project']['path'] }}/upload/
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - makedirs: True
    - require:
      - git: project-repo

project-virtualenv:
  virtualenv.manage:
    - name: {{ pillar['project']['virtualenv_path'] }}
    - no_site_packages: true
    - runas: {{ pillar['system']['user'] }}
    - require:
      - pkg: python-packages
      - user: create-user

project-virtualenv-postactivate:
  file.managed:
    - template: jinja
    - name: {{ pillar['system']['home_path'] }}/.virtualenvs/postactivate
    - source: salt://django/files/postactivate
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - mode: 0775
    - require:
      - virtualenv: project-virtualenv

distribute:
  pip.installed:
    - bin_env: {{ pillar['project']['virtualenv_path'] }}
    - upgrade: True
    - require:
      - pkg: python-packages
      - virtualenv: project-virtualenv

project-pip-requirements:
  pip.installed:
    - bin_env: {{ pillar['project']['virtualenv_path'] }}
    - requirements: {{ pillar['project']['path'] }}/requirements.txt
    - require:
      - pip: distribute
      # - pkg: django-common-packages
      - pkg: lxml-packages
      - pkg: memcache-lib-packages
      - pkg: pil-packages
      - pkg: postgresql-client-packages
      - pkg: python-packages
      - virtualenv: project-virtualenv

project-supervisor-conf:
  file.managed:
    - template: jinja
    - name: /etc/supervisor/conf.d/django.conf
    - source: salt://supervisor/config/django.conf
    - user: root
    - group: root
    - require:
      - file: logs-dir
      - file: project-upload-dir
      - file: uwsgi-conf
      - pip: project-pip-requirements
      - pkg: supervisor-packages

project-supervisorctl-update:
  cmd.wait:
    - name: "supervisorctl update"
    - watch:
      - file: project-supervisor-conf

supervisorctl-restart-uwsgi:
  cmd.run:
    - name: "supervisorctl restart uwsgi"
    - order: last

supervisorctl-restart-celeryd:
  cmd.run:
    - name: "supervisorctl restart celeryd"
    - order: last
