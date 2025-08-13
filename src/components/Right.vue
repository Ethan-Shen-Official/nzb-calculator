<script setup lang="ts">

const topPanelHeight = 30;
const middlePanelHeight = 20;
const middlePanelHeight2 = 20;
const bottomPanelHeight = 100 - topPanelHeight - middlePanelHeight - middlePanelHeight2;
</script>

<template>
  <div class="right-content">
    <div class="top-panel" :style="{height: topPanelHeight + '%'}">
      <div class="panel-content">

      </div>
    </div>

    <div class="middle-panel" :style="{height: middlePanelHeight + '%'}">
      <div class="panel-content">

      </div>
    </div>

    <div class="middle-panel" :style="{height: middlePanelHeight2 + '%'}">
      <div class="panel-content">

      </div>
    </div>

    <div class="bottom-panel" :style="{height: bottomPanelHeight + '%'}">
      <div class="panel-content">

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

h2 {
  color: #333;
  margin-bottom: 20px;
}

.top-panel, .middle-panel, .bottom-panel {
  overflow: hidden;
}

.panel-content {
  padding: 20px;
  height: 100%;
  overflow-y: hidden;
  background-color: #ffffff;
  border: 1px solid #e1e5e9;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(255, 255, 255, 0.1);
}
</style>