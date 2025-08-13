<script setup lang="ts">
import { watch, inject, ref } from 'vue';
import { calculate } from '../cal/cal';

const topPanelHeight = 20;
const middlePanelHeight = 55;
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

// 紧急作战选项
const emergencyOptions = [
  // 三层
  { id: 1, label: "背山面水", clearValue: 30, perfectValue: 40 },
  { id: 2, label: "其他(三层)", clearValue: 10, perfectValue: 0 },
  
  // 四层
  { id: 3, label: "赶场戏班", clearValue: 40, perfectValue: 40 },
  { id: 4, label: "峥嵘战功", clearValue: 20, perfectValue: 30 },
  { id: 5, label: "其他(四层)", clearValue: 10, perfectValue: 0 },
  
  // 五层
  { id: 6, label: "邙山镇地方志", clearValue: 80, perfectValue: 100 },
  { id: 7, label: "青山不语", clearValue: 60, perfectValue: 80 },
  { id: 8, label: "薄礼一份", clearValue: 60, perfectValue: 80 },
  { id: 9, label: "不成烟火", clearValue: 60, perfectValue: 80 },
  { id: 10, label: "其他(五层)", clearValue: 40, perfectValue: 0 },
  
  // 六层
  { id: 11, label: "炎灼", clearValue: 100, perfectValue: 120 },
  { id: 12, label: "人镇", clearValue: 80, perfectValue: 100 }
];

// 特殊作战选项
const specialOptions = [
  { id: 101, label: "劫罚", clearValue: 0, perfectValue: 30 },
  { id: 102, label: "[紧急]劫罚", clearValue: 0, perfectValue: 40 },
  { id: 103, label: "生百相", clearValue: 0, perfectValue: 40 },
  { id: 104, label: "硕果累累", clearValue: 0, perfectValue: 30 },
  { id: 105, label: "[紧急]硕果累累", clearValue: 0, perfectValue: 40 },
  { id: 106, label: "[紧急]硅基伥的宴席", clearValue: 30, perfectValue: 50 },
  { id: 107, label: "[紧急]彻底失控", clearValue: 30, perfectValue: 50 },
  { id: 108, label: "分明", clearValue: 30, perfectValue: 0 },
  { id: 109, label: "作壁上观", clearValue: 30, perfectValue: 0 },
  { id: 110, label: "渡劫", clearValue: 20, perfectValue: 0 }
];

// 岁兽残识选项
const holeOptions = [
  { id: 201, label: "地有四难(鸭狗熊)", clearValue: 0, perfectValue: 30 },
  { id: 202, label: "地有四难(刺箱)", clearValue: 0, perfectValue: 20 },
  { id: 203, label: "迷惘", clearValue: 0, perfectValue: 30 }
];

// 每个关卡的选择状态: 0=未选择, 1=通关, 2=无漏
const emergencySelections = ref<{ [key: number]: number }>({});
const specialSelections = ref<{ [key: number]: number }>({});
const holeSelections = ref<{ [key: number]: number }>({});

const handleEmergencyChange = (stageId: number, optionType: number) => {
  if (emergencySelections.value[stageId] === optionType) {
    delete emergencySelections.value[stageId];
  } else {
    emergencySelections.value[stageId] = optionType;
  }
  calculateTotal();
}

const handleSpecialChange = (stageId: number, optionType: number) => {
  if (specialSelections.value[stageId] === optionType) {
    delete specialSelections.value[stageId];
  } else {
    specialSelections.value[stageId] = optionType;
  }
  calculateTotal();
}

const handleHoleChange = (stageId: number, optionType: number) => {
  if (holeSelections.value[stageId] === optionType) {
    delete holeSelections.value[stageId];
  } else {
    holeSelections.value[stageId] = optionType;
  }
  calculateTotal();
}

const calculateTotal = () => {
  let emergencyTotal = 0;
  let specialTotal = 0;
  let holeTotal = 0;
  
  // 计算紧急作战总分
  Object.keys(emergencySelections.value).forEach(stageId => {
    const selectedType = emergencySelections.value[parseInt(stageId)];
    const stage = emergencyOptions.find(s => s.id === parseInt(stageId));
    if (stage && selectedType) {
      if (selectedType === 1) {
        emergencyTotal += stage.clearValue;
      } else if (selectedType === 2) {
        emergencyTotal += stage.perfectValue;
      }
    }
  });
  
  // 计算特殊作战总分
  Object.keys(specialSelections.value).forEach(stageId => {
    const selectedType = specialSelections.value[parseInt(stageId)];
    const stage = specialOptions.find(s => s.id === parseInt(stageId));
    if (stage && selectedType) {
      if (selectedType === 1) {
        specialTotal += stage.clearValue;
      } else if (selectedType === 2) {
        specialTotal += stage.perfectValue;
      }
    }
  });
  
  // 计算岁兽残识总分
  Object.keys(holeSelections.value).forEach(stageId => {
    const selectedType = holeSelections.value[parseInt(stageId)];
    const stage = holeOptions.find(s => s.id === parseInt(stageId));
    if (stage && selectedType) {
      if (selectedType === 1) {
        holeTotal += stage.clearValue;
      } else if (selectedType === 2) {
        holeTotal += stage.perfectValue;
      }
    }
  });
  
  globalState.middleInputs.emergency = emergencyTotal;
  globalState.middleInputs.special = specialTotal;
  globalState.middleInputs.hole = holeTotal;
  console.log('Emergency total:', emergencyTotal, 'Special total:', specialTotal, 'Hole total:', holeTotal);
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

    <!--中间面板（合并紧急作战和特殊作战）-->
    <div class="middle-panel" :style="{ height: middlePanelHeight + '%' }">
      <div class="panel-content">
        <!-- 紧急作战 -->
        <h3>紧急作战</h3>
        <div class="combat-list">
          <div 
            v-for="stage in emergencyOptions" 
            :key="stage.id" 
            class="combat-stage"
          >
            <span class="stage-name">{{ stage.label }}</span>
            <div class="stage-options">
              <el-checkbox
                v-if="stage.clearValue > 0"
                :model-value="emergencySelections[stage.id] === 1"
                @change="handleEmergencyChange(stage.id, 1)"
                label="通关"
              />
              <el-checkbox
                v-if="stage.perfectValue > 0"
                :model-value="emergencySelections[stage.id] === 2"
                @change="handleEmergencyChange(stage.id, 2)"
                label="无漏"
              />
            </div>
          </div>
        </div>

        <!-- 特殊作战 -->
        <h3 style="margin-top: 20px;">特殊作战</h3>
        <div class="combat-list">
          <div 
            v-for="stage in specialOptions" 
            :key="stage.id" 
            class="combat-stage"
          >
            <span class="stage-name">{{ stage.label }}</span>
            <div class="stage-options">
              <el-checkbox
                v-if="stage.clearValue > 0"
                :model-value="specialSelections[stage.id] === 1"
                @change="handleSpecialChange(stage.id, 1)"
                label="通关"
              />
              <el-checkbox
                v-if="stage.perfectValue > 0"
                :model-value="specialSelections[stage.id] === 2"
                @change="handleSpecialChange(stage.id, 2)"
                label="无漏"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!--下面板（岁兽残识）-->
    <div class="bottom-panel" :style="{ height: bottomPanelHeight + '%' }">
      <div class="panel-content">
        <h3>岁兽残识</h3>
        
        <!-- 岁兽残识选项 -->
        <div class="combat-list">
          <div 
            v-for="stage in holeOptions" 
            :key="stage.id" 
            class="combat-stage"
          >
            <span class="stage-name">{{ stage.label }}</span>
            <div class="stage-options">
              <el-checkbox
                v-if="stage.clearValue > 0"
                :model-value="holeSelections[stage.id] === 1"
                @change="handleHoleChange(stage.id, 1)"
                label="通关"
              />
              <el-checkbox
                v-if="stage.perfectValue > 0"
                :model-value="holeSelections[stage.id] === 2"
                @change="handleHoleChange(stage.id, 2)"
                label="无漏"
              />
            </div>
          </div>
        </div>
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

h2, h3 {
  color: #333;
  margin-bottom: 16px;
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

/* 险路恶敌样式 */
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

.combat-list {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.combat-stage {
  display: flex;
  align-items: center;
  padding: 2px 0;
}

.stage-name {
  padding: 2px;
  font-size: 15px;
  color: #333;
  font-weight: 550;
  width: 140px;
  flex-shrink: 0; 
  text-align: left;
}

.stage-options {
  display: flex;
  gap: 4px;
  margin-left: 16px; 
}

.stage-options :deep(.el-checkbox) {
  font-size: 16px;
}

.stage-options :deep(.el-checkbox__label) {
  font-size: 16px;
  color: #333;
  font-weight: 500;
  line-height: 0.8;
}

.stage-options :deep(.el-checkbox__input) {
  transform: scale(1.0);
}
</style>