<template>
  <div class="chat-container">
    <h1>Vue Chat</h1>
    <div class="chat-input">
      <input 
        v-model="query" 
        placeholder="Ask something..." 
        @keyup.enter="ask"
      />
      <button @click="ask">Send</button>
    </div>
    <div class="chat-response" v-if="response">
      <p><strong>Response:</strong> {{ response }}</p>
    </div>
    <div v-if="error" class="error-message">
      {{ error }}
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      query: '',
      response: '',
      error: ''
    }
  },
  methods: {
    async ask() {
      if (!this.query.trim()) {
        this.error = 'Please enter a question'
        return
      }

      this.error = ''
      this.response = 'Thinking...'

      try {
        const response = await this.$axios.get(`/chat?q=${encodeURIComponent(this.query)}`)
        this.response = response.data.response
      } catch (err) {
        console.error('API error:', err)
        this.error = 'Failed to get response from the server'
        this.response = ''
      }
    }
  }
}
</script>

<style scoped>
.chat-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
  font-family: Arial, sans-serif;
}

h1 {
  color: #2c3e50;
  text-align: center;
}

.chat-input {
  display: flex;
  margin: 20px 0;
}

input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px 0 0 4px;
  font-size: 16px;
}

button {
  padding: 10px 20px;
  background-color: #42b983;
  color: white;
  border: none;
  border-radius: 0 4px 4px 0;
  cursor: pointer;
  font-size: 16px;
}

button:hover {
  background-color: #3aa876;
}

.chat-response {
  margin-top: 20px;
  padding: 15px;
  background-color: #f5f5f5;
  border-radius: 4px;
}

.error-message {
  color: #e74c3c;
  margin-top: 10px;
}
</style>