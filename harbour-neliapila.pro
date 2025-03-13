# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-neliapila

CONFIG += sailfishapp_qml

DEPLOYMENT_PATH = /usr/share/$${TARGET}

py.files = py
py.path = $${DEPLOYMENT_PATH}

INSTALLS += py


# to disable building translations every time, comment out the
# following CONFIG line
#CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
#TRANSLATIONS += translations/Neliapila-de.ts

DISTFILES += \
    py/lib/basc_py4chan/__init__.py \
    py/lib/basc_py4chan/board.py \
    py/lib/basc_py4chan/file.py \
    py/lib/basc_py4chan/post.py \
    py/lib/basc_py4chan/thread.py \
    py/lib/basc_py4chan/url.py \
    py/lib/basc_py4chan/util.py \
    py/boards.py \
    py/captcha.py \
    py/getdata.py \
    py/image_provider.py \
    py/pinned.py \
    py/posting.py \
    py/posts.py \
    py/pyotherside.py \
    py/savefile.py \
    py/storage.py \
    py/threads.py \
    py/utils.py \
    qml/js/*.js \
    qml/harbour-neliapila.qml \
    qml/pages/*.qml \
    qml/items/*.qml \
    qml/cover/CoverPage.qml \
    qml/pages/WebmViewPage.qml \
    rpm/harbour-neliapila.changes.in \
    rpm/harbour-neliapila.spec
