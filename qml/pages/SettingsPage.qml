/*
Neliapila - client for browsing 4chan image board.
2015-2019 Joni Kurunsaari
2019- Jacob Gold
2019- szopin
Issues: https://github.com/tabasku/harbour-neliapila/issues

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/settingsStorage.js" as SettingsStore


Page {
    id: settingsPage

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height + Theme.paddingLarge

        VerticalScrollDecorator {}

        RemorsePopup { id: settingClearedRemorse }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader { title: "Settings" }

            ExpandingSectionGroup {
                ExpandingSection {
                    id: section

                    property int sectionIndex: 0
                    title: "Behaviour"

                    content.sourceComponent: Column {
                        width: section.width
                        anchors.bottomMargin: 20

                        ComboBox {
                            label: "Thread refresh time"
                            description: "Set the time (in seconds) between fetching new posts in a thread or, optionally, disable auto-refresh"
                            currentIndex: SettingsStore.getSetting("ThreadRefreshTime")

                            menu: ContextMenu {
                                MenuItem { text: "60 seconds" }
                                MenuItem { text: "45 seconds" }
                                MenuItem { text: "30 seconds" }
                                MenuItem { text: "off" }
                            }

                            onCurrentIndexChanged: {
                                SettingsStore.setSetting("ThreadRefreshTime", currentIndex)
                            }
                        }

                        TextSwitch {
                            text: "Quickscroll active"
                            description: "Disable or enable quickscroll funtionality"
                            checked: SettingsStore.getSetting("QuickscrollEnabled") == 1 ? true : false

                            onCheckedChanged: {
                                SettingsStore.setSetting("QuickscrollEnabled", checked ? 1 : 0)
                            }
                        }
                    }
                }

                ExpandingSection {
                    id: section2

                    property int sectionIndex: 1
                    title: "Media"

                    content.sourceComponent: Column {
                        width: section.width
                        anchors.bottomMargin: 20

                        TextSwitch {
                            text: "Automatically loop webm videos"
                            description: "Disable or enable Automatic looping of webms"
                            checked: SettingsStore.getSetting("VideosAutomaticallyLoops") == 1 ? true : false

                            onCheckedChanged: {
                                SettingsStore.setSetting("VideosAutomaticallyLoops", checked ? 1 : 0)
                            }
                        }

                        TextSwitch {
                            text: "Start videos muted"
                            description: "Toggle videos automatically playing muted or not"
                            checked: SettingsStore.getSetting("VideosAutomaticallyMuted") == 1 ? true : false

                            onCheckedChanged: {
                                SettingsStore.setSetting("VideosAutomaticallyMuted", checked ? 1 : 0)
                            }
                        }
                    }
                }


                // This is just appended.
                // Probably better to attach a little summary section
                // Check Clover on Android as a template
                Button {
                    id: aboutButton
                    text: "About Neliapila"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        pageStack.push("AboutPage.qml");
                    }
                }


                // This should be here for troubleshooting if something goes wrong with
                // a user's settings. Additionally, good for dev troubleshooting
                Button {
                    id: resetSettingsButton
                    text: "Reset Settings to default"
                    anchors.horizontalCenter: parent.horizontalCenter

                    color: "red" // Dangerous button

                    onClicked: {
                        settingClearedRemorse.execute("Clearing Settings", function() {
                            SettingsStore.resetSettingsDB()
                            Qt.quit()
                        })
                    }
                }
            }
        }
    }
}


