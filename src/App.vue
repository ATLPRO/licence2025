<!-- App.vue -->
<script setup>
import { useRoute } from 'vue-router'
import Headers from './components/headers.vue'
import Footers from './components/footers.vue'
import Sidebar from './components/sidebar.vue'

const route = useRoute()
const authPages = ['/connexion', '/inscription', '/reinitialiser']
</script>

<template>
  <!-- Affiche uniquement la page (connexion, inscription, etc.) sans layout -->
  <div v-if="authPages.includes(route.path)" class="auth-layout">
    <headers/>
    <div class="auth-content">
      <router-view />
    </div>
    <footers/>
  </div>

  <!-- Sinon, affiche le layout principal -->
  <div v-else class="d-flex flex-column min-vh-100">
    <headers />
    <div class="flex-grow-1 d-flex flex-column flex-md-row">
      <div class="side bg-dark text-white p-2">
        <sidebar />
      </div>
      <main class="flex-grow-1 p-2 bg-light">
        <router-view />
      </main>
    </div>
    <footers />
  </div>
</template>

<style scoped>
.side{
  
  max-width: 250px;
  float: left;
}
.auth-layout {
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background: url('./assets/icons/bg.jpg') no-repeat center center;
  background-size: cover;
}

.auth-content {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
}



@media (max-width:780px) {
  .side{
    max-width: 100%;
  }
}
</style>
