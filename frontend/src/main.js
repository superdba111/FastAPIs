import { createApp } from 'vue'
import App from './App.vue'
import axios from 'axios'

// Create Vue application
const app = createApp(App)

// Configure axios globally
axios.defaults.baseURL = process.env.VUE_APP_API_URL || '/api'

app.mount('#app')