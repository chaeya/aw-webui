<template lang="pug">
div
  h2 스톱워치
  p
    | 대상 데이터베이스: {{bucket_id}}

  b-alert(show)
    | 이 기능은 아직 실험적입니다.

  b-input-group(size="lg")
    b-input(v-model="label" placeholder="무슨 일을 하고 있나요?")
    b-input-group-append
      b-button(@click="startTimer(label)", variant="success")
        icon(name="play")
        | Start

  hr

  div.row
    div.col-md-12
      div(v-if="runningTimers.length > 0")
        h3 작동 중
        div(v-for="e in runningTimers" :key="e.id")
          stopwatch-entry(:event="e", :bucket_id="bucket_id", :now="now",
            @delete="removeTimer", @update="updateTimer")
          hr(style="margin: 0")
      div(v-else)
        span(style="color: #555") 스톱워치가 동작하지 않습니다
        hr

      div(v-if="stoppedTimers.length > 0")
        h3.mt-4.mb-4 이전 기록
        div(v-for="k in Object.keys(timersByDate).sort().reverse()")
          h5.mt-2.mb-1 {{ k }}
          div(v-for="e in timersByDate[k]" :key="e.id")
            stopwatch-entry(:event="e", :bucket_id="bucket_id", :now="now",
              @delete="removeTimer", @update="updateTimer", @new="startTimer(e.data.label)")
            hr(style="margin: 0")
      div(v-else)
        span(style="color: #555") 보여줄 이전 기록이 없습니다
        hr
</template>

<style scoped lang="scss">
.btn {
  margin-right: 0.5em;

  .fa-icon {
    margin-left: 0;
    margin-right: 0.5em;
  }
}
</style>

<script>
import _ from 'lodash';
import moment from 'moment';

import StopwatchEntry from '../components/StopwatchEntry.vue';
import 'vue-awesome/icons/play';
import 'vue-awesome/icons/trash';

export default {
  name: 'Stopwatch',
  components: {
    'stopwatch-entry': StopwatchEntry,
  },
  data: () => {
    return {
      bucket_id: 'aw-stopwatch',
      events: [],
      label: '',
      now: moment(),
    };
  },
  computed: {
    runningTimers() {
      return _.filter(this.events, e => e.data.running);
    },
    stoppedTimers() {
      return _.filter(this.events, e => !e.data.running);
    },
    timersByDate() {
      return _.groupBy(this.stoppedTimers, e => moment(e.timestamp).format('YYYY-MM-DD'));
    },
  },
  mounted: function () {
    // TODO: List all possible timer buckets
    //this.getBuckets();

    // Create default timer bucket
    this.$aw.ensureBucket(this.bucket_id, 'general.stopwatch', 'unknown');

    // TODO: Get all timer events
    this.getEvents();

    setInterval(() => (this.now = moment()), 1000);
  },
  methods: {
    startTimer: async function (label) {
      const event = await this.$aw.insertEvent(this.bucket_id, {
        timestamp: new Date(),
        data: {
          running: true,
          label: label,
        },
      });
      this.events.unshift(event);
    },

    updateTimer: async function (new_event) {
      const i = this.events.findIndex(e => e.id == new_event.id);
      if (i != -1) {
        // This is needed instead of this.events[i] because insides of arrays
        // are not reactive in Vue
        this.$set(this.events, i, new_event);
      } else {
        console.error(':(');
      }
    },

    removeTimer: function (event) {
      this.events = _.filter(this.events, e => e.id != event.id);
    },

    getEvents: async function () {
      this.events = await this.$aw.getEvents(this.bucket_id, { limit: 100 });
    },
  },
};
</script>
