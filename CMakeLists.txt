cmake_minimum_required(VERSION 3.5)

set(PROJECT_NAME cutefish-settings)
project(${PROJECT_NAME})

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake;${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(QT Core Gui Widgets Quick QuickControls2 X11Extras DBus Xml Concurrent LinguistTools)
find_package(Qt5 REQUIRED ${QT})
find_package(X11 REQUIRED)
find_package(Freetype REQUIRED)
find_package(PkgConfig REQUIRED)
find_package(Libcrypt REQUIRED)

find_package(KF5NetworkManagerQt REQUIRED)
find_package(KF5ModemManagerQt REQUIRED)

pkg_search_module(FontConfig REQUIRED fontconfig IMPORTED_TARGET)
pkg_search_module(ICU REQUIRED icu-i18n)

include_directories(${ICU_INCLUDE_DIRS})

set(SRCS
    src/application.cpp
    src/main.cpp
    src/appearance.cpp
    src/battery.cpp
    src/brightness.cpp
    src/fontsmodel.cpp
    src/language.cpp
    src/about.cpp
    src/background.cpp
    src/password.cpp
    src/batteryhistorymodel.cpp
    src/cicontheme.cpp
    src/fonts/kxftconfig.cpp
    src/fonts/fonts.cpp
    src/powermanager.cpp
    src/cursor/cursorthememodel.cpp
    src/cursor/cursortheme.cpp
    src/cursor/mouse.cpp
    src/datetime/time.cpp
    src/datetime/timezonedata.h
    src/datetime/timezonemap.cpp
    src/datetime/timedated_interface.cpp
)

set(RESOURCES
    src/resources.qrc
)

qt5_add_dbus_adaptor(DBUS_SOURCES
                     src/org.cutefish.SettingsUI.xml
                     src/application.h Application)
set_source_files_properties(${DBUS_SOURCES} PROPERTIES SKIP_AUTOGEN ON)

# qt5_add_dbus_interface(DBUS_SOURCES src/datetime/org.freedesktop.timedate1.xml timedated_interface)

add_executable(${PROJECT_NAME} ${DBUS_SOURCES} ${SRCS} ${RESOURCES})
target_link_libraries(${PROJECT_NAME}
        Qt5::Core
        Qt5::Widgets
        Qt5::Quick
        Qt5::QuickControls2
        Qt5::DBus
        Qt5::Xml
        Qt5::X11Extras
        Qt5::Concurrent
        # FishUI

        KF5::NetworkManagerQt
        KF5::ModemManagerQt

        PkgConfig::FontConfig
        ${FREETYPE_LIBRARIES}
        ${ICU_LDFLAGS}
        Libcrypt::Libcrypt

        ${X11_LIBRARIES}
        X11::X11
        X11::Xi
        X11::Xcursor
)

file(GLOB TS_FILES translations/*.ts)
qt5_create_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES} SOURCES ${TS_FILES})
add_dependencies(${PROJECT_NAME} translations)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

install(FILES
    cutefish-settings.desktop
    DESTINATION /usr/share/applications/
    COMPONENT Runtime
)

install(FILES ${QM_FILES} DESTINATION /usr/share/${PROJECT_NAME}/translations)
