<template>
  <div>
    <h1>Lambda API Demo</h1>
    
    <!-- Chat Section -->
    <div>
      <h2>Chat with AI</h2>
      <input v-model="chatInput" @keyup.enter="callChatAPI" />
      <button @click="callChatAPI">Send</button>
      <p v-if="chatResponse">{{ chatResponse }}</p>
    </div>

    <!-- Calculator Section -->
    <div>
      <h2>Calculator</h2>
      <input v-model.number="num1" type="number" />
      <input v-model.number="num2" type="number" />
      <button @click="callCalcAPI">Add Numbers</button>
      <p v-if="calcResult">Result: {{ calcResult }}</p>
    </div>

    <!-- Error Display -->
    <p v-if="error" style="color:red">{{ error }}</p>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      chatInput: '',
      chatResponse: '',
      num1: 2,
      num2: 3,
      calcResult: null,
      error: null
    }
  },
  methods: {
    async callChatAPI() {
      this.error = null;
      try {
        const response = await axios.get('http://localhost:8000/chat', {
          params: { q: this.chatInput }
        });
        this.chatResponse = response.data.response;
      } catch (err) {
        this.error = `Chat Error: ${err.message}`;
      }
    },
    async callCalcAPI() {
      this.error = null;
      try {
        const response = await axios.get('http://localhost:8000/calculate', {
          params: { 
            a: this.num1,
            b: this.num2
          }
        });
        this.calcResult = response.data.result;
      } catch (err) {
        this.error = `Calc Error: ${err.message}`;
      }
    }
  }
}
</script>

<style scoped>
.app-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 2rem;
  font-family: Arial, sans-serif;
}

.api-section {
  margin-bottom: 2rem;
  padding: 1rem;
  border: 1px solid #eee;
  border-radius: 8px;
}

h2 {
  color: #2c3e50;
}

input {
  padding: 0.5rem;
  margin-right: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

button {
  padding: 0.5rem 1rem;
  background-color: #42b983;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #3aa876;
}

.response {
  margin-top: 1rem;
  padding: 0.5rem;
  background-color: #f5f5f5;
  border-radius: 4px;
}
</style>