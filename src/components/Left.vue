<script setup lang="ts">
import { watch,inject,ref, computed } from 'vue'
import { calculate } from '../cal/cal'
import radiain from '../assets/立绘_电弧_1.png'
import exusiai from '../assets/立绘_新约能天使_1.png'
import tragodia from '../assets/立绘_酒神_1.png'
import wisadel from '../assets/立绘_维什戴尔_skin1.png'
import yi from '../assets/头像_敌人_易.png'
import sui from '../assets/头像_敌人_岁.png'
import wang from '../assets/头像_敌人_望.png'

const topPanelHeight = 17
const middlePanelHeight = 38
const bottomPanelHeight = 100-topPanelHeight-middlePanelHeight

const globalState = inject('globalState') as any

watch([() => globalState.leftInputs, () => globalState.middleInputs, () => globalState.rightInputs], () => {
  globalState.result = calculate(globalState.leftInputs, globalState.middleInputs, globalState.rightInputs)
}, { deep: true })

const updateInput = (key: string, value: number) => {
  console.log(`更新输入: ${key} = ${value}`) // 添加日志
  globalState.leftInputs[key] = value
  console.log('当前 leftInputs:', globalState.leftInputs) // 查看更新后的状态
}

const difficulty = ref(0);

// 分离出勾选状态管理
const endingCheckedStates = ref({
  'ending1_clear': false,
  'ending1_relic': false,
  'ending2_clear': false,
  'ending2_perfect': false,
  'ending3_clear': false,
  'ending3_perfect': false,
  'ending3_both': false
})

// 图片选项配置
const banOptions = ref([
  { id: 1, name: '电弧', value: 150, checked: false, image: radiain },
  { id: 2, name: '新约能天使', value: 100, checked: false, image: exusiai },
  { id: 3, name: '酒神', value: 0, checked: false, image: tragodia },
  { id: 4, name: '维什戴尔', value: 0, checked: false, image: wisadel }
])

const handleBanChange = (option: any) => {
  const totalBan = banOptions.value
    .filter(opt => opt.checked)
    .reduce((sum, opt) => sum + opt.value, 0)
  
  console.log('计算的 totalBan:', totalBan) // 添加日志
  updateInput('ban', totalBan)
}

// 根据难度动态计算结局分值的函数
const calculateEndingValue = (baseType: string, difficulty: number): number => {
  switch (baseType) {
    case 'yi_clear': // 破岁阵祀通关
      return 0
    case 'yi_relic': // 破岁阵祀携带墨化残碑
      return 50
    case 'sui_clear': // 昔字如烟通关
      if (difficulty === 0 || difficulty === 50) return 50 // 12-13难度
      if (difficulty === 150) return 100 // 14难度
      if (difficulty === 350) return 120 // 15难度
      return 0
    case 'sui_perfect': // 昔字如烟无漏
      if (difficulty === 0 || difficulty === 50) return 80 // 12-13难度
      if (difficulty === 150) return 120 // 14难度
      if (difficulty === 350) return 150 // 15难度
      return 25
    case 'wang_clear': // 谋岁者通关
      if (difficulty === 350) return 100 // 15难度
      return 80 // 12-14难度
    case 'wang_perfect': // 谋岁者无漏
      if (difficulty === 0 || difficulty === 50 || difficulty == 150) return 100 // 12-14难度
      return 120 //15难度
    case 'wang_both': // 同时通关昔字如烟和谋岁者
      return 100
    default:
      return 0
  }
}

// 结局选项配置 
const endingOptions = computed(() => [
  {
    id: 1, 
    name: '破岁阵祀', 
    image: yi,
    subOptions: [
      { 
        id: 'ending1_clear', 
        name: '通关', 
        value: calculateEndingValue('yi_clear', difficulty.value), 
        checked: endingCheckedStates.value['ending1_clear'],
        baseType: 'yi_clear'
      },
      { 
        id: 'ending1_relic', 
        name: '携带墨化残碑', 
        value: calculateEndingValue('yi_relic', difficulty.value), 
        checked: endingCheckedStates.value['ending1_relic'],
        baseType: 'yi_relic'
      }
    ]
  },
  { 
    id: 2, 
    name: '昔字如烟', 
    image: sui,
    subOptions: [
      { 
        id: 'ending2_clear', 
        name: '通关', 
        value: calculateEndingValue('sui_clear', difficulty.value), 
        checked: endingCheckedStates.value['ending2_clear'],
        baseType: 'sui_clear'
      },
      { 
        id: 'ending2_perfect', 
        name: '无漏', 
        value: calculateEndingValue('sui_perfect', difficulty.value), 
        checked: endingCheckedStates.value['ending2_perfect'],
        baseType: 'sui_perfect'
      },
    ]
  },
  { 
    id: 3, 
    name: '谋岁者', 
    image: wang,
    subOptions: [
      { 
        id: 'ending3_clear', 
        name: '通关', 
        value: calculateEndingValue('wang_clear', difficulty.value), 
        checked: endingCheckedStates.value['ending3_clear'],
        baseType: 'wang_clear'
      },
      { 
        id: 'ending3_perfect', 
        name: '无漏', 
        value: calculateEndingValue('wang_perfect', difficulty.value), 
        checked: endingCheckedStates.value['ending3_perfect'],
        baseType: 'wang_perfect'
      },
      { 
        id: 'ending3_both', 
        name: '同时通关昔字如烟', 
        value: calculateEndingValue('wang_both', difficulty.value), 
        checked: endingCheckedStates.value['ending3_both'],
        baseType: 'wang_both'
      }
    ]
  }
])

const handleEndingChange = (subOption: any) => {
  endingCheckedStates.value[subOption.id as keyof typeof endingCheckedStates.value] = subOption.checked
  const totalEnding = endingOptions.value
    .flatMap(ending => ending.subOptions)
    .filter(opt => opt.checked)
    .reduce((sum, opt) => sum + opt.value, 0)
  
  console.log('计算的 totalEnding:', totalEnding) // 添加日志
  updateInput('ending', totalEnding)
}

watch(difficulty, () => {
  // 当难度改变时，重新计算结局总分
  const totalEnding = endingOptions.value
    .flatMap(ending => ending.subOptions)
    .filter(opt => opt.checked)
    .reduce((sum, opt) => sum + opt.value, 0)
  
  updateInput('ending', totalEnding)
})
</script>

<template>
  <div class="left-content">
    <!-- 上面板 -->
    <div class="top-panel" :style="{ height: topPanelHeight + '%' }">
      <div class="panel-content">
        <h4>挑战难度</h4>
          <el-select v-model="difficulty" 
          placeholder="挑战难度" 
          @change="updateInput('difficulty',$event) " 
          style="width: 40%;">
            <el-option label="12" :value="0"></el-option>
            <el-option label="13" :value="50"></el-option>
            <el-option label="14" :value="150"></el-option>
            <el-option label="15" :value="350"></el-option>
          </el-select>
      </div>
    </div>

    <!-- 中间面板 -->
    <div class="middle-panel" :style="{ height: middlePanelHeight + '%' }">
      <div class="panel-content">
        <h3>禁用干员</h3>
        <div class="ban-options">
          <div 
            v-for="option in banOptions" 
            :key="option.id" 
            class="option-item"
          >
            <div class="image-container">
              <img 
                :src="option.image" 
                :alt="option.name"
                class="option-image"
              />
            </div>
            <div class="checkbox-container">
              <el-checkbox 
                v-model="option.checked"
                @change="handleBanChange(option)"
                :label="option.name"
              >
              </el-checkbox>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 下面板 -->
    <div class="bottom-panel" :style="{ height: bottomPanelHeight + '%' }">
      <div class="panel-content">
        <h3>通关结局</h3>
        <div class="ending-options">
          <div 
            v-for="ending in endingOptions" 
            :key="ending.id" 
            class="ending-item"
          >
            <!-- 图片和标题 -->
            <div class="ending-header">
              <div class="ending-image-container">
                <img 
                  :src="ending.image" 
                  :alt="ending.name"
                  class="ending-image"
                />
              </div>
              <h4>{{ ending.name }}</h4>
            </div>
            
            <!-- 选项列表 -->
            <div class="sub-options">
              <div 
                v-for="subOption in ending.subOptions"
                :key="subOption.id"
                class="sub-option-item"
              >
                <el-checkbox 
                  v-model="subOption.checked"
                  @change="handleEndingChange(subOption)"
                  :label="subOption.name"
                >
                </el-checkbox>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.left-content {
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.top-panel,
.middle-panel,
.bottom-panel {
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

.ban-options {
  display: flex;
  gap: 8px;
  justify-content: space-between;
  flex-wrap: wrap;
}

.option-item {
  flex: 1;
  min-width: 100px;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10px;
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  transition: all 0.2s ease;
  background: #f8f9fa;
}

.option-item:hover {
  border-color: #007bff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 255, 255, 0.15);
}

.image-container {
  margin-bottom: 6px;
  width: 100px;
  height: 100px;
  border-radius: 6px;
  overflow: hidden;
  border: 1px solid #ffffff;
}

.option-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.2s ease;
}

.option-image:hover {
  transform: scale(1.05);
}

.checkbox-container {
  text-align: center;
}

.option-item:has(.el-checkbox.is-checked) {
  border-color: #28a745;
  background: #f8fff9;
}

.ending-options {
  display: flex;
  gap: 6px; /* 减小间距 */
  justify-content: space-between; /* 充分利用空间 */
}

.ending-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 8px;
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  background: #f8f9fa;
  transition: all 0.2s ease;
}

.ending-item:hover {
  border-color: #007bff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.ending-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 8px; /* 减小间距 */
}

.ending-image-container {
  width: 80px;
  height: 73px;
  border-radius: 6px;
  overflow: hidden;
  border: 1px solid #ffffff;
  margin-bottom: 4px;
}

.ending-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.2s ease;
}

.ending-image:hover {
  transform: scale(1.05);
}

.ending-title {
  margin: 0;
  font-weight: 600;
  color: #333;
  text-align: center;
  line-height: 1.2;
}

.sub-options {
  display: flex;
  flex-direction: column;
  gap: 0px;
  width: 100%;
}

.sub-option-item {
  padding: 0px 2px;
  border-radius: 4px;
  transition: background-color 0.2s ease;
}

.sub-option-item :deep(.el-checkbox) {
  font-size: 12px;
}

.sub-option-item :deep(.el-checkbox__label) {
  font-size: 12px; 
  color: #333;
  font-weight: 500;
  line-height: 0.8;
}

.sub-option-item :deep(.el-checkbox__input) {
  transform: scale(1.1); 
}

.selected-options {
  margin-top: 16px;
  padding: 12px;
  background: #f1f3f5;
  border-radius: 6px;
}

.selected-options h4 {
  margin: 0 0 8px 0;
  color: #495057;
  font-size: 14px;
}

.selected-options ul {
  margin: 0;
  padding-left: 20px;
}

.selected-options li {
  color: #28a745;
  font-weight: 500;
  margin-bottom: 4px;
}

h3 {
  color: #333;
  margin: 0 0 12px 0;
  font-size: 16px;
}

h4 {
  color: #333;
  margin: 0 0 8px 0;
  font-size: 14px;
}

p {
  color: #666;
  margin: 0 0 8px 0;
  line-height: 1.5;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .ban-options,
  .ending-options {
    flex-direction: column;
  }
  
  .option-item {
    flex-direction: row;
    min-width: unset;
  }
  
  .ending-item {
    flex-direction: row;
    align-items: flex-start;
  }
  
  .ending-header {
    flex-direction: row;
    align-items: center;
    margin-right: 16px;
    margin-bottom: 0;
  }
  
  .ending-image-container {
    margin-right: 12px;
    margin-bottom: 0;
  }
  
  .image-container {
    margin-right: 12px;
    margin-bottom: 0;
  }
}
</style>