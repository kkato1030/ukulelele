<template>
  <div id="app">
    <h1>Ukulelele</h1>
    <video-player :options="videoOptions"></video-player>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import VideoPlayer from "@/components/VideoPlayer.vue";
import channelConfig from "@/channel.json";

export default Vue.extend({
  name: "App",
  components: {
    VideoPlayer
  },
  data() {
    return {
      videoOptions: {
        autoplay: true,
        controls: true,
        fluid: true,
        responsive: true,
        liveui: true,
        sources: [
          {
            src: channelConfig.channel.playbackUrl,
            type: "application/x-mpegURL"
          }
        ]
      }
    };
  }
});
</script>

<style lang="scss"></style>
