base:
  '*':
    - common
    - ssh.login

  'heels-all':
    - hosts.heels-all
    - role_db
    - role_imgseek
    - role_web
