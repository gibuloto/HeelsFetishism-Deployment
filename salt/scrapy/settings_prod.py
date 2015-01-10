LOG_FILE = "{{ pillar['system']['log_path'] }}/scrapy.log"
LOG_STDOUT = True

EXTENSIONS = {
    'scrapy_sentry.extensions.Errors': 10,
}

SENTRY_DSN = "{{ pillar['crawler']['sentry_dsn'] }}"

SEEMODEL_USERNAME = "{{ pillar['crawler']['seemodel_username'] }}"
SEEMODEL_PASSWORD = "{{ pillar['crawler']['seemodel_password'] }}"
