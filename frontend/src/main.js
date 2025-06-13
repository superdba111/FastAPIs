// frontend/src/main.js
import { createApp } from 'vue'
import App from './App.vue'
createApp(App).mount('#app')

// frontend/src/App.vue
<template>
  <div>
    <h1>Vue Chat</h1>
    <input v-model="query" placeholder="Ask something..." />
    <button @click="ask">Send</button>
    <p v-if="response">Response: {{ response }}</p>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  data() {
    return {
      query: '',
      response: ''
    }
  },
  methods: {
    async ask() {
      const apiUrl = 'https://your-api-gateway-url/chat?q=' + encodeURIComponent(this.query)
      const res = await axios.get(apiUrl)
      this.response = res.data.response
    }
  }
}
</script>