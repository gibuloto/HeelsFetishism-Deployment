include:
  - python

boto-packages:
  pip.installed:
    - names:
      - boto
    - require:
      - pkg: python-packages
