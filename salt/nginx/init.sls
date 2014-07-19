include:
  - common

nginx-packages:
  pkg.installed:
    - names:
      - nginx

nginx-default-absent:
  file.absent:
    - name: /etc/nginx/sites-enabled/default

nginx-conf:
  file.managed:
    - template: jinja
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/nginx.conf
    - user: root
    - group: root
    - require:
      - pkg: nginx-packages

nginx-mime:
  file.managed:
    - template: jinja
    - name: /etc/nginx/mime.types
    - source: salt://nginx/mime.types
    - user: root
    - group: root
    - require:
      - pkg: nginx-packages

nginx-includes-common:
  file.managed:
    - template: jinja
    - name: /etc/nginx/includes/heelsfetishism-common
    - source: salt://nginx/includes/heelsfetishism-common
    - makedirs: True
    - require:
      - pkg: nginx-packages

nginx-sites-available:
  file.managed:
    - template: jinja
    - name: /etc/nginx/sites-available/heelsfetishism
    - source: salt://nginx/heelsfetishism
    - user: root
    - group: root
    - require:
      - file: logs-dir
      - pkg: nginx-packages

nginx-sites-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/heelsfetishism
    - target: /etc/nginx/sites-available/heelsfetishism
    - require:
      - file: nginx-sites-available

nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - file: nginx-default-absent
      - file: nginx-sites-enabled
    - watch:
      - file: nginx-conf
      - file: nginx-mime
      - file: nginx-sites-available
      - file: nginx-includes-common
