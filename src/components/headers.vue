<script setup>
import {ref, onMounted } from 'vue'
import {useRoute} from 'vue-router'
const route = useRoute()
const personnelNom=ref('')
const authPages = ['/connexion', '/inscription', '/reinitialiser']
const chargerNomPersonnel = () => {
  const utilisateur = JSON.parse(localStorage.getItem('utilisateurConnecte'))
  if (utilisateur) {
    personnelNom.value = utilisateur.nompers
  }
}
onMounted(async () => {
   chargerNomPersonnel()
})


</script>

<template>
  <header class="bg-primary text-white p-3 d-flex justify-content-between align-items-center">
    <h1 class="h4 mb-0">GestPro</h1>
    <span v-if="authPages.includes(route.path)">Bienvenue</span>
    <span v-else >Bienvenue  " {{ personnelNom.toLocaleUpperCase() }} "</span>
  </header>
</template>

<style scoped>
.bg-primary {
  background-color: #2C3E50 !important;
}
header{
  height: 50px;
  flex-shrink: 0;
}


</style>
