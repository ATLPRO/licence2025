<!-- pages/inscription.vue -->
<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'


const name = ref('')
const email = ref('')
const passwords = ref('')
const role = ref('') // Par défaut ou tu peux ajouter un select pour choisir le rôle
const error = ref('')
const success = ref('')
const router = useRouter()

 async function handleRegister() {
  error.value = ''
  success.value = ''
  if (!name.value || !email.value || !passwords.value) {
    error.value = "Tous les champs sont requis."
    return
  }
  const payload = {
    nom: name.value,
    email: email.value,
    passwords: passwords.value,
    role: role.value,
  }
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/users/createuser.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    const data = await res.json()

    if (res.ok) {
      success.value = data.message || "Inscription réussie, vous pouvez vous connecter."
      // Petite pause avant redirection
      setTimeout(() => {
        router.push('/connexion')
      }, 1500)
    } else {
      error.value = data.message || "Erreur lors de l'inscription."
    }
  } catch (e) {
    error.value = "Erreur réseau ou serveur indisponible."
    console.error(e)
  }
}
</script>

<template>
  <div class="d-flex justify-content-center align-items-center min-vh-100 bg-light">
    <div class="card p-4 shadow" style="width: 100%; max-width: 400px">
      <h3 class="text-center text-primary mb-4">Inscription</h3>
      <!-- Afficher l'erreur ou le succes selon le cas -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      <div v-if="success" class="alert alert-success">{{ success }}</div>

      <form @submit.prevent="handleRegister">
        <div class="mb-3">
          <label class="form-label">Nom</label>
          <input v-model="name" type="text" class="form-control" required />
        </div>
        <div class="mb-3">
          <label class="form-label">Email</label>
          <input v-model="email" type="email" class="form-control" required />
        </div>
        <div class="mb-3">
          <label class="form-label">Mot de passe</label>
          <input v-model="passwords" type="password" class="form-control" required />
        </div>
        <div class="mb-3">
            <label class="form-label">Rôle</label>
            <select v-model="role" class="form-select" required>
              <option value="comptable">Comptable</option>
              <option value="directeur">Directeur</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary w-100">Créer un compte</button>
        <div class="text-center mt-3">
          <router-link to="/connexion">Déjà inscrit ? Se connecter</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped></style>
