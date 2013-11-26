Asia/Taipei:
  timezone.system:
    - utc: True
    - order: 1

ntpdate time.stdtime.gov.tw > /dev/null 2>&1:
  cron.present:
    - user: root
    - minute: 0
    - hour: 0

# # http://docs.saltstack.com/ref/states/all/salt.states.ntp.html
# run-ntpdate:
#   cmd.run:
#     - name: "ntpdate time.stdtime.gov.tw"
