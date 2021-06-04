<template lang="pug">
div
  h2 데이터베이스

  b-alert(show)
    | 더 많은 데이터를 수집하려고 하는 경우 #[a(href="https://activitywatch.readthedocs.io/en/latest/watchers.html") 이 문서]를 확인하세요.

  b-table(hover, small, :items="buckets", :fields="fields", responsive="md", sort-by="last_updated", :sort-desc="true")
    template(v-slot:cell(id)="data")
      small
        | {{ data.item.id }}
    template(v-slot:cell(hostname)="data")
      small
        | {{ data.item.hostname }}
    template(v-slot:cell(last_updated)="data")
      // aw-server-python
      small(v-if="data.item.last_updated")
        | {{ data.item.last_updated | friendlytime }}
      // aw-server-rust
      small(v-if="data.item.metadata && data.item.metadata.end")
        | {{ data.item.metadata.end | friendlytime }}
    template(v-slot:cell(actions)="data")
      b-button-toolbar.float-right
        b-button-group(size="sm", class="mx-1")
          b-button(variant="primary", :to="'/buckets/' + data.item.id")
            icon(name="folder-open").d-none.d-md-inline-block
            | Open
          b-dropdown(variant="outline-secondary", size="sm", text="More")
            b-dropdown-item(
                       :href="$aw.baseURL + '/api/0/buckets/' + data.item.id + '/export'",
                       :download="'aw-bucket-export-' + data.item.id + '.json'",
                       title="Export bucket to JSON",
                       variant="secondary")
                icon(name="download")
                | Export as JSON
            b-dropdown-divider
            b-dropdown-item-button(@click="openDeleteBucketModal(data.item.id)",
                     title="Delete this bucket permanently",
                     variant="danger")
              | #[icon(name="trash")] Delete bucket

  b-modal(id="delete-modal", title="Danger!", centered, hide-footer)
    | 정말 "{{delete_bucket_selected}}" 데이터베이스를 삭제하시겠습니까?
    br
    br
    b 삭제된 데이터베이스는 복구할 수 없습니다!
    hr
    div.float-right
      b-button.mx-2(@click="$root.$emit('bv::hide::modal','delete-modal')")
        | 취소
      b-button(@click="deleteBucket(delete_bucket_selected)", variant="danger")
        | 확인

  h3 데이터베이스 가져오기 또는 내보내기

  b-card-group.deck
    b-card(header="데이터베이스 가져오기")
      b-alert(v-if="import_error" show variant="danger" dismissable)
        | {{ import_error }}
      b-form-file(v-model="import_file"
                  placeholder="여기에 파일을 선택하거나 드롭 하십시오..."
                  drop-placeholder="여기에 드롭 하십시오...")
      // TODO: This spinner could be placed in a more suitable place
      div(v-if="import_file" class="spinner-border" role="status")
      span
        | 가능한 파일은 단일 또는 여러 데이터베이스의 JSON 파일입니다.
        | 이름이 같은 데이터베이스가 있는 경우 가져오기를 실패합니다.
    b-card(header="데이터베이스 내보내기")
      b-button(:href="$aw.baseURL + '/api/0/export'",
               :download="'aw-bucket-export.json'",
               title="Export bucket to JSON",
               variant="outline-secondary")
        icon(name="download")
        | JSON으로 모든 데이터베이스 내보내기

</template>

<style lang="scss">
// This won't work if scoped
.bucket-card {
  .card-header,
  .card-footer {
    padding: 0.5em 0.75em 0.5em 0.75em;
  }

  .card-body {
    padding: 0.5em;
  }
}
</style>

<style scoped lang="scss">
.bucket-card {
  margin-bottom: 1em;
}

.bucket-last-updated {
  color: #666;
}
</style>

<script>
import 'vue-awesome/icons/trash';
import 'vue-awesome/icons/download';
import 'vue-awesome/icons/folder-open';
import _ from 'lodash';

export default {
  name: 'Buckets',
  data() {
    return {
      import_file: null,
      import_error: null,
      delete_bucket_selected: null,
      fields: [
        { key: 'id', label: 'Bucket ID', sortable: true },
        { key: 'hostname', sortable: true },
        { key: 'last_updated', label: 'Updated', sortable: true },
        { key: 'actions', label: '' },
      ],
    };
  },
  computed: {
    buckets: function () {
      return _.orderBy(this.$store.state.buckets.buckets, [b => b.id], ['asc']);
    },
  },
  watch: {
    import_file: async function (_new_value, _old_value) {
      if (this.import_file != null) {
        console.log('Importing file');
        try {
          await this.importBuckets(this.import_file);
          console.log('Import successful');
          this.import_error = null;
        } catch (err) {
          console.log('Import failed');
          // TODO: Make aw-server report error message so it can be shown in the web-ui
          this.import_error = 'Import failed, see aw-server logs for more info';
        }
        // We need to reload buckets even if we fail because imports can be partial
        // (first bucket succeeds, second fails for example when importing multiple)
        await this.$store.dispatch('buckets/loadBuckets');
        this.import_file = null;
      }
    },
  },
  mounted: async function () {
    await this.$store.dispatch('buckets/ensureBuckets');
  },
  methods: {
    openDeleteBucketModal: function (bucketId) {
      this.delete_bucket_selected = bucketId;
      this.$root.$emit('bv::show::modal', 'delete-modal');
    },
    deleteBucket: async function (bucketId) {
      await this.$store.dispatch('buckets/deleteBucket', { bucketId });
      this.$root.$emit('bv::hide::modal', 'delete-modal');
    },
    importBuckets: async function (importFile) {
      const formData = new FormData();
      formData.append('buckets.json', importFile);
      const headers = { 'Content-Type': 'multipart/form-data' };
      return this.$aw.req.post('/0/import', formData, { headers });
    },
  },
};
</script>
