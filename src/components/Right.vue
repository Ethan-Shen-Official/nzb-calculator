<script setup lang="ts">
import { watch,inject,ref } from 'vue';
import { calculate } from '../cal/cal';

const topPanelHeight = 30;
const middlePanelHeight = 20;
const middlePanelHeight2 = 20;
const bottomPanelHeight = 100 - topPanelHeight - middlePanelHeight - middlePanelHeight2;

const globalState = inject('globalState') as any

watch([() => globalState.leftInputs, () => globalState.middleInputs, () => globalState.rightInputs], () => {
  globalState.result = calculate(globalState.leftInputs, globalState.middleInputs, globalState.rightInputs)
}, { deep: true })

const updateInput = (key: string, value: number) => {
  console.log(`更新输入: ${key} = ${value}`);
  globalState.rightInputs[key] = value;
  console.log('Right Inputs:', globalState.rightInputs);
}

// 金币隐藏选项
const hiddenOptions = ref([
  { id: 'duck', name: '鸭爵', value: 0 },
  { id: 'bear', name: '高普尼克', value: 0 },
  { id: 'dog', name: '流泪小子', value: 0 },
  { id: 'mouse', name: '圆仔', value: 0 }
])

// 扣分项选项
const extraMoney = ref(0) // 超额取钱数
const bannedOperator = ref(false) // 是否抓取禁用干员

// 结算分数
const settleScore = ref(0)

// 处理滑块变化
const handleSliderChange = (optionId: string, value: number) => {
  const option = hiddenOptions.value.find(opt => opt.id === optionId)
  if (option) {
    option.value = value
    calculateHidden()
  }
}

// 处理输入框变化
const handleInputChange = (optionId: string, value: number) => {
  const option = hiddenOptions.value.find(opt => opt.id === optionId)
  if (option) {
    // 确保值在0-10范围内
    option.value = Math.max(0, Math.min(10, value))
    calculateHidden()
  }
}

// 处理超额取钱滑块变化
const handleExtraMoneySliderChange = (value: number) => {
  extraMoney.value = value
  calculateDeducted()
}

// 处理超额取钱输入框变化
const handleExtraMoneyInputChange = (value: number) => {
  extraMoney.value = Math.max(0, Math.min(20, value)) // 假设最大20次
  calculateDeducted()
}

// 处理禁用干员复选框变化
const handleBannedOperatorChange = (value: boolean) => {
  bannedOperator.value = value
  calculateDeducted()
}

// 处理结算分数变化
const handleSettleScoreChange = (value: string | number) => {
  const numValue = typeof value === 'string' ? parseInt(value) || 0 : value || 0
  settleScore.value = Math.max(0, Math.min(9999, numValue))
  updateInput('settle', settleScore.value)
}

// 计算总的隐藏分数
const calculateHidden = () => {
  const total = hiddenOptions.value.reduce((sum, opt) => sum + opt.value, 0)
  const hiddenScore = total * 20
  updateInput('hidden', hiddenScore)
}

// 计算扣分项总分
const calculateDeducted = () => {
  const moneyDeduction = extraMoney.value * 50
  const operatorDeduction = bannedOperator.value ? 300 : 0
  const totalDeduction = moneyDeduction + operatorDeduction
  updateInput('deducted', totalDeduction)
}
</script>

<template>
  <div class="right-content">
    <div class="top-panel" :style="{height: topPanelHeight + '%'}">
      <div class="panel-content total-panel">
        <div class="total-display">
          <span class="total-label">总分：</span>
          <span class="total-value">{{ globalState.result || 0 }}</span>
        </div>
      </div>
    </div>

    <div class="middle-panel" :style="{height: middlePanelHeight + '%'}">
      <div class="panel-content">
        <h3>扣分项</h3>
        <div class="deduction-options">
          <div class="deduction-item">
            <div class="option-label">超额取钱</div>
            <div class="option-controls">
              <el-slider
                v-model="extraMoney"
                :min="0"
                :max="20"
                :step="1"
                @change="handleExtraMoneySliderChange"
                class="option-slider"
              />
              <el-input-number
                v-model="extraMoney"
                :min="0"
                :max="20"
                :step="1"
                @change="handleExtraMoneyInputChange"
                class="option-input"
                size="small"
                controls-position="right"
              />
            </div>
          </div>
          <div class="deduction-item checkbox-item">
            <div class="option-label">抓取禁用</div>
            <div class="checkbox-controls">
              <el-checkbox 
                v-model="bannedOperator"
                @change="handleBannedOperatorChange"
                class="banned-checkbox"
              >
              </el-checkbox>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="middle-panel" :style="{height: middlePanelHeight2 + '%'}">
      <div class="panel-content no-title">
        <div class="settle-table-container">
          <div class="settle-table">
            <div class="settle-label">结算分</div>
            <div class="settle-input-wrapper">
              <el-input
                v-model.number="settleScore"
                @input="handleSettleScoreChange"
                class="settle-input-field"
                size="large"
                placeholder="请输入结算分数"
                type="number"
                :min="0"
                :max="9999"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="bottom-panel" :style="{height: bottomPanelHeight + '%'}">
      <div class="panel-content">
        <h3>鸭爵金币隐藏</h3>
        <div class="hidden-options">
          <div v-for="option in hiddenOptions" :key="option.id" class="hidden-item">
            <div class="option-label">{{ option.name }}</div>
            <div class="option-controls">
              <el-slider
                v-model="option.value"
                :min="0"
                :max="10"
                :step="1"
                @change="handleSliderChange(option.id, $event)"
                class="option-slider"
              />
              <el-input-number
                v-model="option.value"
                :min="0"
                :max="10"
                :step="1"
                @change="handleInputChange(option.id, $event)"
                class="option-input"
                size="small"
                controls-position="right"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.right-content {
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

h2, h3 {
  color: #333;
  margin-bottom: 16px;
  font-size: 18px;
  text-align: center;
}

.top-panel, .middle-panel, .bottom-panel {
  overflow: hidden;
}

.panel-content {
  padding: 20px;
  height: 100%;
  overflow-y: auto;
  background-color: #ffffff;
  border: 1px solid #e1e5e9;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(255, 255, 255, 0.1);
}

.total-panel {
  display: flex;
  justify-content: center;
  align-items: center;
}

.total-display {
  text-align: center;
}

.total-label {
  font-size: 32px;
  font-weight: 600;
  color: #333;
  margin-right: 16px;
}

.total-value {
  font-size: 32px;
  font-weight: 700;
  color: #3e97f1;
}

.hidden-options, .deduction-options {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.hidden-item, .deduction-item {
  display: flex;
  align-items: center;
  gap: 16px;
}

.checkbox-item {
  justify-content: flex-start;
}

.checkbox-controls {
  display: flex;
  align-items: center;
  flex: 1;
  padding-left: 1px;
}

.settle-input-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.option-label {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  min-width: 80px;
  width: 80px;
  text-align: left;
}

.option-controls {
  display: flex;
  align-items: center;
  gap: 16px;
  flex: 1;
}

.option-slider {
  flex: 1;
  max-width: 200px;
}

.option-input {
  width: 80px;
}

.banned-checkbox :deep(.el-checkbox__label) {
  font-size: 18px;
  font-weight: 500;
  color: #333;
}

.banned-checkbox :deep(.el-checkbox__input) {
  transform: scale(1.2);
}

.option-slider :deep(.el-slider__runway) {
  height: 6px;
}

.option-slider :deep(.el-slider__button) {
  width: 16px;
  height: 16px;
}

.option-input :deep(.el-input__inner) {
  text-align: center;
  font-size: 14px;
}

.no-title {
  padding: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.settle-table-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: auto;
}

.settle-table {
  display: flex;
  align-items: center;
  border: 1px solid #e1e5e9;
  border-radius: 8px;
  overflow: hidden;
  background: #ffffff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.settle-label {
  background-color: #f5f7fa;
  color: #606266;
  font-size: 16px;
  font-weight: 600;
  padding: 20px 24px;
  border-right: 1px solid #e1e5e9;
  min-width: 100px;
  text-align: center;
}

.settle-input-wrapper {
  flex: 1;
}

.settle-input-field {
  width: 200px;
}

.settle-input-field :deep(.el-input__inner) {
  border: none;
  text-align: center;
  font-size: 20px;
  font-weight: 600;
  height: 60px;
  line-height: 60px;
  background: transparent;
}

.settle-input-field :deep(.el-input__inner):focus {
  box-shadow: none;
}

.settle-input-field :deep(.el-input__inner)::-webkit-outer-spin-button,
.settle-input-field :deep(.el-input__inner)::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.settle-input-field :deep(.el-input__inner) {
  -moz-appearance: textfield; /* Firefox */
}
</style>