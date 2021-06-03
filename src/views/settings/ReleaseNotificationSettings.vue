<template lang="pug">
div
  div.d-flex.justify-content-between
    div
      h5.mb-0 새 버전 알림
    div
      b-form-checkbox(v-model="data.isEnabled" switch)
  small
    | 다운로드 할 수있는 새로운 릴리스가있는 경우 알림. 하루에 한 번 확인.
</template>

<script>
import moment from 'moment';
import NewReleaseNotification from '~/components/NewReleaseNotification.vue';

const SHORT_BACKOFF_PERIOD = NewReleaseNotification.SHORT_BACKOFF_PERIOD;

export default {
  data() {
    return {
      data: {
        isEnabled: true,
        nextCheckTime: moment().add(SHORT_BACKOFF_PERIOD, 'seconds'),
        howOftenToCheck: SHORT_BACKOFF_PERIOD,
        timesChecked: 0,
      },
    };
  },
  watch: {
    data: {
      handler() {
        this.saveData();
      },
      deep: true,
    },
  },
  created() {
    this.retrieveData();
  },
  methods: {
    retrieveData() {
      if (localStorage.newReleaseCheckData) {
        try {
          this.data = JSON.parse(localStorage.newReleaseCheckData);
        } catch (e) {
          console.error('could not parse newReleaseCheckData, deleting');
          localStorage.removeItem('newReleaseCheckData');
        }
      } else {
        console.info('newReleaseCheckData not found in localStorage');
      }
    },
    saveData() {
      const parsed = JSON.stringify(this.data);
      localStorage.newReleaseCheckData = parsed;
    },
  },
};
</script>
