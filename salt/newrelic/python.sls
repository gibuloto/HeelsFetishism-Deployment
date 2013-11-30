include:
  - python

newrelic-python-package:
  pip.installed:
    - name: newrelic
    - require:
      - pkg: python-packages
