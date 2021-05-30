<template lang="pug">
div
  b-alert(v-if="$isAndroid" show)
    | #[b Note:] ActivityWatch on Android is in a very early stage of development. There will be bugs, but we hope you bear with us as we refine things and get it on par with the desktop version of ActivityWatch (which you should try!).

  h3 시스템 및 프로그램 이용시간 분석
  p
    | 이 프로그램은 사용자가 어떤 프로그램을 얼마나 사용하는지, 어떤 유형의 작업을 얼마나 
    | 소요 하는지, 어떤 웹사이트를 얼마나 사용하는지 등의 정보를 제공합니다.
    | 이 보고서를 통해 자신의 프로그램 및 시스템 사용을 분석할 수 있습니다.
  p
    | 만약 다른 시스템에서 수집된 데이터를 분석하고 싶은 경우에는 상단의 Raw Data  
    | 메뉴를 이용해서 데이터 내보내기와 가져오기를 사용하세요.
  p
    div 커뮤니티
    small 사용중 궁금한 점이 있으시면 #[a(href="https://hamonikr.org/") 하모니카 커뮤니티] 또는 #[a(href="https://github.com/hamonikr/hamonikr-activitywatch/issues") 깃허브]를 방문하세요.

  hr

  div.row
    div.col-md-6
      h4 관련 정보
      p
        ul
          li #[a(href="https://hamonikr.org/") 커뮤니티]
          li #[a(href="https://docs.hamonikr.org/hamonikr/") 도움말]
          li #[a(href="https://hamonikr.slack.com/") 슬랙 채널]
          li #[a(href="https://github.com/hamonikr/hamonikr-activitywatch/") GitHub]
          li #[a(href="/api/") API Browser]

    div.col-md-6
      h4 더 많은 정보를 알고 싶다면 
      p
        | #[a(href="https://hamonikr.org/") 하모니카 커뮤니티]를 방문하세요

  hr

  p
    small
      i
        | 프로그램 시작 페이지를 변경하고 싶은 경우에는 #[router-link(to="/settings") 설정]에서 변경하세요.

</template>

<script>
export default {
  name: 'Home',
};
</script>