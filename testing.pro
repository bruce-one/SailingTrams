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
TARGET = testing

CONFIG += sailfishapp

SOURCES += src/testing.cpp

OTHER_FILES += qml/testing.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/testing.changes.in \
    rpm/testing.spec \
    rpm/testing.yaml \
    translations/*.ts \
    testing.desktop \
    qml/sugar.js \
    qml/pages/upcoming.js

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/testing-de.ts

