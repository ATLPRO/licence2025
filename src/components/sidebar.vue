<!-- components/sidebar.vue -->
<script setup>
import { useRouter } from 'vue-router'
import {ref,onMounted} from 'vue'

// pour les session utilisateur(directeur ou comptable)
const role=ref('')
const items = ref([])
const menusDirecteur = [
  { path: '/acceuil', label: 'Accueil', icon: 'bi-house' },
  { path: '/articles', label: 'Articles', icon: 'bi-box' },
  { path: '/magasin', label: 'Magasin', icon: 'bi-building' },
  { path: '/fournisseurs', label: 'Fournisseurs', icon: 'bi-truck' },
  { path: '/commande', label: 'Commande', icon: 'bi-cart' },
  { path: '/production', label: 'Production', icon: 'bi-gear' },
  { path: '/personnel', label: 'Personnel', icon: 'bi-people' },
]

const menusComptable = [
  { path: '/acceuil', label: 'Accueil', icon: 'bi-house' },
  { path: '/articles', label: 'Articles', icon: 'bi-file-text' },
  { path: '/magasin', label: 'Magasin', icon: 'bi-shop' },
  // Pas de Personnel ici
  { path: '/fournisseurs', label: 'Fournisseurs', icon: 'bi-truck' },
  { path: '/commande', label: 'Commandes', icon: 'bi-basket' },
  { path: '/production', label: 'Production', icon: 'bi-gear' },
]

onMounted(() => {
  const userData = JSON.parse(localStorage.getItem('users') || '{}')
  role.value = userData.role || ''
  if (role.value === 'directeur') {
    items.value = menusDirecteur
  } else if (role.value === 'comptable') {
    items.value = menusComptable
  } else {
    // Par défaut si rôle non reconnu, on met une liste réduite ou vide
    items.value = []
  }
})
const router = useRouter()
// pour la deconnexion
const logout = () => {
  const confirmed = window.confirm("Voulez-vous vraiment vous déconnecter ?")
  if (confirmed) {
    localStorage.removeItem('auth')//supprime la page d'acceuil
    router.push('/connexion') //redirige vers la page de connexion
  }
}
</script>

<template>
  <div class="bg-dark text-white h-100 p-3 ">
    <ul class="nav flex-column">
      <li v-for="item in items" :key="item.path" class="nav-item mb-2">
        <router-link
          :to="item.path"
          class="nav-link text-white d-flex align-items-center"
          :class="{ active: $route.path === item.path }"
        >
          <i :class="`bi ${item.icon} me-2`"></i>
          {{ item.label }}
        </router-link>
      </li>
    </ul>
     <!-- Bouton Déconnexion en bas -->
     <div class="mt-auto pt-3 border-top">
      <button @click="logout" class="btn btn-outline-danger w-100">
        <i class="bi bi-box-arrow-right me-1"></i> Déconnexion
      </button>
    </div>
  </div>
</template>

<style scoped>
.router-link-active {
  background-color: #1ABC9C;
  border-radius: 0.25rem;
}
/* Assure une hauteur de 100% pour que mt-auto fonctionne */
:host {
  height: 100%;
}
</style>
