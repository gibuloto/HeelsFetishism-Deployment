base:
  '*':
    - common
    - ssh.login

  'heels-all':
    - hosts.heels-all
    - crontab.crawler
    - crontab.publisher
    - role_db
    - role_imgseek
    - role_memcache
    - role_web
