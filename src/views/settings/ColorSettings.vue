<template lang="pug">
div.d-flex.justify-content-between
  div
    h5.mb-0 폴백 컬러 사용
    small
      | 분류되지 않거나 카테고리 색상이 없을 때 일부 시각화에 색상을 사용합니다.
  div
    b-form-checkbox(v-model="useColorFallback", switch)
</template>

<script>
export default {
  name: 'ColorSettings',
  data: () => {
    return {
      useColorFallback: localStorage.useColorFallback || true,
    };
  },
  watch: {
    useColorFallback(val) {
      localStorage.useColorFallback = val;
      console.log('Set useColorFallback to ' + val);
    },
  },
};
</script>
