<script setup lang="ts">
import { watch,inject } from 'vue';
import { calculate } from '../cal/cal';

const topPanelHeight = 20;
const middlePanelHeight = 60;
const bottomPanelHeight = 100 - topPanelHeight - middlePanelHeight;

const globalState = inject('globalState') as any

watch([() => globalState.leftInputs, () => globalState.middleInputs, () => globalState.rightInputs], () => {
  globalState.result = calculate(globalState.leftInputs, globalState.middleInputs, globalState.rightInputs)
}, { deep: true })
</script>

<template>
  <div class="middle-content">
    <!--上面板-->
    <div class="top-panel" :style="{ height: topPanelHeight + '%' }">
      <div class="panel-content">
        <h2>上面板</h2>
        <!-- 这里可以添加上面板的内容 -->
        <p>这里是上面板的内容</p>
      </div>
    </div>

    <!--中间面板-->
    <div class="middle-panel" :style="{ height: middlePanelHeight + '%' }">
      <div class="panel-content">
        <h2>中间面板</h2>
      <!-- 这里可以添加中间面板的内容 -->
      <p>这里是中间面板的内容</p>
      </div>
    </div>

    <!--下面板-->
    <div class="bottom-panel" :style="{ height: bottomPanelHeight + '%' }">
      <div class="panel-content">
      <h2>下面板</h2>
      <!-- 这里可以添加下面板的内容 -->
      <p>这里是下面板的内容</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.middle-content {
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 12px; 
}

h2 {
  color: #333;
  margin-bottom: 20px;
}

.top-panel, .middle-panel, .bottom-panel {
  overflow: hidden;
}

.panel-content {
  height: 100%;
  padding: 20px;
  overflow-y: auto;
  background-color: #ffffff;
  border: 1px solid #e1e5e9;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(255, 255, 255, 0.1);
}
</style>