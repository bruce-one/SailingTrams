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
TARGET = SailingTrams

CONFIG += sailfishapp

SOURCES += src/SailingTrams.cpp

OTHER_FILES += qml/SailingTrams.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/SailingTrams.changes.in \
    rpm/SailingTrams.spec \
    rpm/SailingTrams.yaml \
    translations/*.ts \
    SailingTrams.desktop \
    qml/sugar.js \
    qml/pages/upcoming.js \
    qml/pages/StopPage.qml \
    qml/pages/AddStopPage.qml \
    qml/pages/database.js

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
#TRANSLATIONS += translations/SailingTrams-de.ts

