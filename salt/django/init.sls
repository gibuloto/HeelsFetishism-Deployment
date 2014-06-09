include:
  - common.build
  - memcache.client
  - postgresql.client
  - python
  - python.lxml
  - python.pil
  - ssh.github

project-repo:
  git.latest:
    - name: {{ pillar['project']['repo_url'] }}
    - rev: master
    - target: {{ pillar['project']['repo_path'] }}
    - runas: {{ pillar['system']['user'] }}
    - require:
      - file: github-private-key
      - file: github-public-key

project-upload-dir:
  file.directory:
    - name: {{ pillar['project']['path'] }}/upload/
    - user: www-data
    - group: www-data
    - mode: 0744
    - makedirs: True
    - require:
      - git: project-repo

project-virtualenv:
  virtualenv.manage:
    - name: {{ pillar['project']['virtualenv_path'] }}
    - system_site_packages: False
    - pip: True
    - runas: {{ pillar['system']['user'] }}
    - require:
      - pkg: python-packages

project-virtualenv-postactivate:
  file.managed:
    - template: jinja
    - name: {{ pillar['project']['virtualenv_path'] }}/bin/postactivate
    - source: salt://django/postactivate
    - user: {{ pillar['system']['user'] }}
    - group: {{ pillar['system']['user'] }}
    - mode: 0775
    - require:
      - virtualenv: project-virtualenv

project-pip-requirements:
  pip.installed:
    - bin_env: {{ pillar['project']['virtualenv_path'] }}
    - requirements: {{ pillar['project']['repo_path'] }}/requirements.txt
    - user: {{ pillar['system']['user'] }}
    - require:
      - pkg: lxml-libs-packages
      - pkg: memcache-client-packages
      - pkg: pil-libs-packages
      - pkg: postgresql-client-packages
      - virtualenv: project-virtualenv

environ-var-HF_ENV:
  file.append:
    - name: {{ pillar['system']['home_path'] }}/.bashrc
    - text: "export HF_ENV={{ pillar['project']['HF_ENV'] }}"

environ-var-HF_TOKEN:
  file.append:
    - name: {{ pillar['system']['home_path'] }}/.bashrc
    - text: "export HF_TOKEN={{ pillar['project']['HF_TOKEN'] }}"

environ-var-HF_SUBMIT_API_URL:
  file.append:
    - name: {{ pillar['system']['home_path'] }}/.bashrc
    - text: "export HF_SUBMIT_API_URL={{ pillar['project']['HF_SUBMIT_API_URL'] }}"
