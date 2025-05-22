<script setup>
import {ref} from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const prenomfour=ref('')
const nomfour = ref('')
const tel1four = ref('')
const adressefour = ref('')
const tel2four = ref('') 
const codefour=ref('')
const cafour=ref('')
const soldeinitfour=ref('')
const soldefour=ref('')
const error = ref('')
const success = ref('')

//enregistrer le fournisseur
async function handleSubmit() {
  error.value = ''
  success.value = ''
  if (!nomfour.value || !codefour.value || !tel1four.value || !tel2four.value || !adressefour.value || !soldefour.value || !soldeinitfour.value) {
    error.value = "Tous les champs sont requis."
    return
  }
  const payload = {
    codefour:codefour.value,
    nomfour: nomfour.value,
    prenomfour: prenomfour.value,
    tel1four: tel1four.value,
    tel2four: tel2four.value,
    adressefour:adressefour.value,
    soldefour:soldefour.value,
    cafour:cafour.value,
    soldeinitfour:soldeinitfour.value
  }
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/fournisseur/addfournisseur.php?host=localhost&dbname=licence2025&username=root&password=', {

      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    const data = await res.json()

    if (res.ok) {
      success.value = data.message || "Fournisseur crée avec succès."
      // Petite pause avant redirection
      setTimeout(() => {
        router.push('/fournisseurs')
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
      <!-- <div class="card-header bg-primary text-white">
        <h5 class="mb-0">Ajouter un Fournisseur</h5>
      </div> -->
      <div class="card-body">
        <form @submit.prevent="handleSubmit">
          <div class="row g-3">
            <div class="col-md-4">
              <label class="form-label">Code Fournisseur *</label>
              <input v-model="codefour" type="text" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Nom *</label>
              <input v-model="nomfour" type="text" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Prénom</label>
              <input v-model="prenomfour" type="text" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Téléphone 1*</label>
              <input v-model="tel1four" type="tel" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Téléphone 2</label>
              <input v-model="tel2four" type="tel" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Adresse *</label>
              <input v-model="adressefour" type="text" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Chiffre d'affaires *</label>
              <input v-model="cafour" type="number" min="0" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Solde initial *</label>
              <input v-model="soldefour" type="number" min="0" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Solde final*</label>
              <input v-model="soldeinitfour" type="number" min="0" class="form-control" />
            </div>
          </div>
 <!-- Afficher l'erreur ou le succes selon le cas -->
 <div v-if="error" class="alert alert-danger">{{ error }}</div>
      <div v-if="success" class="alert alert-success">{{ success }}</div>
          
          <div class="mt-4 d-flex justify-content-between">
            <button type="submit" class="btn btn-success">
              <i class="bi bi-check-circle me-1"></i> Enregistrer
            </button>
            <button @click="$emit('close')" class="btn btn-secondary">
              <i class="bi bi-x-circle me-1"></i> Annuler
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
