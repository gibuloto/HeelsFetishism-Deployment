base:
  '*':
    - common
    - ssh.login
    - role_db
    - role_imgseek
    - role_memcache
    - role_web
    - s3cmd
    - crontab.crawler
    - crontab.publisher
