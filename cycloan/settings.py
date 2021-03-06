import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '(-s!%56$s8i-ymiovum)_jrth9l&6@!w%=tz90^g7i04m2)&!6'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['*']

# Application definition
INSTALLED_APPS = [
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'core',
    'user',
    'owner',
    'cycle',
    'customer',
    'admin',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'cycloan.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'cycloan.wsgi.application'

# Sessions Config
SESSION_ENGINE = "django.contrib.sessions.backends.signed_cookies"
SESSION_COOKIE_HTTPONLY = True

# 2 WEEKS LONGER cookies
SESSION_COOKIE_AGE = 1209600


# Database
# https://docs.djangoproject.com/en/3.0/ref/settings/#databases


DATABASES = {   
    'default': {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'orcl',
        'USER': 'ROOT',
        'PASSWORD': '6667',
        'HOST': 'localhost',
        'PORT': '1521',
    }
}


# Password validation
# https://docs.djangoproject.com/en/3.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/3.0/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.0/howto/static-files/

STATIC_URL = '/static/'

STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'files/doc'),
    'static',
]

# custom file dirs

OWNER_PHOTO_DIR = 'files/owner/photo/'

CYCLE_PHOTO_DIR = 'files/owner/cycle/'

CUSTOMER_PHOTO_DIR = 'files/customer/photo/'

CUSTOMER_DOC_DIR = 'files/customer/doc/'

# email handling

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

EMAIL_HOST = 'mail.dhaka-ai.com'

EMAIL_PORT = 587

EMAIL_HOST_USER = os.environ.get('email')

EMAIL_HOST_PASSWORD = os.environ.get('password')

EMAIL_USE_TLS = False

EMAIL_USE_SSL = False

DEFAULT_FROM_EMAIL = 'no-reply@cycloan.com'

# Cycle Status Constants

CYCLE_AVAILABLE = 0

CYCLE_BOOKED = 1

# Trip Status Constants

TRIP_REQUESTED = 0

TRIP_ONGOING = 1

TRIP_REJECTED = 2

TRIP_COMPLETED = 3

TRIP_REVIEWED = 4

# Map Distance Constants

DLONG = 0.00079

DLAT = 0.00079
