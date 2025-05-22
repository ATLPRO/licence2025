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
  <div v-if="authPages.includes(route.path)">
    <headers/>
    <router-view />
    <footers/>
  </div>

  <!-- Sinon, affiche le layout principal -->
  <div v-else class="d-flex flex-column min-vh-100">
    <headers />
    <div class="flex-grow-1 d-flex flex-column flex-md-row">
      <!-- Sidebar -->
      <div class=" side bg-dark text-white p-2  ">
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

@media (max-width:780px) {
  .side{
    max-width: 100%;
  }
}
</style>
