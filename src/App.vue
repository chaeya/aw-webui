<template lang="pug">
div#wrapper
  aw-header

  div(:class="{'container': !fullContainer, 'container-fluid': fullContainer}").px-0.px-md-3
    div.aw-container.my-3.p-3
      error-boundary
        user-satisfaction-poll
        new-release-notification(v-if="isNewReleaseCheckEnabled")
        router-view

  div.container(style="color: #555")
    div(style="float: left")
      div.mb-1
        | About #[a(href="https://hamonikr.org/") HamoniKR]
      div

    div(style="float: right; text-align: right;")
      | 버그를 발견하면 #[a(href="https://github.com/hamonikr/hamonikr-activitywatch/issues/new/choose") 깃허브]에서 이슈를 남겨주세요
      br
      | 도움이 필요하면 #[a(href="https://hamonikr.org/") 하모니카 커뮤니티]를 방문하세요
      br
      span.mt-2(v-show="info", style="color: #888; font-size: 0.8em")
        | Host: {{info.hostname}}
        br
        | Version: {{info.version}}
</template>

<script>
// only import the icons you use to reduce bundle size
import 'vue-awesome/icons/brands/twitter';
import 'vue-awesome/icons/brands/github';

export default {
  data: function () {
    return {
      activityViews: [],
      info: {},
      isNewReleaseCheckEnabled: !process.env.VUE_APP_ON_ANDROID,
    };
  },

  computed: {
    fullContainer() {
      return this.$route.meta.fullContainer;
    },
  },

  mounted: async function () {
    this.$aw.getInfo().then(
      info => {
        this.info = info;
      },
      e => {
        console.error('Unable to connect: ', e);
        this.info = {};
      }
    );
  },
};
</script>