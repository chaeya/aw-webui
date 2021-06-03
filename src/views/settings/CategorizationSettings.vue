<template lang="pug">
div
  h5.d-inline-block
    div 카테고리 설정
  div.float-right
    b-btn.ml-1(@click="restoreDefaultClasses", variant="outline-warning" size="sm")
      icon(name="undo")
      | 초기화
    label.btn.btn-sm.ml-1.btn-outline-primary(style="margin: 0")
      | 가져오기
      input(type="file" @change="importCategories" hidden)
    b-btn.ml-1(@click="exportClasses", variant="outline-primary" size="sm")
      | 내보내기
  p
    | 이벤트 분류를 위한 규칙. 이벤트는 하나의 분류만 가질 수 있습니다. 만약 몇 가지 뷴류가 일치하면 가장 많은 시간의 뷴류가 선택됩니다.
  p
    | 분류 규칙을 작성하는 방법에 대한 도움이 필요하면 #[a(href="https://docs.activitywatch.net/en/latest/features/categorization.html") 이 문서]를 참고하세요.

  div.my-4
    b-alert(variant="warning" :show="classes_unsaved_changes")
      | 저장되지 않은 변경사항이 있습니다!
      div.float-right(style="margin-top: -0.15em; margin-right: -0.6em")
        b-btn.ml-2(@click="saveClasses", variant="success" size="sm")
          | 저장하기
        b-btn.ml-2(@click="resetClasses", variant="warning" size="sm")
          | 되돌리기
    div(v-for="_class in classes_hierarchy")
      CategoryEditTree(:_class="_class")

  div.row
    div.col-sm-12
      b-btn(@click="addClass")
        icon.mr-2(name="plus")
        | 분류 추가
      b-btn.float-right(@click="saveClasses", variant="success" :disabled="!classes_unsaved_changes")
        | 저장
</template>
<script>
import { mapState, mapGetters } from 'vuex';
import CategoryEditTree from '~/components/CategoryEditTree.vue';
import 'vue-awesome/icons/undo';

export default {
  name: 'CategorizationSettings',
  components: {
    CategoryEditTree,
  },
  computed: {
    ...mapGetters('categories', ['classes_hierarchy']),
    ...mapState('categories', ['classes_unsaved_changes']),
  },
  mounted() {
    this.$store.dispatch('categories/load');
  },
  methods: {
    addClass: function () {
      this.$store.commit('categories/addClass', {
        name: ['New class'],
        rule: { type: 'regex', regex: 'FILL ME' },
      });
    },
    saveClasses: async function () {
      await this.$store.dispatch('categories/save');
    },
    resetClasses: async function () {
      await this.$store.dispatch('categories/load');
    },
    restoreDefaultClasses: async function () {
      await this.$store.commit('categories/restoreDefaultClasses');
    },
    exportClasses: function () {
      console.log('Exporting categories...');

      const export_data = {
        categories: JSON.parse(localStorage.classes),
      };
      const text = JSON.stringify(export_data);
      const filename = 'aw-category-export.json';

      // Initiate downloading a file by creating a hidden button and clicking it
      const element = document.createElement('a');
      element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
      element.setAttribute('download', filename);
      element.style.display = 'none';
      document.body.appendChild(element);
      element.click();
      document.body.removeChild(element);
    },
    importCategories: async function (elem) {
      console.log('Importing categories...');

      // Get file from upload
      const file = elem.target.files[0];
      if (file.type != 'application/json') {
        console.error('Only JSON files are possible to import');
        return;
      }

      // Read and parse import text to JSON
      const text = await file.text();
      const import_obj = JSON.parse(text);

      // Set import to categories as unsaved changes
      this.$store.commit('categories/import', import_obj.categories);
    },
  },
};
</script>
