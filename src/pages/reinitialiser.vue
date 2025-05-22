<!-- pages/reinitialiserpwd.vue -->
<script setup>
import { ref } from 'vue'
import {useRouter} from 'vue-router'

const nouveau = ref('')
const confirm=ref('')
const email=ref('')
const error = ref('')
const success = ref('')
const router = useRouter()

async function handleReset() {
  error.value = ''
  success.value = ''

  if (!email.value || !nouveau.value || !confirm.value) {
    error.value = "Tous les champs sont obligatoires."
    return
  }

  if (nouveau.value !== confirm.value) {
    error.value = "Les mots de passe ne correspondent pas."
    return
  }

  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/users/resetpassword.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: email.value,
        new_password: nouveau.value
      })
    })

    const data = await res.json()

    if (res.ok) {
      success.value = data.message || "Mot de passe réinitialisé avec succès."
      setTimeout(() => {
        router.push('/connexion')
      }, 2000)
    } else {
      error.value = data.message || "Erreur lors de la réinitialisation du mot de passe."
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
      <h3 class="text-center text-primary mb-4">Mot de passe oublié</h3>

      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      <div v-if="success" class="alert alert-success">{{ success }}</div>

      <form @submit.prevent="handleReset">
        <div class="mb-3">
          <label class="form-label">email</label>
          <input v-model="email" type="email" class="form-control" required />
        </div>
        <div class="mb-3">
          <label class="form-label">Nouveau mot de passe</label>
          <input v-model="nouveau" type="text" class="form-control" required />
        </div>
        <div class="mb-3">
          <label class="form-label">Confirmer</label>
          <input v-model="confirm" type="text" class="form-control" required />
        </div>
        <button type="submit" class="btn btn-primary w-100">Réinitialiser</button>
        <div class="text-center mt-3">
          <router-link to="/connexion">Retour à la connexion</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped></style>
