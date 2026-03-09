<script setup lang="ts">
import { useNow } from '@vueuse/core';
import { onMounted, onUnmounted } from 'vue';
import TotoroApiWrapper from '~/src/wrappers/TotoroApiWrapper';
import generateRunReq from '~~/src/controllers/generateSunRunExercisesReq';
import generateRoute from '~~/src/utils/generateRoute';

const now = useNow({ interval: 1000 });
const startTime = ref(new Date());
const endTime = ref(new Date());
const timePassed = computed(() => Number(now.value) - Number(startTime.value));
const needTime = ref(0);
const running = ref(false);
const sunRunPaper = useSunRunPaper();
const { params, query } = useRoute();
const session = useSession();
const { route } = params as { route: string };
const runned = computed(() => !running.value && !!needTime.value);
const target = computed(() => 
  sunRunPaper.value?.runPointList?.find((r) => r.pointId === route)
);
const useCustomTime = ref(query.custom === 'true');
const customMinutes = ref(Number(query.minutes) || 30);
const customSeconds = ref(Number(query.seconds) || 0);
const customTotalSeconds = computed(() => 
  customMinutes.value * 60 + customSeconds.value
);
const handleRun = async () => {
  try {
    console.log('[1] 开始生成跑步请求...');
    const { req, endTime: targetTime } = await generateRunReq({
      distance: sunRunPaper.value.mileage,
      routeId: target.value.pointId,
      taskId: target.value.taskId,
      token: session.value.token,
      schoolId: session.value.schoolId,
      stuNumber: session.value.stuNumber,
      phoneNumber: session.value.phoneNumber,
      minTime: useCustomTime.value ? String(Math.ceil(customTotalSeconds.value / 60)) : sunRunPaper.value.minTime,
      maxTime: useCustomTime.value ? String(Math.ceil(customTotalSeconds.value / 60)) : sunRunPaper.value.maxTime,
      customSeconds: useCustomTime.value ? String(customTotalSeconds.value) : undefined,
    });
    console.log('[2] 跑步请求生成完成');
    
    startTime.value = now.value;
    needTime.value = Number(targetTime) - Number(now.value);
    endTime.value = targetTime;
    console.log('[3] 需要等待时间:', needTime.value, 'ms');
    
    // 安全检查：确保等待时间合理
    if (needTime.value < 1000 || needTime.value > 3600000) {
      console.error('[ERROR] 等待时间异常:', needTime.value);
      throw new Error('等待时间异常');
    }
    
    running.value = true;
    console.log('[4] 开始调用 getRunBegin...');

    await TotoroApiWrapper.getRunBegin({
      campusId: session.value.campusId,
      schoolId: session.value.schoolId,
      stuNumber: session.value.stuNumber,
      token: session.value.token,
    });
    console.log('[5] getRunBegin 调用成功，设置定时器...');
    
    const timerId = setTimeout(async () => {
      try {
        console.log('[6] 定时器触发，开始提交跑步数据...');
        const res = await TotoroApiWrapper.sunRunExercises(req);
        console.log('[7] sunRunExercises 调用成功');
        const runRoute = generateRoute(sunRunPaper.value.mileage, target.value);
        await TotoroApiWrapper.sunRunExercisesDetail({
          pointList: runRoute.mockRoute,
          scantronId: res.scantronId,
          breq: {
            campusId: session.value.campusId,
            schoolId: session.value.schoolId,
            stuNumber: session.value.stuNumber,
            token: session.value.token,
          },
        });
        console.log('[8] 跑步完成');

        running.value = false;
      } catch (error) {
        console.error('[ERROR] 跑步完成时出错:', error);
        running.value = false;
      }
    }, needTime.value);
    
    console.log('[9] 定时器已设置，ID:', timerId);
    // 保存 timerId 以便后续取消（如果需要）
    (handleRun as any).__timerId = timerId;
  } catch (error) {
    console.error('[ERROR] 开始跑步时出错:', error);
    running.value = false;
    alert('开始跑步失败: ' + (error as Error).message);
  }
};
onMounted(() => {
  window.addEventListener('beforeunload', handleBeforeUnload);
});

onUnmounted(() => {
  window.removeEventListener('beforeunload', handleBeforeUnload);
});

function handleBeforeUnload(e: BeforeUnloadEvent) {
  if (running.value && !runned.value) {
    e.preventDefault();
    e.returnValue = '跑步还未完成，确定要离开吗？';
  }
}
</script>
<template>
  <div v-if="!sunRunPaper || !target">
    <VAlert type="error" class="mb-4">
      未找到跑步信息，请先从首页选择路线
    </VAlert>
    <NuxtLink to="/scanned">
      <VBtn color="primary">返回选择路线</VBtn>
    </NuxtLink>
  </div>
  <div v-else>
    <p class="text-body-1">已选择路径 {{ target.pointName }}</p>
    <p class="text-body-1 mt-2">请再次确认是否开跑</p>
    <p class="text-body-1 mt-2">开跑时会向龙猫服务器发送请求，所以请尽量不要在开跑后取消</p>
    
    <VCard class="mt-4 pa-4">
      <p class="text-body-2 font-weight-bold">跑步时长设置</p>
      <p v-if="!useCustomTime" class="text-caption mt-2">
        使用系统默认时间范围: {{ sunRunPaper.minTime }} - {{ sunRunPaper.maxTime }} 分钟
      </p>
      <p v-else class="text-body-1 mt-2">
        自定义时长: <b>{{ Math.floor(customTotalSeconds / 60) }}</b> 分 <b>{{ customTotalSeconds % 60 }}</b> 秒
      </p>
    </VCard>
    
    <VBtn 
      v-if="!runned && !running" 
      color="primary my-4" 
      append-icon="i-mdi-run" 
      @click="handleRun"
    >
      确认开跑
    </VBtn>
    <!-- 测试按钮 -->
    <VBtn 
      v-if="!runned && !running" 
      color="success my-4 ml-2" 
      @click="console.log('测试按钮被点击了')"
    >
      测试
    </VBtn>
    <template v-if="running">
      <div class="d-flex justify-space-between mt-4">
        <span>{{ timePassed }}/{{ needTime }}</span>
        <span>{{ Math.ceil((timePassed / needTime) * 100) }}%</span>
      </div>
      <VProgressLinear
        v-if="timePassed && needTime"
        color="primary"
        :model-value="(timePassed / needTime) * 100"
        class="mt-2"
      />
    </template>
    <p v-if="runned" class="mt-4">
      <b>跑步完成，去 App 里看记录吧</b>
    </p>
  </div>
</template>
