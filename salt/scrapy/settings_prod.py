SENTRY_DSN = "{{ pillar['crawler']['sentry_dsn'] }}"

EXTENSIONS = {
    'scrapy_sentry.extensions.Errors': 10,
}

# where Django settings.py placed
DJANGO_SETTINGS_DIR = "{{ pillar['project']['path'] }}/{{ pillar['project']['name'] }}"
