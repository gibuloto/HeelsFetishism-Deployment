include:
  - common

nginx-packages:
  pkg.installed:
    - names:
      - nginx
    - require:
      - pkg: general-packages

nginx-conf:
  file.managed:
    - template: jinja
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/config/nginx.conf
    - user: root
    - group: root
    - require:
      - pkg: nginx-packages

nginx-mime:
  file.managed:
    - name: /etc/nginx/mime.types
    - source: salt://nginx/config/mime.types
    - user: root
    - group: root
    - require:
      - pkg: nginx-packages

nginx-default:
  file.managed:
    - template: jinja
    - name: /etc/nginx/sites-available/default
    - source: salt://nginx/config/default
    - user: root
    - group: root
    - require:
      - file: logs-dir
      - pkg: nginx-packages

nginx:
  service.running:
    - enable: True
    - watch:
      - file: nginx-conf
      - file: nginx-mime
      - file: nginx-default
