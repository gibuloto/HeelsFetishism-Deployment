Asia/Taipei:
  timezone.system:
    - utc: True
    - order: 1

cron-service:
  service.running:
    - name: cron
    - enable: True
    - watch:
      - timezone: Asia/Taipei

rsyslog-service:
  service.running:
    - name: rsyslog
    - enable: True
    - watch:
      - timezone: Asia/Taipei

time-packages:
  pkg.installed:
    - names:
      - ntp
