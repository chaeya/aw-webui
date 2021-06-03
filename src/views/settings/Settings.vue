<template lang="pug">
div
  h3 설정

  b-alert(variant="warning", show) #[b Note:] 이 설정은 브라우저에만 저장되며 브라우저를 바꾸는 경우 남아 있지 않습니다.

  hr

  DaystartSettings

  hr

  TimelineDurationSettings

  hr

  LandingPageSettings

  hr

  div(v-if="!$isAndroid")
    ReleaseNotificationSettings
    hr

  ColorSettings

  hr

  CategorizationSettings

</template>

<script>
import DaystartSettings from '~/views/settings/DaystartSettings.vue';
import TimelineDurationSettings from '~/views/settings/TimelineDurationSettings.vue';
import ReleaseNotificationSettings from '~/views/settings/ReleaseNotificationSettings.vue';
import CategorizationSettings from '~/views/settings/CategorizationSettings.vue';
import LandingPageSettings from '~/views/settings/LandingPageSettings.vue';
import ColorSettings from '~/views/settings/ColorSettings.vue';

export default {
  name: 'Settings',
  components: {
    DaystartSettings,
    TimelineDurationSettings,
    ReleaseNotificationSettings,
    CategorizationSettings,
    LandingPageSettings,
    ColorSettings,
  },
};
</script>
