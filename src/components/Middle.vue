<script setup lang="ts">
import { watch, inject, ref } from 'vue';
import { calculate } from '../cal/cal';

const topPanelHeight = 30;
const middlePanelHeight = 40;
const bottomPanelHeight = 100 - topPanelHeight - middlePanelHeight;

const globalState = inject('globalState') as any

watch([() => globalState.leftInputs, () => globalState.middleInputs, () => globalState.rightInputs], () => {
  globalState.result = calculate(globalState.leftInputs, globalState.middleInputs, globalState.rightInputs)
}, { deep: true })

const bossOptions = [
  { label: "夕娥忆", value: 1 ,val: 10},
  { label: "求道", value: 2 , val: 30},
  { label: "仁·义·武", value: 3 ,val: 30}
]

const selectedBoss = ref(0);
const handleBossSelect = (value: number) => {
  const selectedOption = bossOptions.find(option => option.value === value);
  
  if (selectedBoss.value === value) {
    selectedBoss.value = 0;
    globalState.middleInputs.boss = 0;
  } else {
    selectedBoss.value = value;
    globalState.middleInputs.boss = selectedOption ? selectedOption.val : 0;
  }
  console.log('Boss points:', globalState.middleInputs.boss);
}
</script>

<template>
  <div class="middle-content">
    <!--上面板-->
    <div class="top-panel" :style="{ height: topPanelHeight + '%' }">
      <div class="panel-content">
        <h3>险路恶敌</h3>
        
        <!-- 自定义可取消的单选框 -->
        <div class="custom-radio-group">
          <div
            v-for="option in bossOptions"
            :key="option.value"
            class="custom-radio-item"
            :class="{ 'selected': selectedBoss === option.value }"
            @click="handleBossSelect(option.value)"
          >
            <span class="radio-indicator">
              <span 
                v-if="selectedBoss === option.value" 
                class="radio-dot"
              ></span>
            </span>
            <span class="radio-label">{{ option.label }}</span>
          </div>
        </div>
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

.custom-radio-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.custom-radio-item {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.custom-radio-item:hover {
  background-color: #f5f5f5;
}

.radio-indicator {
  width: 16px;
  height: 16px;
  border: 2px solid #007bff;
  border-radius: 50%;
  margin-right: 10px;
  position: relative;
}

.radio-dot {
  width: 16px;
  height: 16px;
  background-color: #007bff;
  border-radius: 50%;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.radio-label {
  font-size: 16px;
  color: #333;
}

.selected {
  background-color: #e7f0ff;
}
</style>