<template lang="pug">
div
  div.d-sm-flex.justify-content-between
    div
      h5.mt-1.mb-2.mb-sm-0 일일 시작 시간
    div
      b-input(type="time" size="sm" :value="startOfDay" @change="setStartOfDay($event.target.value)")
  small
    | 하루의 시작 시간을 설정합니다.
    | 기본값은 04:00 로 설정되어 있습니다.
</template>
<script>
export default {
  name: 'DaystartSettings',
  data: () => {
    return {
      startOfDay: '',
    };
  },
  mounted() {
    this.startOfDay = localStorage.startOfDay;
  },
  methods: {
    setStartOfDay: function (time_minutes) {
      localStorage.startOfDay = time_minutes;
      console.log('Set start of day to ' + time_minutes);
    },
  },
};
</script>
