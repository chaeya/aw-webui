<template lang="pug">
div
  div.d-sm-flex.justify-content-between
    div
      h5.mt-1.mb-2.mb-sm-0 시작 페이지
    div
      b-select.landingpage(v-if="loaded" size="sm" :value="landingpage", @change="set($event.target.value)")
        option(value="/home") Home
        option(:value="'/activity/' + hostname + '/view/'" v-for="hostname in hostnames") 보고서 ({{hostname}})
        option(value="/timeline") 타임라인
      span(v-else)
        | 로딩 중...
  small
    | 프로그램 시작시 열리는 페이지를 설정할 수 있습니다.
</template>
<script>
export default {
  name: 'LandingPageSettings',
  data: () => {
    return {
      landingpage: localStorage.landingpage || '/home',
      loaded: false,
    };
  },
  computed: {
    hostnames() {
      return Object.keys(this.$store.getters['buckets/bucketsByHostname']);
    },
  },
  async mounted() {
    this.landingpage = localStorage.landingpage || '/home';
    await this.$store.dispatch('buckets/ensureBuckets');
    this.loaded = true;
  },
  methods: {
    set: function (landingpage) {
      localStorage.landingpage = landingpage;
      console.log('Set landingpage to ' + landingpage);
    },
  },
};
</script>
