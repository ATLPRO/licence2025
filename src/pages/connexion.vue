<!-- pages/connexion.vue -->
<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useFetch } from '@vueuse/core'

const email = ref('')
const passwords = ref('')
const error = ref('')
const router = useRouter()
const name=ref('')

const login = async () => {
  const { data: responseData } = await useFetch(`http://localhost/apiLicence2025/controller/users/readalluser.php?host=localhost&dbname=licence2025&username=root&password=&email=${email.value}&passwords=${passwords.value}`)
    .get()
    .json()
    console.log(email.value, passwords.value)
  console.log('Réponse API :', responseData.value)
  if (!responseData.value ||  responseData.value.length==0){
    error.value = "Identifiants incorrects"
  }
  else{
    //console.log("Connexion réussie, redirection...")
    localStorage.setItem('users', JSON.stringify(responseData.value));
    //console.log("Rôle :", responseData.value.role)

    localStorage.setItem('auth', 'true')
     // Redirection selon rôle
     if (responseData.value.role === 'directeur') {
        router.push('/acceuil')

    } /* else if (responseData.value.role === 'comptable') {
      router.push('/accueil-comptable');
    } */else { 
      router.push('/acceuil') // page par défaut
    }
   
  }
}
</script>

<template>
  <div class="container d-flex justify-content-center align-items-center min-vh-100 bg-light ">
    <div class="card p-4 shadow " style="min-width: 350px;">
      <h3 class="text-center text-primary mb-3">Connexion</h3>
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      <form @submit.prevent="login">
      <input v-model="email" class="form-control mb-2" placeholder="Email" type="email" />
      <input v-model="passwords" class="form-control mb-3" placeholder="Mot de passe" type="password" />
      <button type="submit" class="btn btn-primary w-100">Se connecter</button>
      <div class="mt-3 text-center">
        <router-link to="/inscription">Créer un compte</router-link> |
        <router-link to="/reinitialiser">Mot de passe oublié ?</router-link>
      </div>
    </form>
    </div>
  </div>
</template>

<style scoped>

</style>
