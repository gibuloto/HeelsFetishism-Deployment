base:
  '*':
    - common
    - ssh.login

  'heels-all':
    - hosts.heels-all
    - crontab.crawler
    - role_db
    - role_imgseek
    - role_memcache
    - role_web
