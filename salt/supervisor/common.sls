include:
  - common

supervisor-packages:
  pkg.installed:
    - names:
      - supervisor

# supervisorctl-restart:
#   cmd.run:
#     - name: "supervisorctl restart all"
#     - order: last
