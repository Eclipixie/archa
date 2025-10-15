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
        id: p_setSinkVolume;
        running: false;

        property real target: 0;

        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", target];
    }

    Process {
        id: p_toggleSinkMute;
        running: false;

        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"];
    }

    function setSinkVolume(volume): void {
        p_setSinkVolume.target = volume;
        p_setSinkVolume.running = true;
    }

    function toggleSinkMute(): void {
        p_toggleSinkMute.running = true;
    }

    Process {
        id: p_setSourceVolume;
        running: false;

        property real target: 0;

        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", target];
    }

    Process {
        id: p_toggleSourceMute;
        running: false;

        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"];
    }

    function setSourceVolume(volume): void {
        p_setSourceVolume.target = volume;
        p_setSourceVolume.running = true;
    }

    function toggleSourceMute(): void {
        p_toggleSinkMute.running = true;
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }
}