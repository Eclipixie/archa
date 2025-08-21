pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink;
    readonly property PwNode source: Pipewire.defaultAudioSource;

    readonly property bool sinkMuted: sink?.audio?.muted ?? false;
    readonly property real sinkVolume: sink?.audio?.volume ?? 0;

    readonly property bool sourceMuted: source?.audio?.muted ?? false;
    readonly property real sourceVolume: source?.audio?.volume ?? 0;

    Process {
        id: setSinkVolumeProc;
        running: false;

        property real target: 0;

        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", target];
    }

    Process {
        id: toggleSinkMuteProc;
        running: false;

        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"];
    }

    function setSinkVolume(volume): void {
        setSinkVolumeProc.target = volume;
        setSinkVolumeProc.running = true;
    }

    function toggleSinkMute(): void {
        toggleSinkMuteProc.running = true;
    }

    Process {
        id: setSourceVolumeProc;
        running: false;

        property real target: 0;

        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", target];
    }

    Process {
        id: toggleSourceMuteProc;
        running: false;

        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"];
    }

    function setSourceVolume(volume): void {
        setSourceVolumeProc.target = volume;
        setSourceVolumeProc.running = true;
    }

    function toggleSourceMute(): void {
        toggleSinkMuteProc.running = true;
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }
}