<script setup lang="ts">
import TotoroApiWrapper from '~/src/wrappers/TotoroApiWrapper';

const sunrunPaper = useSunRunPaper();
const session = useSession();
const selectValue = ref('');
const useCustomTime = ref(false);
const customMinutes = ref('30');
const customSeconds = ref('0');
const customTime = computed(() => {
  const totalSeconds = Number(customMinutes.value) * 60 + Number(customSeconds.value);
  return String(Math.max(1, Math.ceil(totalSeconds / 60)));
});
const data = await TotoroApiWrapper.getSunRunPaper({
  token: session.value.token,
  campusId: session.value.campusId,
  schoolId: session.value.schoolId,
  stuNumber: session.value.stuNumber,
});
watchEffect(() => {
  if (data) {
    sunrunPaper.value = data;
  }
});

const handleUpdate = (target: string) => {
  selectValue.value = target;
};
</script>
<template>
  <p>请核对个人信息</p>
  <VTable density="compact" class="mb-6 mt-4">
    <tbody>
      <tr>
        <td>学校</td>
        <td>{{ session.campusName }}</td>
      </tr>
      <tr>
        <td>学院</td>
        <td>{{ session.collegeName }}</td>
      </tr>
      <tr>
        <td>学号</td>
        <td>{{ session.stuNumber }}</td>
      </tr>
      <tr>
        <td>姓名</td>
        <td>{{ session.stuName }}</td>
      </tr>
    </tbody>
  </VTable>
  <template v-if="data">
    <VSelect
      v-model="selectValue"
      :items="data.runPointList"
      item-title="pointName"
      item-value="pointId"
      variant="underlined"
      label="路线"
      class="mt-2"
    />
    <VCard class="mt-4 pa-4">
      <div class="d-flex align-center">
        <VSwitch v-model="useCustomTime" label="自定义跑步时间" />
        <VTooltip text="勾选后可以自定义跑步时长（精确到秒），不勾选则使用系统默认范围">
          <template #activator="{ props }">
            <VIcon v-bind="props" class="ml-2">mdi-help-circle</VIcon>
          </template>
        </VTooltip>
      </div>
      <div v-if="useCustomTime" class="d-flex align-center gap-2 mt-2">
        <VTextField
          v-model="customMinutes"
          label="分钟"
          type="number"
          :rules="[(v) => v >= 0 || '请输入有效的时间']"
          min="0"
        />
        <span class="text-h6">:</span>
        <VTextField
          v-model="customSeconds"
          label="秒"
          type="number"
          :rules="[(v) => v >= 0 || '请输入有效的时间']"
          min="0"
        />
      </div>
      <p v-if="!useCustomTime" class="text-caption mt-2">
        默认时间范围: {{ data.minTime }} - {{ data.maxTime }} 分钟
      </p>
    </VCard>
    <div class="flex gap-4 mt-4">
      <VBtn
        variant="outlined"
        color="primary"
        append-icon="i-mdi-gesture"
        @click="
          selectValue =
            data!.runPointList[Math.floor(Math.random() * data!.runPointList.length)].pointId
        "
      >
        随机路线
      </VBtn>
      <NuxtLink v-if="selectValue" :to="`/run/${encodeURIComponent(selectValue)}?custom=${useCustomTime}&minutes=${customMinutes}&seconds=${customSeconds}`">
        <VBtn class="ml-auto" color="primary" append-icon="i-mdi-arrow-right"> 开始跑步 </VBtn>
      </NuxtLink>
      <VBtn v-else class="ml-auto" color="primary" append-icon="i-mdi-arrow-right" disabled>
        开始跑步
      </VBtn>
    </div>
    <p class="mb-2 mt-6 text-xs">地图中的路线仅为展示路线生成效果，不等于最终路线</p>
    <div class="h-50vh w-50vw">
      <ClientOnly>
        <AMap :target="selectValue" @update:target="handleUpdate" />
      </ClientOnly>
    </div>
  </template>
</template>
