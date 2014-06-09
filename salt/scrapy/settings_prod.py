LOG_FILE = "{{ pillar['system']['log_path'] }}/scrapy.log"
LOG_STDOUT = True

EXTENSIONS = {
    'scrapy_sentry.extensions.Errors': 10,
}

SENTRY_DSN = "{{ pillar['crawler']['sentry_dsn'] }}"
