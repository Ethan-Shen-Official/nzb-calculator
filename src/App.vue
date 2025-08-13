<script setup lang="ts">
import Left from './components/Left.vue'
import Middle from './components/Middle.vue'
import Right from './components/Right.vue'
import Header from './components/Header.vue'
import { reactive,provide } from 'vue'

const globalState = reactive({
  leftInputs: {
    difficulty: 0,
    ban:0,
    ending:0
  },
  middleInputs: {
    boss: 0,
    emergency: 0,
    special: 0,
    hole: 0
  },
  rightInputs: {

  },
  result: 0
})

provide('globalState', globalState)
</script>

<template>
  <div class="app-container">
    <div class="content">
      <div class="left-panel">
        <Left />
      </div>
      <div class="middle-panel">
        <Middle />
      </div>
      <div class="right-panel">
        <Right />
      </div>
    </div>
  </div>
</template>

<style>
body {
  margin: 0;
  padding: 0;
}

#app {
  margin: 0;
  padding: 0;
}
</style>

<style scoped>
.app-container {
  display: flex;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  flex-direction: column;
  background-color: #ffffff;
}

.content {
  display: flex;
  flex: 1;
  height: 100%;
  gap: 16px;
  padding: 16px;
}

.left-panel {
  flex: 1.5;
  background-color: #f9f9f9;
  border-radius: 12px;
  padding: 20px;
  overflow-y: auto;
  box-shadow: 0 2px 8px rgba(255, 255, 255, 0.1);
}

.middle-panel {
  flex: 1;
  background-color: #f9f9f9;
  border-radius: 12px;
  padding: 20px;
  overflow-y: auto;
  box-shadow: 0 2px 8px rgba(255, 255, 255, 0.1);
}

.right-panel {
  flex: 1;
  background-color: #f9f9f9;
  border-radius: 12px;
  padding: 20px;
  overflow-y: auto;
  box-shadow: 0 2px 8px rgba(255, 255, 255, 0.1);
}
</style>
