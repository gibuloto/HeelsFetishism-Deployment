base:
  '*':
    - common
    - ssh.login

  'heels-all':
    - role_db
    - role_imgseek
    - role_memcache
    - role_web
    - s3cmd
    - crontab.crawler
    - crontab.publisher
