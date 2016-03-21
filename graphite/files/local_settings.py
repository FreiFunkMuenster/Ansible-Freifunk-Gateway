
DEBUG = False

SECRET_KEY = 'docker'

TIME_ZONE = 'Europe/Berlin'

GRAPHITE_ROOT = '/var/lib/graphite/'
CONF_DIR = '/var/lib/graphite/conf/'
STORAGE_DIR = '/var/lib/graphite/'
CONTENT_DIR = '/var/lib/graphite/webapp/content/'
WHISPER_DIR = '/var/lib/graphite/storage/whisper/'

DEFAULT_CACHE_DURATION = 0

LOG_DIR = '/var/log/graphite/'
LOG_RENDERING_PERFORMANCE = True
LOG_METRIC_ACCESS = True
LOG_CACHE_PERFORMANCE = True

DATABASES = {
    'default': {
        'NAME': '/var/lib/graphite/storage/graphite.db',
        'ENGINE': 'django.db.backends.sqlite3',
        'USER': '',
        'PASSWORD': '',
        'HOST': '',
        'PORT': ''
    }
}

CARBONLINK_HOSTS = ["127.0.0.1:7002:a"]
CARBONLINK_TIMEOUT = 1.0
