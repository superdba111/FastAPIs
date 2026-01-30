<template>
  <div class="app-container">
    <aside class="sidebar">
      <div class="brand">NWS Data Lake</div>
      <nav>
        <div class="menu-label">ADMIN CONSOLE</div>
        <a href="#" class="active">Users</a>
        <a href="#">API Keys</a>
        
        <div class="menu-label mt-4">CONSUMER PORTAL</div>
        <a href="#" class="disabled">My API Keys</a>
        <a href="#" class="disabled">Data Catalog</a>
      </nav>
    </aside>

    <main class="content">
      <header>
        <h2>User Management</h2>
        <button class="btn-primary" @click="openCreateModal">+ Create Admin User</button>
      </header>

      <div class="card">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Email</th>
              <th>Type</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in users" :key="user.user_id">
              <td>{{ user.user_id }}</td>
              <td>{{ user.first_name }} {{ user.last_name }}</td>
              <td>{{ user.email }}</td>
              <td><span class="badge">{{ user.type }}</span></td>
              <td>
                <span :class="['badge', user.status === 'ACTIVE' ? 'bg-green' : 'bg-red']">
                  {{ user.status }}
                </span>
              </td>
              <td>
                <button class="btn-sm" @click="openEditModal(user)">Edit</button>
                <button class="btn-sm btn-danger" @click="openDeleteModal(user)">Delete</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </main>

    <div v-if="showCreate" class="modal-overlay">
      <div class="modal">
        <h3>Create New Administrator</h3>
        <form @submit.prevent="createUser">
          <div class="row">
            <input v-model="form.first_name" placeholder="First Name" required />
            <input v-model="form.last_name" placeholder="Last Name" required />
          </div>
          <input v-model="form.email" type="email" placeholder="Email" required />
          <div class="row">
            <label>Type: <strong>ADMIN</strong></label>
            <select v-model="form.status">
              <option value="ACTIVE">ACTIVE</option>
              <option value="INACTIVE">INACTIVE</option>
            </select>
          </div>
          <div class="actions">
            <button type="button" @click="showCreate = false">Cancel</button>
            <button type="submit" class="btn-primary">Create</button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="showEdit" class="modal-overlay">
      <div class="modal">
        <h3>Edit User: {{ currentUser.user_id }}</h3>
        <p class="meta">Created: {{ currentUser.created_at }}</p>
        <form @submit.prevent="updateUser">
          <div class="row">
            <input v-model="currentUser.first_name" placeholder="First Name" />
            <input v-model="currentUser.last_name" placeholder="Last Name" />
          </div>
          <input v-model="currentUser.email" placeholder="Email" />
          <select v-model="currentUser.status">
            <option value="ACTIVE">ACTIVE</option>
            <option value="INACTIVE">INACTIVE</option>
          </select>
          <div class="actions">
            <button type="button" @click="showEdit = false">Cancel</button>
            <button type="submit" class="btn-primary">Save Changes</button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="showDelete" class="modal-overlay">
      <div class="modal">
        <h3>Delete User</h3>
        <p>Are you sure you want to remove <strong>{{ currentUser.email }}</strong>?</p>
        <div class="delete-options">
          <label>
            <input type="radio" v-model="deleteMode" :value="false" />
            Soft Delete (Mark Inactive)
          </label>
          <label>
            <input type="radio" v-model="deleteMode" :value="true" />
            Hard Delete (Permanent)
          </label>
        </div>
        <div class="actions">
          <button type="button" @click="showDelete = false">Cancel</button>
          <button @click="confirmDelete" class="btn-danger">Confirm</button>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import axios from 'axios';
const API_URL = process.env.VUE_APP_API_URL || "http://localhost:8000";

export default {
  data() {
    return {
      users: [],
      showCreate: false,
      showEdit: false,
      showDelete: false,
      deleteMode: false,
      currentUser: {},
      form: { first_name: '', last_name: '', email: '', type: 'ADMIN', status: 'ACTIVE' }
    };
  },
  mounted() {
    this.fetchUsers();
  },
  methods: {
    async fetchUsers() {
      try {
        const res = await axios.get(`${API_URL}/users/`);
        this.users = res.data;
      } catch (e) { alert("Failed to load users"); }
    },
    openCreateModal() {
      this.showCreate = true;
    },
    async createUser() {
      try {
        await axios.post(`${API_URL}/users/`, this.form);
        this.showCreate = false;
        this.fetchUsers();
        this.form = { first_name: '', last_name: '', email: '', type: 'ADMIN', status: 'ACTIVE' };
      } catch (e) { alert(e.response?.data?.detail || "Create failed"); }
    },
    openEditModal(user) {
      this.currentUser = { ...user }; // Copy object
      this.showEdit = true;
    },
    async updateUser() {
      try {
        await axios.patch(`${API_URL}/users/${this.currentUser.user_id}`, {
          first_name: this.currentUser.first_name,
          last_name: this.currentUser.last_name,
          email: this.currentUser.email,
          status: this.currentUser.status
        });
        this.showEdit = false;
        this.fetchUsers();
      } catch (e) { alert("Update failed"); }
    },
    openDeleteModal(user) {
      this.currentUser = user;
      this.deleteMode = false; // Default to Soft Delete
      this.showDelete = true;
    },
    async confirmDelete() {
      try {
        await axios.delete(`${API_URL}/users/${this.currentUser.user_id}`, {
          params: { hard_delete: this.deleteMode }
        });
        this.showDelete = false;
        this.fetchUsers();
      } catch (e) { alert("Delete failed"); }
    }
  }
};
</script>

<style>
/* Basic Styles for Admin Dashboard */
.app-container { display: flex; height: 100vh; font-family: Arial, sans-serif; }
.sidebar { width: 250px; background: #2c3e50; color: white; padding: 20px; }
.content { flex: 1; padding: 20px; background: #f4f7f6; }
.brand { font-size: 1.2rem; font-weight: bold; margin-bottom: 2rem; }
.menu-label { font-size: 0.8rem; opacity: 0.7; margin-bottom: 10px; }
.sidebar a { display: block; padding: 10px; color: white; text-decoration: none; }
.sidebar a.active { background: #34495e; }
.sidebar a.disabled { opacity: 0.5; pointer-events: none; }
table { width: 100%; border-collapse: collapse; background: white; }
th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: left; }
.btn-primary { background: #42b983; color: white; border: none; padding: 8px 16px; cursor: pointer; }
.btn-danger { background: #e74c3c; color: white; border: none; padding: 5px 10px; cursor: pointer; }
.btn-sm { padding: 5px 10px; margin-right: 5px; cursor: pointer; }
.badge { padding: 4px 8px; border-radius: 12px; font-size: 0.8em; background: #eee; }
.bg-green { background: #d4edda; color: #155724; }
.bg-red { background: #f8d7da; color: #721c24; }
.modal-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; }
.modal { background: white; padding: 20px; width: 400px; border-radius: 8px; }
.row { display: flex; gap: 10px; margin-bottom: 10px; }
input, select { width: 100%; padding: 8px; margin-bottom: 10px; box-sizing: border-box; }
.actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
</style>