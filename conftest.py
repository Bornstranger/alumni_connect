from django.conf import settings


def pytest_configure(config):
    settings.DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": ":memory:",
            "ATOMIC_REQUESTS": False,
        }
    }
