<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'


const nom = ref('')
const telephone = ref('')
const adresse = ref('')
const type = ref('') 
const code=ref('')
const error = ref('')
const success = ref('')
const router = useRouter()

 async function handleSubmit() {
  error.value = ''
  success.value = ''
  if (!nom.value || !code.value || !type.value || !telephone.value || !adresse.value) {
    error.value = "Tous les champs sont requis."
    return
  }
  const payload = {
    codeMag:code.value,
    nomMag: nom.value,
    adresseMag: adresse.value,
    telMag: telephone.value,
    typeMag: type.value,
  }
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/magasin/createmagasin.php?host=localhost&dbname=licence2025&username=root&password=', {

      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    const data = await res.json()

    if (res.ok) {
      success.value = data.message || "Magasin crée avec succès."
      // Petite pause avant redirection
      setTimeout(() => {
        router.push('/magasin')
      }, 1500)
    } else {
      error.value = data.message || "Erreur lors de l'insertion."
    }
  } catch (e) {
    error.value = "Erreur réseau ou serveur indisponible."
    console.error(e)
  }
}
</script>

<template>
  <div class="container py-4">
    <div class="card shadow">
      <div class="card-body">
        <form @submit.prevent="handleSubmit">
          <div class="row g-3">
            <div class="col-md-6">
              <label for="nom" class="form-label">Codes*</label>
              <input v-model="code" type="text" class="form-control" id="nom" required />
            </div>
            <div class="col-md-6">
              <label for="adresse" class="form-label">Nom*</label>
              <input v-model="nom" type="text" class="form-control" id="nom" required />
            </div>
           
            <div class="col-md-6">
              <label for="telephone" class="form-label">Téléphone*</label>
              <input v-model="telephone" type="number" min="0" class="form-control" id="telephone" required />
            </div>
            <div class="col-md-6">
              <label for="adresse" class="form-label">Adresse*</label>
              <input v-model="adresse" type="text" class="form-control" id="adresse" required />
            </div>
            <div class="col-md-6">
            <label for="type" class="form-label">Type*</label>
                <select v-model="type" class="form-select" required>
              <option value="produit fini">Produit fini</option>
              <option value="matiere premiere">Matiere premiere</option>
              <option value="divers">Divers</option>
                </select>
              </div>
                    <!-- Afficher l'erreur ou le succes selon le cas -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      <div v-if="success" class="alert alert-success">{{ success }}</div>
          </div>

          <div class="mt-4 d-flex justify-content-between">
            <button type="submit" class="btn btn-success">
              <i class="bi bi-check-circle me-1"></i> Ajouter
            </button>
            <router-link to="/magasin" class="btn btn-secondary">
              <i class="bi bi-x-circle me-1"></i> Annuler
            </router-link>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<style scoped>
.form-control {
  font-size: 0.9rem;
}

.card-header {
  background-color: #007bff;
  color: white;
}

.card-body {
  padding: 20px;
}

@media (max-width: 768px) {
  .form-control {
    font-size: 0.85rem;
  }
}
</style>
